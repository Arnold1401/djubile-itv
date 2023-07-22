"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("Cars", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },

      userId: {
        type: Sequelize.INTEGER,
        //setiap ada koneksi tambahkan references Cars -> User
        references: {
          model: "Users",
          key: "id",
        },
      },
      carName: {
        type: Sequelize.STRING,
      },
      promotionEndDate: {
        type: Sequelize.DATE,
      },
      description: {
        type: Sequelize.STRING,
      },
      price: {
        type: Sequelize.INTEGER,
      },
      Address: {
        type: Sequelize.STRING,
      },
      mileage: {
        type: Sequelize.INTEGER,
      },
      carPicture: {
        type: Sequelize.STRING,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable("Cars");
  },
};
