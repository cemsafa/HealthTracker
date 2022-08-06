const { BloodPressure, validate } = require("../models/bloodPressure");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.post("/", [auth, validator(validate)], async (req, res) => {
  const user = await User.findById(req.body.userId);
  if (!user) return res.status(400).send("Invalid user.");

  const bloodPressure = new BloodPressure({
    systolic: req.body.systolic,
    diastolic: req.body.diastolic,
  });

  try {
    new Fawn.Task()
      .save("bloodPressure", bloodPressure)
      .update(
        "users",
        { _id: user._id },
        { $push: { bloodPressure: bloodPressure } }
      )
      .run();

    res.send(bloodPressure);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
