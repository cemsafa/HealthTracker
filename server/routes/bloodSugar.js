const { BloodSugar, validate } = require("../models/bloodSugar");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.post("/", [auth, validator(validate)], async (req, res) => {
  const user = await User.findById(req.body.userId);
  if (!user) return res.status(400).send("Invalid user.");

  const bloodSugar = new BloodSugar({
    glucose: req.body.glucose,
    userId: user._id,
  });

  try {
    new Fawn.Task()
      .save("bloodSugar", bloodSugar)
      .update("users", { _id: user._id }, { $push: { bloodSugar: bloodSugar } })
      .run();

    res.send(bloodSugar);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
