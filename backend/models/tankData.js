import mongoose from "mongoose";

const tankDataSchema = new mongoose.Schema({
  waterLevel: { type: Number, required: true }, // Water level in percentage
  valveStatus: { type: Boolean, required: true }, // True = Open, False = Closed
  timestamp: { type: Date, default: Date.now }, // When the data was recorded
});

export default mongoose.model("TankData", tankDataSchema);
