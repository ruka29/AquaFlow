import cron from "node-cron";
import User from "../models/User.js";

export const scheduleMonthlyUsageReset = () => {
  cron.schedule("0 0 1 * *", async () => {
    console.log("Running monthly usage reset...");

    try {
      const users = await User.find();

      for (const user of users) {
        for (const device of user.devices) {
          device.lastMonthUsage = device.thisMonthUsage;
          device.thisMonthUsage = 0;
        }

        await user.save();
      }

      console.log("Monthly usage reset completed successfully.");
    } catch (error) {
      console.error("Error during monthly usage reset:", error.message);
    }
  });
};

const OFFLINE_THRESHOLD = 5  * 1000;

export const checkDeviceStatus = () => {
  cron.schedule("*/1 * * * *", async () => {
    try {
      const users = await User.find();
  
      const now = new Date();
  
      users.forEach(async (user) => {
        user.devices.forEach((device) => {
          if (device.lastPing && now - new Date(device.lastPing) > OFFLINE_THRESHOLD) {
            device.status = "offline";
          }
        });
  
        await user.save();
      });
  
      console.log("Device status check complete");
    } catch (error) {
      console.error("Error checking device statuses:", error);
    }
  });
}
