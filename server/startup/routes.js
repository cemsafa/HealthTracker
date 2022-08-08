const express = require("express");
const cors = require("cors");
const error = require("../middleware/error");
const users = require("../routes/users");
const auth = require("../routes/auth");
const bloodpressures = require("../routes/bloodpressures");
const bloodsugars = require("../routes/bloodsugars");
const heartrates = require("../routes/heartrates");
const fitnesses = require("../routes/fitnesses");
const familymembers = require("../routes/familymembers");

module.exports = function (app) {
  app.use(cors());
  app.use(express.json());
  app.use("/api/users", users);
  app.use("/api/auth", auth);
  app.use("/api/bloodpressures", bloodpressures);
  app.use("/api/bloodsugars", bloodsugars);
  app.use("/api/heartrates", heartrates);
  app.use("/api/fitnesses", fitnesses);
  app.use("/api/familymembers", familymembers);
  app.use(error);
};
