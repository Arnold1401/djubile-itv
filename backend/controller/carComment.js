const { CarComment, User } = require("../models");

class Controller {
  static async addComment(request) {
    const { carId, text, userId } = request;
    try {
      const createdCarComment = await CarComment.create({
        carId,
        userId,
        text,
      });

      if (!createdCarComment) {
        throw { name: "err_addcar", message: createdCarComment };
      }

      console.log(createdCarComment);
    } catch (error) {
      //next(error);
      console.log(error);
    }
  }

  static async getComment(request, response, next) {
    const { carId } = request.params;

    try {
      const comments = await CarComment.findAll({
        where: { carId },
      });

      response.status(200).json(comments);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = Controller;
