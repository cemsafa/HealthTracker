const { BloodPressure, validate } = require("../models/bloodPressure");
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
  const bloodpressures = await BloodPressure.find().sort("createdAt");
  res.send(bloodpressures);
});

router.get(
  "/:id",
  [auth, trial, premium, validateObjectId],
  async (req, res) => {
    const bloodpressure = await BloodPressure.findById(req.params.id);
    if (!bloodpressure)
      return res
        .status(404)
        .send("The blood pressure with given id was not found.");
    res.send(bloodpressure);
  }
);

router.post(
  "/",
  [auth, trial, premium, validator(validate)],
  async (req, res) => {
    const user = await User.findById(req.body.userId);
    if (!user) return res.status(400).send("Invalid user.");

    const bloodpressure = new BloodPressure({
      systolic: req.body.systolic,
      diastolic: req.body.diastolic,
      userId: user._id,
    });

    try {
      new Fawn.Task()
        .save("bloodpressures", bloodpressure)
        .update(
          "users",
          { _id: user._id },
          { $push: { bloodpressures: bloodpressure } }
        )
        .run();

      res.send(bloodpressure);
    } catch (ex) {
      res.status(500).send("Something failed.");
    }
  }
);

router.delete("/:id", [auth, admin, validateObjectId], async (req, res) => {
  const bloodpressure = await BloodPressure.findByIdAndRemove(req.params.id);
  if (!bloodpressure)
    return res
      .status(404)
      .send("The blood pressure with given id was not found.");

  res.send(bloodpressure);
});

module.exports = router;
