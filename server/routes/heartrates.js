const { HeartRate, validate } = require("../models/heartRate");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const admin = require("../middleware/admin");
const trial = require("../middleware/trial");
const premium = require("../middleware/premium");
const validator = require("../middleware/validate");
const validateObjectId = require("../middleware/validateObjectId");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.get("/", [auth, trial, premium], async (req, res) => {
  const heartrates = await HeartRate.find().sort("createdAt");
  res.send(heartrates);
});

router.get(
  "/:id",
  [auth, trial, premium, validateObjectId],
  async (req, res) => {
    const heartrate = await HeartRate.findById(req.params.id);
    if (!heartrate)
      return res
        .status(404)
        .send({ message: "The heart rate with given id was not found." });
    res.send(heartrate);
  }
);

router.get("/contains/self", [auth, trial, premium], async (req, res) => {
  const heartrates = await HeartRate.find({
    userId: req.user._id,
  }).sort("createdAt");
  if (heartrates.length === 0)
    return res
      .status(404)
      .send({ message: "This user has no heart rate values." });
  res.send(heartrates);
});

router.post(
  "/",
  [auth, trial, premium, validator(validate)],
  async (req, res) => {
    const user = await User.findById(req.body.userId);
    if (!user) return res.status(400).send({ message: "Invalid user." });

    const heartrate = new HeartRate({
      bpm: req.body.bpm,
      userId: user._id,
    });

    try {
      new Fawn.Task()
        .save("heartrates", heartrate)
        .update(
          "users",
          { _id: user._id },
          { $push: { heartrates: heartrate } }
        )
        .run();

      res.send(heartrate);
    } catch (ex) {
      res.status(500).send({ message: "Something failed." });
    }
  }
);

router.delete("/:id", [auth, admin, validateObjectId], async (req, res) => {
  const heartrate = await HeartRate.findByIdAndRemove(req.params.id);
  if (!heartrate)
    return res
      .status(404)
      .send({ message: "The heart rate with given id was not found." });

  res.send(heartrate);
});

module.exports = router;
