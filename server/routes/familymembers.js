const { FamilyMember, validate, lookup } = require("../models/familyMember");
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
  const familymembers = await FamilyMember.find().sort("createdAt");
  res.send(familymembers);
});

router.get(
  "/:id",
  [auth, trial, premium, validateObjectId],
  async (req, res) => {
    const familymember = await FamilyMember.findById(req.params.id);
    if (!familymember)
      return res
        .status(404)
        .send({ message: "The family member with given id was not found." });
    res.send(familymember);
  }
);

router.get("/contains/self", [auth, trial, premium], async (req, res) => {
  const familymembers = await FamilyMember.find({
    userId: req.user._id,
  }).sort("createdAt");
  if (familymembers.length === 0)
    return res
      .status(404)
      .send({ message: "This user has no family members." });
  res.send(familymembers);
});

router.post(
  "/",
  [auth, trial, premium, validator(validate)],
  async (req, res) => {
    const fMember = await lookup(req.body.userId, req.body.memberId);
    if (fMember)
      return res.status(404).send({ message: "You already have this member." });

    const member = await User.findById(req.body.memberId);
    if (!member) return res.status(400).send({ message: "Invalid member." });

    const user = await User.findById(req.body.userId);
    if (!user) return res.status(400).send({ message: "Invalid user." });

    const familymember = new FamilyMember({
      memberId: member._id,
      userId: user._id,
    });

    const otherUserMember = new FamilyMember({
      userId: member._id,
      memberId: user._id,
    });

    try {
      new Fawn.Task()
        .save("familymembers", familymember)
        .update(
          "users",
          { _id: user._id },
          { $push: { familymembers: familymember } }
        )
        .update(
          "users",
          { _id: member._id },
          { $push: { familymembers: otherUserMember } }
        )
        .run();

      res.send(familymember);
    } catch (ex) {
      res.status(500).send({ message: "Something failed." });
    }
  }
);

router.delete("/:id", [auth, admin, validateObjectId], async (req, res) => {
  const familymember = await FamilyMember.findByIdAndRemove(req.params.id);
  if (!familymember)
    return res
      .status(404)
      .send({ message: "The family member with given id was not found." });

  res.send(familymember);
});

module.exports = router;
