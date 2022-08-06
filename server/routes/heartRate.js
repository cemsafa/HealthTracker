const { HeartRate, validate } = require("../models/heartRate");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.post("/", [auth, validator(validate)], async (req, res) => {
  const user = await User.findById(req.body.userId);
  if (!user) return res.status(400).send("Invalid user.");

  const heartRate = new HeartRate({
    bpm: req.body.bpm,
  });

  try {
    new Fawn.Task()
      .save("heartRate", heartRate)
      .update("users", { _id: user._id }, { $push: { heartRate: heartRate } })
      .run();

    res.send(heartRate);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
