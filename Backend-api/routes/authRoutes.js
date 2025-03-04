// routes/authRoutes.js
import express from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import rateLimit from "express-rate-limit";
import mongoose from "mongoose";
import userDetail from "../db_schema/userSchema.js";
import { authenticateToken } from "../middleware/auth.js";

const router = express.Router();
const usr = mongoose.createConnection("mongodb://localhost:27017/classhub");
const User = usr.model("User", userDetail, "users");

// Rate limiter for login attempts
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5,
  message: "Too many login attempts. Please try again later.",
});


router.post("/register", async (req, res) => {
  console.log("Req received for registration");
  const { name, dp, roll_no, branch, mobile_no, sem, sub, sgpa, back_log, marksheet, password } = req.body;

  if (!name || !roll_no || !branch || !mobile_no || !sem || !password) {
    return res.status(400).json({ error: "All fields are required" });
  }


  try {
    const existingUser = await User.findOne({ roll_no });
    if (existingUser) {
      return res.status(400).json({ error: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({
      name,
      dp,
      roll_no,
      branch,
      mobile_no,
      sem,
      sub,
      sgpa,
      back_log,
      marksheet,
      password: hashedPassword,
    });

    await newUser.save();
    console.log("User Registered");

    res.status(201).json({ message: "User registered successfully" });
  } catch (err) {
    console.error("Error during registration:", err);
    res.status(500).json({ error: "Server error during registration" });
  }
});


// User login
router.post("/login", loginLimiter, async (req, res) => {
  const { roll_no, password } = req.body;
  if (!roll_no || !password) {
    return res.status(400).json({ error: "Roll number and password are required" });
  }

  try {
    const existingUser = await User.findOne({ roll_no });
    if (!existingUser) {
      return res.status(400).json({ error: "Invalid Roll number, user not found." });
    }

    const isMatch = await bcrypt.compare(password, existingUser.password);
    if (!isMatch) {
      return res.status(400).json({ error: "Invalid password." });
    }

    const token = jwt.sign(
      { id: existingUser._id, roll_no: existingUser.roll_no }, 
      process.env.JWT_SECRET, 
    );

    res.status(200).json({ message: "Login successful", token });
  } catch (error) {
    console.error("Error during login:", error);
    res.status(500).json({ error: "Server error during login" });
  }
});

// Get user data by roll number (protected route)
router.get("/:roll_no", authenticateToken, async (req, res) => {
  try {
    const userData = await User.findOne({ roll_no: req.params.roll_no });
    if (!userData) {
      return res.status(404).json({ error: "User not found" });
    }
    res.status(200).json(userData);
  } catch (err) {
    console.error("Error fetching user data:", err);
    res.status(500).json({ error: "Failed to fetch user data" });
  }
});

export default router;
