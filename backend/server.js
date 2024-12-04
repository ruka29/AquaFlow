import express from "express";
import http from "http";
import cors from "cors";

// Routes
import authRoutes from "./routes/authRoutes.js";
import deviceRoutes from "./routes/deviceRoutes.js"

import connectDB from "./config/db.js";
import { initializeWebSocketServer } from "./services/socketService.js";
import { scheduleMonthlyUsageReset, checkDeviceStatus, scheduleDailyUsageReset } from "./utils/cronJob.js";

// Initialize app
const app = express();
const server = http.createServer(app);

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectDB();

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/device", deviceRoutes);

// WebSocket for real-time updates
initializeWebSocketServer(server);
scheduleMonthlyUsageReset();
scheduleDailyUsageReset();
checkDeviceStatus();

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
