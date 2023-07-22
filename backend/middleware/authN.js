const { readToken } = require("../helpers");
const { User } = require("../models");
const authN = async (req, res, next) => {
  try {
    //headers harus huruf kecil
    const { access_token } = req.headers;
    console.log(req.headers);

    if (!access_token) {
      throw { name: "INVALID_TOKEN" };
    }

    const payload = readToken(access_token);

    const id = +payload.id;
    const selectedUser = await User.findByPk(id);
    if (!selectedUser) {
      throw { name: "INVALID_TOKEN" };
    }

    // AUTHENTICATION SIAPA DIA SEKARANG
    req.currentId = id;

    next();
  } catch (error) {
    next(error);
  }
};

module.exports = { authN };
