const { User, generateAuthToken } = require("../models/user");
const validator = require("../middleware/validate");
const bcrypt = require("bcrypt");
const _ = require("lodash");
const Joi = require("joi");
const express = require("express");
const router = express.Router();

router.post("/", validator(validate), async (req, res) => {
  let user = await User.findOne({ email: req.body.email });
  if (!user) return res.status(400).send("Invalid email or password.");

  const validPassword = await bcrypt.compare(req.body.password, user.password);
  if (!validPassword) return res.status(400).send("Invalid email or password.");

  const token = generateAuthToken(user);

  res
    .setHeader("Authorization", "Bearer " + token)
    .send({ user: _.pick(user, ["_id", "name", "email"]), token: token });
});

function validate(req) {
  const schema = Joi.object({
    email: Joi.string().email().min(5).max(255).required(),
    password: Joi.string().min(8).max(255).required(),
  });
  return schema.validate(req);
}

module.exports = router;
