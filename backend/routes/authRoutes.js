import express from "express";
import { register, login, googleAuth, getUserData } from "../controllers/authController.js";
const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/googleAuth", googleAuth);
router.post("/user", getUserData);

export default router;
