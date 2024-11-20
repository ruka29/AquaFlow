import axios from "axios";

import User from "../models/User.js";

export const registerDevice = async (req, res) => {
  const {
    macAddress,
    deviceName,
    valveState,
    waterLevel,
    lowThreshold,
    highThreshold,
    email,
  } = req.body;

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
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

    res
      .status(200)
      .json({ message: "Device registered successfully", device: newDevice });
  } catch (error) {
    console.error("Error registering device:", error);
    res.status(500).json({ error: "Failed to register device" });
  }
};

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

const sendThresholdUpdateToDevice = async ({ macAddress, lowThreshold, highThreshold }) => {
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

