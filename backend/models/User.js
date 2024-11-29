import mongoose from "mongoose";

// Device schema
const deviceSchema = new mongoose.Schema({
  macAddress: { type: String, required: true, unique: true }, // Device's MAC address
  deviceName: { type: String, required: true }, // Device name
  valveState: { type: Boolean, default: false }, // Valve state: true (open), false (closed)
  waterLevel: { type: Number, required: true }, // Current water level in percentage
  lowThreshold: { type: Number, required: true }, // Low water level threshold
  highThreshold: { type: Number, required: true }, // High water level threshold
  tankCapacity: { type: Number, default: 0 }, // Tank capacity in liters (default to 0)
  tankHeight: { type: Number, default: 0 }, // Tank height in meters (default to 0)
  valveOpenTime: { type: Date, default: null }, // Last time the valve was opened
  valveCloseTime: { type: Date, default: null }, // Last time the valve was closed
  valveOpenLevel: { type: Number, default: 0 }, // Water level when the valve was opened
  valveCloseLevel: { type: Number, default: 0 }, // Water level when the valve was closed
  lastMonthUsage: { type: Number, default: 0 }, // Water usage for the last month
  thisMonthUsage: { type: Number, default: 0 }, // Water usage for the current month
  day1: { type: Number, default: 0 }, // Water usage for day 1
  day2: { type: Number, default: 0 }, // Water usage for day 2
  day3: { type: Number, default: 0 }, // Water usage for day 3
  day4: { type: Number, default: 0 }, // Water usage for day 4
  day5: { type: Number, default: 0 }, // Water usage for day 5
  day6: { type: Number, default: 0 }, // Water usage for day 6
  day7: { type: Number, default: 0 }, // Water usage for day 7
  addedAt: { type: Date, default: Date.now }, // Timestamp for when the device was registered
  status: {
    type: String,
    enum: ["online", "offline"],
    default: "offline",
  },
  lastPing: {
    type: Date,
    default: null,
  },
});

// Notification schema
const notificationSchema = new mongoose.Schema({
  deviceName: { type: String, required: true }, // Device name
  message: { type: String, required: true }, // Notification details
  time: { type: Date, required: true, default: Date.now }, // Notification timestamp
});

// User schema
const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String },
  googleId: { type: String, unique: true },
  devices: [deviceSchema], // Array of devices
  notifications: [notificationSchema], // Array of notifications
});

export default mongoose.model("User", userSchema);
