const express = require("express");
const router = express.Router();
const { errorHandler } = require("../handler");
const userController = require("../controller/user");
const carController = require("../controller/car");
const carCommentController = require("../controller/carComment");
const { authN } = require("../middleware/authN");

//USER CONTROLLER
router.post("/register", userController.register);
router.post("/login", userController.login); // Login
router.get("/cars/promotion", carController.getallcar);

//AUTHENTICATION
router.use(authN);
//CAR CONTROLLER
router.get("/cars/mycar", carController.getmycar); // Read
router.post("/cars/add", carController.addCar); // Create
router.get("/cars/:carId", carController.getCar); // Read
router.put("/cars/:carId", carController.updateCar); // Update
router.delete("/cars/:carId", carController.deleteCar); // Delete

//CarComment Controller
router.post("/carcomment/add", carCommentController.addComment);
router.get("/carcomment/:carId", carCommentController.getComment);

//ERROR handler
router.use(errorHandler);

module.exports = router;
