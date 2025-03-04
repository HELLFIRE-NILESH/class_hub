import mongoose from "mongoose";

const noticeSchema = mongoose.Schema({
    date_time:{
        type:Date,
        required:1
    },
    content:{
        type:'string',
        required:1,
    },
    sent_by:{
        type: 'string',
        required:1,
    },
    branch:{
        type:'string',
        enum:["CSE","ETE","ME"],
        required:1,
    },
    sem:{
      type:Number,
        enum:[1,2,3,4,5,6],
        required :1
    }


})
export default noticeSchema;


