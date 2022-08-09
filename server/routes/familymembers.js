const { FamilyMember, validate, lookup } = require("../models/familyMember");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
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
        .send("The family member with given id was not found.");
    res.send(familymember);
  }
);

router.post(
  "/",
  [auth, trial, premium, validator(validate)],
  async (req, res) => {
    const fMember = await lookup(req.body.userId, req.body.memberId);
    if (fMember) return res.status(404).send("You already have this member.");

    const member = await User.findById(req.body.memberId);
    if (!member) return res.status(400).send("Invalid member.");

    const user = await User.findById(req.body.userId);
    if (!user) return res.status(400).send("Invalid user.");

    const familyMember = new FamilyMember({
      memberId: member._id,
      userId: user._id,
    });

    const otherUserMember = new FamilyMember({
      userId: member._id,
      memberId: user._id,
    });

    try {
      new Fawn.Task()
        .save("familymembers", familyMember)
        .update(
          "users",
          { _id: user._id },
          { $push: { familymembers: familyMember } }
        )
        .update(
          "users",
          { _id: member._id },
          { $push: { familymembers: otherUserMember } }
        )
        .run();

      res.send(familyMember);
    } catch (ex) {
      res.status(500).send("Something failed.");
    }
  }
);

module.exports = router;
