import axios from "axios";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../models/User.js";
// import { sendWaterLevelToMobileApp, sendValveStateToMobileApp } from "../services/notificationService.js";
import { broadcastToUser, connectedDevices } from "../services/socketService.js";

//register device to user
export const registerDevice = async (req, res) => {
  const {
    macAddress,
    deviceName,
    valveState,
    waterLevel,
    lowThreshold,
    highThreshold,
  } = req.body;

  try {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const userId = decoded.user?.id || decoded.id;

    if (!userId) {
      return res.status(401).json({ message: "Invalid token payload" });
    }

    const user = await User.findById(userId).select("-password");
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const existingDevice = user.devices.find(
      (device) => device.macAddress === macAddress
    );

    if (existingDevice) {
      return res
        .status(400)
        .json({ error: "Device already registered to this user" });
    }

    const newDevice = {
      macAddress,
      deviceName,
      valveState,
      waterLevel,
      lowThreshold,
      highThreshold,
    };

    user.devices.push(newDevice);
    await user.save();

    res.status(200).json({ message: "Device registered successfully" });
  } catch (error) {
    console.error("Error registering device:", error);
    res.status(500).json({ error: "Failed to register device" });
  }
};

export const getDeviceData = async (req, res) => {
  const { macAddress } = req.body;

  try {
    const user = await User.findOne({ "devices.macAddress": macAddress });

    if (!user) {
      return res
        .status(404)
        .json({ error: "Device not associated with any user" });
    }

    const device = user.devices.find(
      (device) => device.macAddress === macAddress
    );

    if (!device) {
      return res.status(404).json({ error: "Device not found" });
    }

    res.status(200).json(device);
  } catch (error) {
    console.error("Error getting device data:", error);
    res.status(500).json({ message: "Failed to get device data" });
  }
};

//change tank data(capacity and height)
export const updateTankData = async (req, res) => {
  const { email, macAddress, tankCapacity, tankHeight } = req.body;

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const device = user.devices.find(
      (device) => device.macAddress === macAddress
    );

    if (!device) {
      return res.status(404).json({ error: "Device not found" });
    }

    if (tankCapacity !== undefined) device.tankCapacity = tankCapacity;
    if (tankHeight !== undefined) device.tankHeight = tankHeight;

    await user.save();

    res.status(200).json({ message: "Tank data updated successfully", device });
  } catch (error) {
    console.error("Error updating tank data:", error);
    res.status(500).json({ error: "Failed to update tank data" });
  }
};

//update threshold values
export const updateThresholds = async (req, res) => {
  const { email, macAddress, lowThreshold, highThreshold } = req.body;

  const user = await User.findOne({ email });

  if (!user) {
    return res.status(404).json({ error: "User not found" });
  }

  const device = user.devices.find(
    (device) => device.macAddress === macAddress
  );

  if (!device) {
    return res.status(404).json({ error: "Device not found" });
  }

  try {
    const deviceResponse = await sendThresholdUpdateToDevice({
      macAddress,
      lowThreshold,
      highThreshold,
    });

    if (deviceResponse.status !== 200) {
      return res
        .status(500)
        .json({ error: "Failed to update device thresholds" });
    }

    if (lowThreshold !== undefined) device.lowThreshold = lowThreshold;
    if (highThreshold !== undefined) device.highThreshold = highThreshold;

    await user.save();

    res.status(200).json({
      message: "Threshold values updated successfully",
      deviceResponse: deviceResponse.data,
    });
  } catch (error) {
    console.error("Error updating threshold values:", error.message);
    res.status(500).json({ error: "Failed to update threshold values" });
  }
};

//send updated threshold values to device
const sendThresholdUpdateToDevice = async ({
  macAddress,
  lowThreshold,
  highThreshold,
}) => {
  try {
    const deviceApiUrl = `http://device-ip-or-cloud-endpoint/update-threshold`;

    const response = await axios.post(deviceApiUrl, {
      macAddress,
      lowThreshold,
      highThreshold,
    });

    return response;
  } catch (error) {
    console.error("Failed to send thresholds to device:", error.message);
    throw new Error("Device communication failed");
  }
};

