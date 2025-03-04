import mongoose from "mongoose";

const userDetail = mongoose.Schema({
    name: {
        type: 'string',
        required: true,
    },
    dp: {
        type:"string",
        required: true,
    },
    roll_no: {
        type: 'string',
        required: true,
    },
    branch: {
        type: 'string',
        enum: ["CSE", "ET", "ME"],
        required: true,
    },
    mobile_no: {
        type: 'string',
        required: true,
    },
    sem: {
        type: Number,
        required: true,
    },
    sub: {
        type: 'array',
        items: {
            type: Number
        }
    },
    sgpa: {
        type: 'array',
        items: {
            type: Number
        }
    },
    back_log: {
        type: 'array',
        items: {
            type: Number
        }
    },
    password: {
        type: 'string',
        required: true, 
    },
    marksheet: {
        type: 'array',
        items: {
            type: 'string'
        }
    },
});

export default userDetail;
