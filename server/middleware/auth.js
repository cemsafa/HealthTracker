const jwt = require("jsonwebtoken");

module.exports = function (req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || authHeader.split(" ")[0] !== "Bearer")
    return res.status(401).send("Access denied. No authorization provided.");

  const token = authHeader.split(" ")[1];
  if (!token) return res.status(401).send("Access denied. No token provided.");

  try {
    req.user = jwt.verify(token, "jwtPrivateKey");
    next();
  } catch (ex) {
    res.status(400).send("Invalid token.");
  }
};
