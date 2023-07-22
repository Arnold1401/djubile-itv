"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Car extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsTo(models.User, { foreignKey: "userId" });
      this.hasOne(models.CarComment, { foreignKey: "carId" });
    }
  }
  Car.init(
    {
      userId: DataTypes.INTEGER,
      carName: DataTypes.STRING,
      promotionEndDate: DataTypes.DATE,
      description: DataTypes.STRING,
      price: DataTypes.INTEGER,
      Address: DataTypes.STRING,
      mileage: DataTypes.INTEGER,
      carPicture: DataTypes.STRING,
    },
    {
      sequelize,
      modelName: "Car",
    }
  );
  return Car;
};
