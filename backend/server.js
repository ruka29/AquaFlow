import express from "express";
import { Server } from "socket.io";
import http from "http";

// Routes
import authRoutes from "./routes/authRoutes.js";
import deviceRoutes from "./routes/deviceRoutes.js";
// import metricsRoutes from "./routes/metricsRoutes.js";

// Config
import connectDB from "./config/db.js";

// Initialize app
const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

// Middleware
app.use(express.json());

// Connect to MongoDB
connectDB();

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/device", deviceRoutes);
// app.use("/api/metrics", metricsRoutes);

// WebSocket for real-time updates
io.on("connection", (socket) => {
  console.log("Client connected:", socket.id);

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

app.set("socketio", io);

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
