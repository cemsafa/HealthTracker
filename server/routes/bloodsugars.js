const { BloodSugar, validate } = require("../models/bloodSugar");
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
  const bloodsugars = await BloodSugar.find().sort("createdAt");
  res.send(bloodsugars);
});

router.get(
  "/:id",
  [auth, trial, premium, validateObjectId],
  async (req, res) => {
    const bloodsugar = await BloodSugar.findById(req.params.id);
    if (!bloodsugar)
      return res
        .status(404)
        .send("The blood sugar with given id was not found.");
    res.send(bloodsugar);
  }
);

router.post(
  "/",
  [auth, trial, premium, validator(validate)],
  async (req, res) => {
    const user = await User.findById(req.body.userId);
    if (!user) return res.status(400).send("Invalid user.");

    const bloodsugar = new BloodSugar({
      glucose: req.body.glucose,
      userId: user._id,
    });

    try {
      new Fawn.Task()
        .save("bloodsugars", bloodsugar)
        .update(
          "users",
          { _id: user._id },
          { $push: { bloodsugars: bloodsugar } }
        )
        .run();

      res.send(bloodsugar);
    } catch (ex) {
      res.status(500).send("Something failed.");
    }
  }
);

router.delete("/:id", [auth, admin, validateObjectId], async (req, res) => {
  const bloodsugar = await BloodSugar.findByIdAndRemove(req.params.id);
  if (!bloodsugar)
    return res.status(404).send("The blood sugar with given id was not found.");

  res.send(bloodsugar);
});

module.exports = router;
