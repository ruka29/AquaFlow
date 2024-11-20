import express from "express";
import { register, login, googleAuth } from "../controllers/authController.js";
const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/googleAuth", googleAuth);

export default router;
