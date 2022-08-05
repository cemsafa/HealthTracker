const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const Joi = require("joi");
const passwordComplexity = require("joi-password-complexity");

const User = mongoose.model(
  "User",
  new mongoose.Schema({
    name: {
      type: String,
      required: true,
      minlength: 5,
      maxlength: 50,
    },
    email: {
      type: String,
      required: true,
      minlength: 5,
      maxlength: 255,
      unique: true,
    },
    password: {
      type: String,
      required: true,
      minlength: 8,
      maxlength: 1024,
    },
    isAdmin: {
      type: Boolean,
      default: false,
    },
  })
);

function validateUser(user) {
  const schema = Joi.object({
    name: Joi.string().min(5).max(50).required(),
    email: Joi.string().email().min(5).max(255).required(),
    password: Joi.string().min(8).max(255).required(),
  });
  return schema.validate(user) && passwordComplexity().validate(user.password);
}

function generateAuthToken(user) {
  return jwt.sign({ _id: user._id, email: user.email }, "jwtPrivateKey");
}

exports.User = User;
exports.validate = validateUser;
exports.generateAuthToken = generateAuthToken;
