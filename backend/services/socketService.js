import { WebSocketServer } from "ws";
import { registerDevice } from "../controllers/webSocketDeviceController.js";

export const connectedClients = new Map();
export const connectedDevices = new Map();

export const initializeWebSocketServer = (server) => {
  const wss = new WebSocketServer({ server });

  console.log("WebSocket server initialized");

  wss.on("connection", (ws, req) => {
    try {
      const host = req.headers.host || "localhost";
      const urlParams = new URL(req.url, `http://${host}`).searchParams;

      if (urlParams.has("userId")) {
        const userId = urlParams.get("userId");
        connectedClients.set(userId, ws);
        console.log(`Client connected with userId: ${userId}`);
      } else if (urlParams.has("macAddress")) {
        const macAddress = urlParams.get("macAddress");
        connectedDevices.set(macAddress, ws);
        console.log(`Device connected with MAC address: ${macAddress}`);
      } else {
        console.log("Invalid WebSocket connection attempt");
        ws.close(1003, "Invalid connection"); // 1003: Unsupported Data
        return;
      }

      // Handle incoming messages
      ws.on("message", async (message) => {
        try {
          // Parse the incoming JSON message
          const parsedMessage = JSON.parse(message.toString());
          
          // Log the parsed message for debugging
          console.log("Parsed Message:", parsedMessage);
      
          // Example of handling different message types
          if (parsedMessage.type) {
            switch (parsedMessage.type) {
              case 'registerDevice':
                await registerDevice(ws, parsedMessage);
                break;
              case 'deviceStatus':
                console.log('Device Status:', parsedMessage.data);
                break;
              case 'sensorReading':
                console.log('Sensor Reading:', parsedMessage.data);
                break;
              default:
                console.log('Unhandled message type:', parsedMessage.type);
            }
          }
        } catch (error) {
          console.error('Error parsing JSON message:', error);
        }
      });

      // Handle connection closure
      ws.on("close", () => {
        console.log("WebSocket closed");
        connectedClients.forEach((socket, userId) => {
          if (socket === ws) connectedClients.delete(userId);
        });
        connectedDevices.forEach((socket, macAddress) => {
          if (socket === ws) connectedDevices.delete(macAddress);
        });
      });

      // Handle errors
      ws.on("error", (error) => {
        console.error("WebSocket error:", error.message);
      });
    } catch (error) {
      console.error("Error handling WebSocket connection:", error.message);
      ws.close(1011, "Internal server error"); // 1011: Server Error
    }
  });

  // Ping all connected clients/devices periodically
  setInterval(() => {
    wss.clients.forEach((ws) => {
      if (ws.readyState === ws.OPEN) {
        ws.ping();
      }
    });
  }, 30000); // Every 30 seconds
};

/**
 * Broadcast a message to a specific client
 * @param {string} userId - The user ID to send the message to
 * @param {object} data - The data to send
 */
export const broadcastToUser = (userId, data) => {
  const client = connectedClients.get(userId);
  if (client && client.readyState === 1) {
    client.send(JSON.stringify(data)); // Send data as JSON string
    console.log(`Sent message to userId: ${userId}`);
  } else {
    console.warn(`Client with userId ${userId} is not connected`);
  }
};
