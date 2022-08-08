const { BloodPressure, validate } = require("../models/bloodPressure");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const validateObjectId = require("../middleware/validateObjectId");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.get("/", auth, async (req, res) => {
  const bloodpressures = await BloodPressure.find().sort("createdAt");
  res.send(bloodpressures);
});

router.get("/:id", [auth, validateObjectId], async (req, res) => {
  const bloodpressure = await BloodPressure.findById(req.params.id);
  if (!bloodpressure)
    return res
      .status(404)
      .send("The blood pressure with given id was not found.");
  res.send(bloodpressure);
});

router.post("/", [auth, validator(validate)], async (req, res) => {
  const user = await User.findById(req.body.userId);
  if (!user) return res.status(400).send("Invalid user.");

  const bloodPressure = new BloodPressure({
    systolic: req.body.systolic,
    diastolic: req.body.diastolic,
    userId: user._id,
  });

  try {
    new Fawn.Task()
      .save("bloodpressures", bloodPressure)
      .update(
        "users",
        { _id: user._id },
        { $push: { bloodpressures: bloodPressure } }
      )
      .run();

    res.send(bloodPressure);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
