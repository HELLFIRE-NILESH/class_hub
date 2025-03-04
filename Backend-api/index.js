import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import authRoutes from "./routes/authRoutes.js";
import subjectRoutes from "./routes/subjectRoutes.js";
import { prometheusMiddleware, metricsRoute } from "./prometheus/prometheus.js";

dotenv.config();
const app = express();
app.listen(8000, "0.0.0.0", () => {
  console.log(`Server running on port ${8000}`);
});



app.use(express.json());
app.use(prometheusMiddleware);

// Database Connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("Database connection error:", err));

app.use("/api/auth", authRoutes);
app.use("/api/subjects", subjectRoutes);
app.get("/metrics", metricsRoute);


