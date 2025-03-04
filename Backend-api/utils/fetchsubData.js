import mongoose from "mongoose";
import { Assignment, Syllabus, Notes, Site, Download, Paper } from "../db_schema/SchemaFile.js";

const dbConnections = {};

export const fetchSubjectData = async (subjectCode) => {
  if (!dbConnections[subjectCode]) {
    dbConnections[subjectCode] = mongoose.createConnection(`mongodb://localhost:27017/${subjectCode}`);
  }
  const subjectConnection = dbConnections[subjectCode];
  const models = { assignment: Assignment, syllabus: Syllabus, notes: Notes, sites: Site, downloads: Download , paper: Paper};

  const results = await Promise.all(
    Object.keys(models).map(async (col) => {
      const model = subjectConnection.model(col, models[col].schema, col);
      return { [col]: await model.find({}) };
    })
  );

  return Object.assign({}, ...results);
};
