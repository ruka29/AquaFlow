// deviceRegistration.js
import jwt from 'jsonwebtoken';
import User from '../models/User.js'; // Adjust the import path as needed

export const registerDevice = async (ws, parsedMessage) => {
  const { 
    macAddress, 
    deviceName, 
    valveState, 
    waterLevel, 
    lowThreshold, 
    highThreshold 
  } = parsedMessage.data;

  console.log("is this running");

  try {
    const decoded = jwt.verify(parsedMessage.token, process.env.JWT_SECRET);
    const userId = decoded.user?.id || decoded.id;

    const user = await User.findById(userId).select("-password");
    if (!user) {
      ws.send(JSON.stringify({ 
        type: 'deviceRegistration', 
        status: 'error', 
        message: 'User not found' 
      }));
      return;
    }

    const existingDevice = user.devices.find(
      (device) => device.macAddress === macAddress
    );

    if (existingDevice) {
      ws.send(JSON.stringify({ 
        type: 'deviceRegistration', 
        status: 'error', 
        message: 'Device already registered' 
      }));
      return;
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

    ws.send(JSON.stringify({ 
      type: 'deviceRegistration', 
      status: 'success', 
      message: 'Device registered successfully' 
    }));

  } catch (error) {
    ws.send(JSON.stringify({ 
      type: 'deviceRegistration', 
      status: 'error', 
      message: 'Failed to register device' 
    }));
  }
};