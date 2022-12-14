const mongoose = require("mongoose");
const jwt = require("jsonwebtoken");
const Joi = require("joi");
const passwordComplexity = require("joi-password-complexity");

const userSchema = new mongoose.Schema({
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
  isTrial: {
    type: Boolean,
    default: true,
  },
  isPremium: {
    type: Boolean,
    default: true,
  },
  premiumExpire: {
    type: Date,
    default: Date.now(),
    expires: 2629743,
  },
  bloodpressures: [
    {
      type: new mongoose.Schema({
        systolic: {
          type: Number,
          required: true,
        },
        diastolic: {
          type: Number,
          required: true,
        },
      }),
    },
  ],
  bloodsugars: [
    {
      type: new mongoose.Schema({
        glucose: {
          type: Number,
          required: true,
        },
      }),
    },
  ],
  heartrates: [
    {
      type: new mongoose.Schema({
        bpm: {
          type: Number,
          required: true,
        },
      }),
    },
  ],
  fitnesses: [
    {
      type: new mongoose.Schema({
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
      }),
    },
  ],
  familymembers: [
    {
      type: new mongoose.Schema({
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          required: true,
          ref: "self",
        },
        memberId: {
          type: mongoose.Schema.Types.ObjectId,
          required: true,
          ref: "user",
        },
      }),
    },
  ],
});

const User = mongoose.model("User", userSchema);

function validateUser(user) {
  const schema = Joi.object({
    name: Joi.string().min(5).max(50).required(),
    email: Joi.string().email().min(5).max(255).required(),
    password: Joi.string().min(8).max(255).required(),
  });
  return schema.validate(user) && passwordComplexity().validate(user.password);
}

function generateAuthToken(user) {
  return jwt.sign(
    {
      _id: user._id,
      email: user.email,
      isAdmin: user.isAdmin,
      isTrial: user.isTrial,
      isPremium: user.isPremium,
    },
    "jwtPrivateKey"
  );
}

exports.User = User;
exports.userSchema = userSchema;
exports.validate = validateUser;
exports.generateAuthToken = generateAuthToken;
