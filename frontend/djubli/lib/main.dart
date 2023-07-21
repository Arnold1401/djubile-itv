import 'package:djubli/CarsScreenPromotion.dart';
import 'package:djubli/DetailPromotionScreen.dart';
import 'package:djubli/addCarscreen.dart';
import 'package:djubli/class/car.dart';
import 'package:djubli/detailscreen.dart';
import 'package:djubli/editCarScreen.dart';
import 'package:djubli/loginscreen.dart';
import 'package:djubli/myCarScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginScreen(),
        '/promotion': (context) => CarScreenPromotion(),
        '/detailpromotion': (context) {
          Car car = ModalRoute.of(context)!.settings.arguments as Car;
          // Pass the Car data to the DetailScreen
          return DetailCarPromotion(car: car);
        },
        '/mycar': (context) => const MyCarScreen(),
        '/detail': (context) {
          Car car = ModalRoute.of(context)!.settings.arguments as Car;
          // Pass the Car data to the DetailScreen
          return DetailScreen(car: car);
        },
        '/addCar': (context) => AddCarScreen(),
        '/editCar': (context) {
          Car car = ModalRoute.of(context)!.settings.arguments as Car;

          // Pass the Car data to the DetailScreen
          return EditCarScreen(car: car);
        },
      },
    );
  }
}
