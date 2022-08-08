const { HeartRate, validate } = require("../models/heartRate");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const validateObjectId = require("../middleware/validateObjectId");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.get("/", auth, async (req, res) => {
  const heartrates = await HeartRate.find().sort("createdAt");
  res.send(heartrates);
});

router.get("/:id", [auth, validateObjectId], async (req, res) => {
  const heartrate = await HeartRate.findById(req.params.id);
  if (!heartrate)
    return res.status(404).send("The heart rate with given id was not found.");
  res.send(heartrate);
});

router.post("/", [auth, validator(validate)], async (req, res) => {
  const user = await User.findById(req.body.userId);
  if (!user) return res.status(400).send("Invalid user.");

  const heartRate = new HeartRate({
    bpm: req.body.bpm,
    userId: user._id,
  });

  try {
    new Fawn.Task()
      .save("heartrates", heartRate)
      .update("users", { _id: user._id }, { $push: { heartrates: heartRate } })
      .run();

    res.send(heartRate);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
