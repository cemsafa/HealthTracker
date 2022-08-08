const mongoose = require("mongoose");
const Joi = require("joi");

const bloodSugarSchema = new mongoose.Schema({
  glucose: {
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

const BloodSugar = mongoose.model("BloodSugar", bloodSugarSchema);

function validateBloodSugar(bloodSugar) {
  const schema = Joi.object({
    glucose: Joi.number().required(),
    userId: Joi.objectId().required(),
  });
  return schema.validate(bloodSugar);
}

exports.BloodSugar = BloodSugar;
exports.bloodSugarSchema = bloodSugarSchema;
exports.validate = validateBloodSugar;