//update water level
export const updateWaterLevel = async (req, res) => {
  const { macAddress, waterLevel } = req.body;

  try {
    const user = await User.findOne({ "devices.macAddress": macAddress });

    if (!user) {
      return res
        .status(404)
        .json({ error: "Device not associated with any user" });
    }

    const device = user.devices.find(
      (device) => device.macAddress === macAddress
    );

    if (!device) {
      return res.status(404).json({ error: "Device not found" });
    }

    device.waterLevel = waterLevel;

    await user.save();

    // await sendWaterLevelToMobileApp(user.email, macAddress, waterLevel);

    res.status(200).json({ message: "Water level updated successfully" });
  } catch (error) {
    console.error("Error updating water level:", error.message);
    res.status(500).json({ error: "Failed to update water level" });
  }
};

//update valve state
export const controlValve = async (req, res) => {
  const { macAddress, valveState, source } = req.body;

  try {
    // Find the user and the specific device
    const user = await User.findOne({ "devices.macAddress": macAddress });
    if (!user) {
      return res.status(404).json({ error: "Device not found" });
    }

    const device = user.devices.find((d) => d.macAddress === macAddress);
    if (!device) {
      return res.status(404).json({ error: "Device not found" });
    }

    const currentTime = new Date();
    const currentWaterLevel = device.waterLevel;

    // Handle source = "mobile"
    if (source === "mobile") {
      const success = await sendRequestToDevice(macAddress, valveState); // Send valve state to the device

      if (success) {
        // Update the database
        await updateValveStateInDatabase(
          device,
          valveState,
          currentTime,
          currentWaterLevel
        );
        await user.save();

        // Send acknowledgment back to the mobile app
        return res
          .status(200)
          .json({ message: "Valve state updated successfully" });
      } else {
        return res
          .status(500)
          .json({ error: "Failed to update valve state on device" });
      }
    } else if (source === "device") {
      // Update the database
      await updateValveStateInDatabase(
        device,
        valveState,
        currentTime,
        currentWaterLevel
      );
      await user.save();

      // Notify the mobile app via WebSocket
      broadcastToUser(user._id.toString(), {
        type: "valveStateUpdate",
        macAddress,
        valveState,
        waterLevel: currentWaterLevel,
      });

      return res
        .status(200)
        .json({ message: "Valve state updated and mobile app notified" });
    } else {
      return res.status(400).json({ error: "Invalid source" });
    }
  } catch (error) {
    console.error("Error controlling valve:", error.message);
    res.status(500).json({ error: "Failed to control valve" });
  }
};

//get current water level from device
const getCurrentWaterLevel = async (macAddress) => {
  try {
    const deviceUrl = `http://${macAddress}/water-level`;

    const response = await axios.get(deviceUrl);
    return response.data.waterLevel;
  } catch (error) {
    console.error("Failed to get water level from device:", error.message);
    throw new Error("Failed to fetch water level");
  }
};

//update valve state in database
const updateValveStateInDatabase = async (
  device,
  valveState,
  currentTime,
  currentWaterLevel
) => {
  if (valveState === 1 || valveState === true) {
    const usage = device.valveCloseLevel - currentWaterLevel;

    device.valveState = true;
    device.valveOpenTime = currentTime;
    device.valveOpenLevel = currentWaterLevel;
    device.thisMonthUsage += usage > 0 ? usage : 0;
  } else if (valveState === 0 || valveState === false) {
    device.valveState = false;
    device.valveCloseTime = currentTime;
    device.valveCloseLevel = currentWaterLevel;
  }
};

//send updated valve state to device
export const sendRequestToDevice = async (macAddress, valveState) => {
  try {
    const deviceSocket = connectedDevices.get(macAddress); // Get the WebSocket for the given MAC address

    if (deviceSocket && deviceSocket.readyState === 1) { // Check if the device is connected
      deviceSocket.send(
        JSON.stringify({
          type: "control-valve",
          valveState,
        })
      );
      console.log(`Message sent to device [${macAddress}]:`, message);
      return true;
    } else {
      console.error(`Device with MAC address ${macAddress} is not connected`);
      return false;
    }
  } catch (error) {
    console.error("Error sending request to device:", error.message);
    return false;
  }
};

export const heartbeat = async (req, res) => {
  const { macAddress } = req.body;

  try {
    const user = await User.findOne({ "devices.macAddress": macAddress });
    if (!user) {
      return res.status(404).json({ error: "Device not found" });
    }

    const device = user.devices.find((d) => d.macAddress === macAddress);
    if (!device) {
      return res
        .status(404)
        .json({ error: "Device not found in user's account" });
    }

    device.status = "online";
    device.lastPing = new Date();

    await user.save();

    res.status(200).json({ message: "Heartbeat received, device is online" });
  } catch (error) {
    console.error("Error processing heartbeat:", error);
    res.status(500).json({ error: "Failed to update device status" });
  }
};
