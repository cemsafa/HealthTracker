const express = require("express");
const cors = require("cors");
const error = require("../middleware/error");
const users = require("../routes/users");
const auth = require("../routes/auth");
const bloodPressure = require("../routes/bloodPressure");
const bloodSugar = require("../routes/bloodSugar");
const heartRate = require("../routes/heartRate");
const fitness = require("../routes/fitness");
const familyMember = require("../routes/familyMember");

module.exports = function (app) {
  app.use(cors());
  app.use(express.json());
  app.use("/api/users", users);
  app.use("/api/auth", auth);
  app.use("/api/bloodPressure", bloodPressure);
  app.use("/api/bloodSugar", bloodSugar);
  app.use("/api/heartRate", heartRate);
  app.use("/api/fitness", fitness);
  app.use("/api/familyMember", familyMember);
  app.use(error);
};
