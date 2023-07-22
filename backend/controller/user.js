const { User } = require("../models");
const { comparepass, hashPass, signToken } = require("../helpers");

class Controller {
  static async register(request, response, next) {
    const { name, phone, password } = request.body;
    try {
      const hashedpass = hashPass(password);
      const createdUser = await User.create({
        name,
        phone,
        password: hashedpass,
      });

      if (!createdUser) {
        throw { name: "err_register", message: createdUser };
      }

      const access_token = signToken({
        id: createdUser.id,
        name: createdUser.name,
        phone: createdUser.phone,
      });

      response.status(201).json({
        statusCode: 201,
        data: {
          name: createdUser.name,
          phone: createdUser.phone,
          access_token,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  static async login(request, response, next) {
    const { phone, password } = request.body;

    try {
      const user = await User.findOne({ where: { phone } });

      if (!user) {
        throw { name: "err_login", message: "Invalid credentials" };
      }

      const isPasswordValid = await comparepass(
        password,
        user.dataValues.password
      );

      if (!isPasswordValid) {
        throw { name: "err_login", message: "Invalid credentials" };
      }

      const access_token = signToken({
        id: user.id,
        name: user.name,
        phone: user.phone,
      });

      response.status(200).json({
        statusCode: 200,
        data: {
          id: user.id,
          name: user.name,
          phone: user.phone,
          access_token,
        },
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = Controller;
