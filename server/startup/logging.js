const winston = require("winston");
require("winston-mongodb");
require("express-async-errors");

module.exports = function () {
  winston.add(
    new winston.transports.File({
      filename: "logfile.log",
      handleExceptions: true,
      handleRejections: true,
    })
  );

  winston.add(
    new winston.transports.MongoDB({
      db: "mongodb://127.0.0.1/health-tracker",
      level: "error",
      options: {
        useUnifiedTopology: true,
      },
    })
  );

  winston.add(
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.prettyPrint(),
        winston.format.simple(),
        winston.format.colorize()
      ),
    })
  );
};
