import express from "express";
import { getTankData, postTankData } from "../controllers/tankController.js";

const router = express.Router();

router.get("/data", getTankData); // Fetch latest water tank data
router.post("/data", postTankData); // Receive data from ESP32

export default router;
