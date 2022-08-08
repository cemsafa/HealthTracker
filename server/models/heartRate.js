const mongoose = require("mongoose");
const Joi = require("joi");

const heartRateSchema = new mongoose.Schema({
  bpm: {
    type: Number,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now(),
    required: true,
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "user",
  },
});

const HeartRate = mongoose.model("HeartRate", heartRateSchema);

function validateHeartRate(heartRate) {
  const schema = Joi.object({
    bpm: Joi.number().required(),
    userId: Joi.objectId().required(),
  });
  return schema.validate(heartRate);
}

exports.HeartRate = HeartRate;
exports.heartRateSchema = heartRateSchema;
exports.validate = validateHeartRate;
