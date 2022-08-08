const mongoose = require("mongoose");
const Joi = require("joi");

const familyMemberSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "self",
  },
  memberId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "user",
  },
});

const FamilyMember = mongoose.model("FamilyMember", familyMemberSchema);

function validateFamilyMember(familyMember) {
  const schema = Joi.object({
    userId: Joi.objectId().required(),
    memberId: Joi.objectId().required(),
  });
  return schema.validate(familyMember);
}

exports.FamilyMember = FamilyMember;
exports.familyMemberSchema = familyMemberSchema;
exports.validate = validateFamilyMember;
