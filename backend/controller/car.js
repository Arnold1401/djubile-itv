const { Car } = require("../models");

class Controller {
  static async addCar(request, response, next) {
    const {
      carName,
      promotionEndDate,
      description,
      price,
      Address,
      mileage,
      carPicture,
    } = request.body;
    const userId = request.currentId;

    try {
      const createdCar = await Car.create({
        userId,
        carName,
        promotionEndDate,
        //2023-07-19 17:37:10.629 +0700
        description,
        price,
        Address,
        mileage,
        carPicture,
      });

      if (!createdCar) {
        throw { name: "err_addcar", message: createdCar };
      }

      response.status(201).json({
        statusCode: 201,
        data: {
          userId,
          carName,
          promotionEndDate,
          description,
          price,
          Address,
          mileage,
          carPicture,
        },
      });
    } catch (error) {
      console.log("ini error addcar (1)", error.message);
      next(error);
    }
  }

  static async getCar(request, response, next) {
    const { carId } = request.params;

    try {
      const car = await Car.findByPk(carId);

      if (!car) {
        throw { name: "err_getcar", message: "Car not found" };
      }

      response.status(200).json(car);
    } catch (error) {
      console.log("ini error getcar (1)", error.message);
      next(error);
    }
  }

  static async getallcar(request, response, next) {
    try {
      const car = await Car.findAll();

      if (!car) {
        throw { name: "err_getcar", message: "Car not found" };
      }

      response.status(200).json(car);
    } catch (error) {
      next(error);
    }
  }

  static async getmycar(request, response, next) {
    const userId = request.currentId;
    try {
      const car = await Car.findAll({
        where: {
          userId,
        },
      });

      if (!car) {
        throw { name: "err_getcar", message: "Car not found" };
      }

      response.status(200).json(car);
    } catch (error) {
      next(error);
    }
  }

  static async updateCar(request, response, next) {
    const { carId } = request.params;
    const {
      carName,
      promotionEndDate,
      description,
      price,
      Address,
      mileage,
      carPicture,
    } = request.body;

    try {
      const [updatedRowCount, updatedCars] = await Car.update(
        {
          carName,
          promotionEndDate,
          description,
          price,
          Address,
          mileage,
          carPicture,
        },
        {
          where: { id: carId },
          returning: true,
        }
      );

      if (updatedRowCount === 0) {
        throw { name: "err_updatecar", message: "Car not found" };
      }

      response.status(200).json({
        statusCode: 200,
        data: updatedCars[0],
      });
    } catch (error) {
      console.log("ini error updatecar (1)", error.message);
      next(error);
    }
  }

  static async updatePromotion(request, response, next) {}

  static async deleteCar(request, response, next) {
    const { carId } = request.params;

    try {
      const deletedRowCount = await Car.destroy({
        where: { id: carId },
      });

      if (deletedRowCount === 0) {
        throw { name: "err_deletecar", message: "Car not found" };
      }

      response.status(200).json({
        statusCode: 200,
        message: "Car deleted successfully",
      });
    } catch (error) {
      console.log("ini error deletecar (1)", error.message);
      next(error);
    }
  }
}

module.exports = Controller;
