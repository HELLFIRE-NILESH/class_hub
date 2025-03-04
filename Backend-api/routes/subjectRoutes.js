import express from "express";
import mongoose from "mongoose";
import subDetail from "../db_schema/subjectSchema.js";
import { fetchSubjectData } from "../utils/fetchsubData.js";
import { authenticateToken } from "../middleware/auth.js";

const router = express.Router();
const sub_model = mongoose.createConnection("mongodb://localhost:27017/All_Sub").model("Subjects", subDetail, "Subjects");

// Middleware for basic request logging
router.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
  next();
});

// Fetch multiple subjects by subject codes
router.get("/sub/:sub_codes", authenticateToken, async (req, res) => {
  console.log("Request received for fetching details of subjects.");
  try {
    const subCodes = req.params.sub_codes.split(",").map((code) => parseInt(code, 10));
    const subjects = await sub_model.find({ sub_code: { $in: subCodes } });
    console.log("Response sent with subjects data.");
    res.send(subjects);
  } catch (error) {
    console.error("Error fetching subjects:", error);
    res.status(500).json({ error: "Failed to fetch subjects" });
  }
});

// Fetch data for multiple subjects
router.get("/:sub_codes/data", authenticateToken, async (req, res) => {
  console.log("Request received for fetching multiple subjects' data.");
  try {
    const subjectCodes = req.params.sub_codes.split(",");
    const allData = {};

    await Promise.all(
      subjectCodes.map(async (subjectCode) => {
        allData[subjectCode] = await fetchSubjectData(subjectCode);
      })
    );

    console.log("Response sent with multiple subjects' data.");
    console.log(allData);
    res.json(allData);
  } catch (error) {
    console.error("Error fetching data for multiple subjects:", error);
    res.status(500).json({ error: "Failed to fetch data" });
  }
});

router.get("/:subjectCode/all", authenticateToken, async (req, res) => {
  console.log(`Request received for fetching all data of subject ${req.params.subjectCode}.`);
  try {
    const data = await fetchSubjectData(req.params.subjectCode);
    console.log("Response sent with subject details.");
    res.json(data);
  } catch (error) {
    console.error(`Error fetching details for ${req.params.subjectCode}:`, error);
    res.status(500).json({ error: "Failed to fetch subject details" });
  }
});

// Fetch specific data type for a single subject
router.get("/:subjectCode/:dataType", authenticateToken, async (req, res) => {
  console.log(`Request received for fetching ${req.params.dataType} of subject ${req.params.subjectCode}.`);
  try {
    const { subjectCode, dataType } = req.params;
    if (!["assignment", "syllabus", "notes", "sites", "downloads","paper"].includes(dataType)) {
      console.log("Invalid data type requested.");
      return res.status(400).json({ error: "Invalid data type" });
    }

    const data = await fetchSubjectData(subjectCode);
    console.log("Response sent with requested data type.");
    res.json({ [dataType]: data[dataType] });
  } catch (error) {
    console.error(`Error fetching ${dataType} for ${subjectCode}:`, error);
    res.status(500).json({ error: "Failed to fetch data" });
  }
});

export default router;
