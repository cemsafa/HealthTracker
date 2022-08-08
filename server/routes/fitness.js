const { Fitness, validate } = require("../models/fitness");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.post("/", [auth, validator(validate)], async (req, res) => {
  const user = await User.findById(req.body.userId);
  if (!user) return res.status(400).send("Invalid user.");

  const fitness = new Fitness({
    age: req.body.age,
    weigth: req.body.weigth,
    heigth: req.body.heigth,
    stamina: req.body.stamina,
    strength: req.body.strength,
    userId: user._id,
  });

  try {
    new Fawn.Task()
      .save("fitness", fitness)
      .update("users", { _id: user._id }, { $push: { fitness: fitness } })
      .run();

    res.send(fitness);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
