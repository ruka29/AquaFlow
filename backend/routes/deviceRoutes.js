import express from "express";
import { registerDevice, updateTankData, updateThresholds } from "../controllers/deviceController.js";
const router = express.Router();

router.post("/register", registerDevice);
router.patch("/update-tank-data", updateTankData);
router.patch("/update-thresholds", updateThresholds);

export default router;
