const express = require("express");
const cors = require("cors");
const error = require("../middleware/error");
const users = require("../routes/users");
const auth = require("../routes/auth");

module.exports = function (app) {
  app.use(cors());
  app.use(express.json());
  app.use("/api/users", users);
  app.use("/api/auth", auth);
  app.use(error);
};
