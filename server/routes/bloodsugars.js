const { BloodSugar, validate } = require("../models/bloodSugar");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const validateObjectId = require("../middleware/validateObjectId");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.get("/", auth, async (req, res) => {
  const bloodsugars = await BloodSugar.find().sort("createdAt");
  res.send(bloodsugars);
});

router.get("/:id", [auth, validateObjectId], async (req, res) => {
  const bloodsugar = await BloodSugar.findById(req.params.id);
  if (!bloodsugar)
    return res.status(404).send("The blood sugar with given id was not found.");
  res.send(bloodsugar);
});

router.post("/", [auth, validator(validate)], async (req, res) => {
  const user = await User.findById(req.body.userId);
  if (!user) return res.status(400).send("Invalid user.");

  const bloodSugar = new BloodSugar({
    glucose: req.body.glucose,
    userId: user._id,
  });

  try {
    new Fawn.Task()
      .save("bloodsugars", bloodSugar)
      .update(
        "users",
        { _id: user._id },
        { $push: { bloodsugars: bloodSugar } }
      )
      .run();

    res.send(bloodSugar);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
