import mongoose from "mongoose";

// Assignment Schema
const assDetail = mongoose.Schema({
    no: {
        type: Number,
        required: true,
    },
    ques: {
        type: String, // Use String instead of 'string'
        required: true,
    },
    due_date: {
        type: Date,
        required: true,
    },
    date_given: {
        type: Date,
        required: true,
    }
});

// Download Data Schema
const downData = mongoose.Schema({
    type: {
        type: String, // Use String instead of "string"
        enum: ["pdf", "docx", "ppt"], // Added "docx" for document files
        required: true,
    },
    detail: {
        type: String,
        required: true,
    },
    link: {
        type: String,
        required: true,
    }
});

// Notes Data Schema
const notesData = mongoose.Schema({
    unit: {
        type: String, // Use String instead of "string"
        required: true,
    },
    title: {
        type: String,
        required: true,
    },
    content: {
        type: String,
        required: true,
    }
});

// Site Data Schema
const siteData = mongoose.Schema({
    title: {
        type: String, // Use String instead of "string"
        required: true,
    },
    detail: {
        type: String,
        required: true,
    },
    link: {
        type: String,
        required: true,
    }
});

// Syllabus Data Schema
const syllabusDetail = mongoose.Schema({
    unit_no: {
        type: Number,
        required: true,
        min: 1, // Use min for validation instead of 'minimum'
    },
    content: {
        type: String, // Use String instead of 'String'
        required: true,
    }
});

const paperDetail = mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    link: {
        type: String, 
        required: true,
    }
});

// Export models for use in the application
export const Assignment = mongoose.model("assignment", assDetail,"assignment");
export const Download = mongoose.model("downloads", downData,"downloads");
export const Notes = mongoose.model("notes", notesData,"notes");
export const Site = mongoose.model("sites", siteData,"sites");
export const Syllabus = mongoose.model("syllabus", syllabusDetail,"syllabus");
export const Paper = mongoose.model("paper", paperDetail,"paper");

