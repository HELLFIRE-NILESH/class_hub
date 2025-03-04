
import mongoose, {Mongoose} from "mongoose";
const subDetail = mongoose.Schema({
    sub_code:{
        type:Number,
        required:1
    },
    sub_name:{
        type:'string',
        required:1,
    },
    teacher_name:{
        type: 'string',
        required:1,
    },
    last_date:{
        type: Date,
        required:1,
    }


})
export default subDetail;



