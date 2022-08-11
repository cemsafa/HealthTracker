const { Fitness, validate } = require("../models/fitness");
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
  const fitnesses = await Fitness.find().sort("createdAt");
  res.send(fitnesses);
});

router.get(
  "/:id",
  [auth, trial, premium, validateObjectId],
  async (req, res) => {
    const fitness = await Fitness.findById(req.params.id);
    if (!fitness)
      return res
        .status(404)
        .send({ message: "The fitness with given id was not found." });
    res.send(fitness);
  }
);

router.get("/contains/self", [auth, trial, premium], async (req, res) => {
  const fitnesses = await Fitness.find({
    userId: req.user._id,
  }).sort("createdAt");
  if (fitnesses.length === 0)
    return res
      .status(404)
      .send({ message: "This user has no fitness values." });
  res.send(fitnesses);
});

router.post(
  "/",
  [auth, trial, premium, validator(validate)],
  async (req, res) => {
    const user = await User.findById(req.body.userId);
    if (!user) return res.status(400).send({ message: "Invalid user." });

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
        .save("fitnesses", fitness)
        .update("users", { _id: user._id }, { $push: { fitnesses: fitness } })
        .run();

      res.send(fitness);
    } catch (ex) {
      res.status(500).send({ message: "Something failed." });
    }
  }
);

router.delete("/:id", [auth, admin, validateObjectId], async (req, res) => {
  const fitness = await Fitness.findByIdAndRemove(req.params.id);
  if (!fitness)
    return res
      .status(404)
      .send({ message: "The fitness with given id was not found." });

  res.send(fitness);
});

module.exports = router;
