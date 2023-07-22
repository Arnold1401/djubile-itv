const { CarComment, User } = require("../models");

class Controller {
  static async addComment(request, response, next) {
    const { carId, userId, text } = request.body;
    try {
      const createdCarComment = await CarComment.create({
        carId,
        userId,
        text,
      });

      if (!createdCarComment) {
        throw { name: "err_addcar", message: createdCarComment };
      }

      response.status(201).json({
        statusCode: 201,
        data: {
          carId,
          userId,
          text,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  static async getComment(request, response, next) {
    const { carId } = request.params;

    try {
      const comments = await CarComment.findAll({
        where: { carId },
        include: [{ model: User, attributes: ["id", "name", "phone"] }],
      });

      response.status(200).json({
        statusCode: 200,
        data: comments,
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = Controller;
