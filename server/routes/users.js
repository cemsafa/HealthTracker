const { User, validate, generateAuthToken } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const bcrypt = require("bcrypt");
const _ = require("lodash");
const express = require("express");
const router = express.Router();

router.get("/me", [auth], async (req, res) => {
  const user = await User.findById(req.user._id).select("-password");
  if (!user) return res.status(404).send("User not found.");
  res.send(user);
});

router.post("/", validator(validate), async (req, res) => {
  let user = await User.findOne({ email: req.body.email });
  if (user) return res.status(400).send("User already registered.");

  user = new User(_.pick(req.body, ["name", "email", "password"]));
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);
  await user.save();

  const token = generateAuthToken(user);
  res
    .setHeader("Authorization", "Bearer " + token)
    .send(_.pick(user, ["_id", "name", "email", "isTrial", "isPremium"]));
});

module.exports = router;
