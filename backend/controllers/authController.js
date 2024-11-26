import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import { OAuth2Client } from "google-auth-library";

import User from "../models/User.js";

dotenv.config();

export const register = async (req, res) => {
  const { name, email, password } = req.body;

  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user with an empty devices array
    const user = new User({
      name,
      email,
      password: hashedPassword,
      devices: [], // Initialize devices array
    });

    // Save the user to the database
    await user.save();

    res.status(201).json({ message: "User registered successfully", user });
  } catch (error) {
    // Handle duplicate email or server errors
    if (error.code === 11000) {
      return res.status(400).json({ message: "Email already exists" });
    }
    res.status(500).json({ error: "Failed to register user" });
  }
};

export const login = async (req, res) => {
  const { email, password } = req.body;

  try {
    let user = await User.findOne({ email }).exec();

    if (!user) {
      return res.status(400).json({ message: "Email does not exists!" });
    }

    const isMatch = bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    const payload = {
      user: {
        id: user.id,
      },
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      {
        expiresIn: "1h",
      },
      (err, token) => {
        if (err) throw err;
        res
          .status(200)
          .json({ token, message: "User logged in successfully." });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ message: "Server Error" });
  }
};

export const getUserData = async (req, res) => {
  try {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const userId = decoded.user?.id || decoded.id;

    if (!userId) {
      return res.status(401).json({ message: "Invalid token payload" });
    }

    const user = await User.findById(userId).select("-password");
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(user);
  } catch (error) {
    res.status(401).json({ message: "Token is invalid or expired" });
  }
};

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

export const googleAuth = async (req, res) => {
  const { token } = req.body;

  try {
    const ticket = await client.verifyIdToken({
      idToken: token,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const { sub: googleId, email, name } = payload;

    let user = await User.findOne({ email });

    if (user) {
      if (!user.googleId) {
        user.googleId = googleId;
        await user.save();
      }
    } else {
      user = new User({
        name,
        email,
        googleId,
      });
      await user.save();
    }

    res.status(200).json({
      message: "User authenticated successfully",
      user,
    });
  } catch (error) {
    console.error("Google Authentication Error:", error);
    res.status(401).json({ error: "Invalid Google token" });
  }
};
