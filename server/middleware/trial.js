module.exports = function (req, res, next) {
  if (!req.user.isTrial)
    return res.status(403).send({ message: "Your trial period is over." });
  next();
};
