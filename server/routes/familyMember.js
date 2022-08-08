const { FamilyMember, validate } = require("../models/familyMember");
const { User } = require("../models/user");
const auth = require("../middleware/auth");
const validator = require("../middleware/validate");
const Fawn = require("fawn");
const express = require("express");
const router = express.Router();

router.post("/", [auth, validator(validate)], async (req, res) => {
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
      .save("familyMember", familyMember)
      .update(
        "users",
        { _id: user._id },
        { $push: { familyMember: familyMember } }
      )
      .update(
        "users",
        { _id: member._id },
        { $push: { familyMember: otherUserMember } }
      )
      .run();

    res.send(familyMember);
  } catch (ex) {
    res.status(500).send("Something failed.");
  }
});

module.exports = router;
