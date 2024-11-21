import express from "express";
import {
  registerDevice,
  updateTankData,
  updateThresholds,
  updateWaterLevel,
  controlValve,
} from "../controllers/deviceController.js";
const router = express.Router();

router.post("/register", registerDevice);
router.patch("/update-tank-data", updateTankData);
router.patch("/update-thresholds", updateThresholds);
router.patch("/update-water-level", updateWaterLevel);
router.post("/control-valve", controlValve);

export default router;
