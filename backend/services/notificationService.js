import { io } from "./socketService.js";

//send updated water level to mobile app
export const sendWaterLevelToMobileApp = async (
  email,
  macAddress,
  waterLevel
) => {
  try {
    io.to(email).emit("waterLevelUpdate", {
      macAddress,
      waterLevel,
    });

    console.log(`Water level sent to mobile app for user ${email}`);
  } catch (error) {
    console.error("Failed to send water level to mobile app:", error.message);
    throw new Error("Notification failed");
  }
};

//send updated valve state to mobile app
export const sendValveStateToMobileApp = async (email, macAddress, valveState) => {
  try {
    io.to(email).emit("valveUpdate", {
      macAddress,
      valveState,
    });

    console.log(`Sending valve state update to mobile app for ${email}`, data);

    return true;
  } catch (error) {
    console.error("Failed to send update to mobile app:", error.message);
    return false;
  }
};
