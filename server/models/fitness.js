const mongoose = require("mongoose");
const Joi = require("joi");

const fitnessSchema = new mongoose.Schema({
  age: {
    type: Number,
    reqired: true,
  },
  weigth: {
    type: Number,
    required: true,
  },
  heigth: {
    type: Number,
    required: true,
  },
  stamina: {
    type: String,
    enum: ["high", "medium", "low"],
    default: "medium",
    required: true,
  },
  strength: {
    type: String,
    enum: ["high", "medium", "low"],
    default: "medium",
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now(),
    required: true,
  },
});

const Fitness = mongoose.model("Fitness", fitnessSchema);

function validateFitness(fitness) {
  const schema = Joi.object({
    age: Joi.number(),
    weigth: Joi.number(),
    heigth: Joi.number(),
    stamina: Joi.string().valid("high", "medium", "low"),
    strength: Joi.string().valid("high", "medium", "low"),
    userId: Joi.objectId().required(),
  });
  return schema.validate(fitness);
}

exports.Fitness = Fitness;
exports.fitnessSchema = fitnessSchema;
exports.validate = validateFitness;
