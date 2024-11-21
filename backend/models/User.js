import mongoose from "mongoose";

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
  addedAt: { type: Date, default: Date.now }, // Timestamp for when the device was registered
});

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String },
  googleId: { type: String, unique: true },
  devices: [deviceSchema],
});

export default mongoose.model("User", userSchema);
