const mongoose = require("mongoose");
const Joi = require("joi");

const bloodPressureSchema = new mongoose.Schema({
  systolic: {
    type: Number,
    required: true,
  },
  diastolic: {
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

const BloodPressure = mongoose.model("BloodPressure", bloodPressureSchema);

function validateBloodPressure(bloodPressure) {
  const schema = Joi.object({
    systolic: Joi.number().required(),
    diastolic: Joi.number().required(),
    userId: Joi.objectId().required(),
  });
  return schema.validate(bloodPressure);
}

exports.BloodPressure = BloodPressure;
exports.bloodPressureSchema = bloodPressureSchema;
exports.validate = validateBloodPressure;
