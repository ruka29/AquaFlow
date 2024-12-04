import express from "express";
import {
  registerDevice,
  updateTankData,
  updateThresholds,
  updateWaterLevel,
  controlValve,
  getDeviceData,
  heartbeat,
  getValveState
} from "../controllers/deviceController.js";
const router = express.Router();

router.post("/register", registerDevice);
router.patch("/update-tank-data", updateTankData);
router.patch("/update-thresholds", updateThresholds);
router.patch("/update-water-level", updateWaterLevel);
router.post("/control-valve", controlValve);
router.post("/get-device", getDeviceData);
router.post("/get-valve-state", getValveState);
router.post("/heartbeat", heartbeat);

export default router;
