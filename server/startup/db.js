const winston = require("winston");
const mongoose = require("mongoose");
const Fawn = require("fawn");

module.exports = function () {
  mongoose
    .connect("mongodb://127.0.0.1/health-tracker")
    .then(Fawn.init("mongodb://127.0.0.1/health-tracker"))
    .then(() => winston.info("Connected to MongoDB..."));
};
