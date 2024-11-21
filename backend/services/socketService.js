import { Server } from "socket.io";

let io;

export const initializeSocket = (server) => {
  io = new Server(server, {
    cors: {
      origin: "*", // Replace with your mobile app's domain in production
    },
  });

  io.on("connection", (socket) => {
    console.log("A user connected");

    socket.on("join", (email) => {
      socket.join(email);
      console.log(`User with email ${email} joined the room`);
    });

    socket.on("disconnect", () => {
      console.log("A user disconnected");
    });
  });
};

export { io };
