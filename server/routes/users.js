const { User, validate, generateAuthToken } = require("../models/user");
const auth = require("../middleware/auth");
const admin = require("../middleware/admin");
const validator = require("../middleware/validate");
const validateObjectId = require("../middleware/validateObjectId");
const bcrypt = require("bcrypt");
const _ = require("lodash");
const express = require("express");
const router = express.Router();

router.get("/", [auth], async (req, res) => {
  const users = await User.find()
    .sort("name")
    .select("-password")
    .select("-isAdmin");
  res.send(users);
});

router.get("/:id", [auth, validateObjectId], async (req, res) => {
  const user = await User.findById(req.params.id)
    .select("-password")
    .select("-isAdmin");
  if (!user)
    return res
      .status(404)
      .send({ message: "The user with given id was not found." });
  res.send(user);
});

router.get("/self/me", [auth], async (req, res) => {
  const user = await User.findById(req.user._id)
    .select("-password")
    .select("-isAdmin");
  if (!user) return res.status(404).send({ message: "User not found." });
  res.send(user);
});

router.post("/search", [auth], async (req, res) => {
  let user = await User.findOne({ email: req.body.email });
  if (!user) return res.status(404).send({ message: "User not found." });

  res.send(_.pick(user, ["_id"]));
});

router.post("/", validator(validate), async (req, res) => {
  let user = await User.findOne({ email: req.body.email });
  if (user)
    return res.status(400).send({ message: "User already registered." });

  user = new User(_.pick(req.body, ["name", "email", "password"]));
  const salt = await bcrypt.genSalt(10);
  user.password = await bcrypt.hash(user.password, salt);
  await user.save();

  const token = generateAuthToken(user);
  res
    .setHeader("Authorization", "Bearer " + token)
    .send({ user: _.pick(user, ["_id", "name", "email"]), token: token });
});

router.delete("/:id", [auth, admin], async (req, res) => {
  let user = await User.findByIdAndDelete(req.params.id);
  if (!user)
    return res
      .status(404)
      .send({ message: "The user with given id was not found." });

  res.send(user);
});

module.exports = router;
