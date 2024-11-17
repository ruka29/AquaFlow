import TankData from "../models/tankData.js";
import { io } from "../server.js";

// Get the latest tank data
export const getTankData = async (req, res) => {
  try {
    const latestData = await TankData.findOne().sort({ timestamp: -1 });
    res.status(200).json(latestData);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch tank data" });
  }
};

// Save new tank data from ESP32
export const postTankData = async (req, res) => {
  const { waterLevel, valveStatus } = req.body;

  try {
    const newTankData = new TankData({ waterLevel, valveStatus });
    await newTankData.save();

    // Emit real-time updates to connected clients
    io.emit("tankUpdate", { waterLevel, valveStatus });

    res.status(201).json({ message: "Data saved successfully" });
  } catch (error) {
    res.status(500).json({ error: "Failed to save tank data" });
  }
};
