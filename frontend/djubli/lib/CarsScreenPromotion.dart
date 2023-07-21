import 'dart:async';
import 'dart:convert';
import 'globals.dart' as gl;
import 'package:djubli/class/car.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CarScreenPromotion extends StatefulWidget {
  CarScreenPromotion({Key? key}) : super(key: key);

  @override
  _CarScreenPromotionState createState() => _CarScreenPromotionState();
}

class _CarScreenPromotionState extends State<CarScreenPromotion> {
  late Future<List<Car>> _carFuture;

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _carFuture = fetchMyCar();
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (Timer timer) {
      setState(() {
        _carFuture = fetchMyCar();
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token').toString();
  }

  Future<List<Car>> fetchMyCar() async {
    var url = Uri.parse('${gl.ipnumber}/cars/mycar');

// Add headers to the request
    var headers = {
      'Content-Type': 'application/json', // Add your desired headers here
      'access_token':
          await getAccessToken(), // Example: Authorization header for authentication
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      final List<dynamic> parsedCarList = jsonDecode(response.body);
      return parsedCarList.map((carData) => Car.fromJson(carData)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load car');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Promotion"),
          backgroundColor: Colors.black,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle menu item selection
                if (value == 'menu1') {
                  Navigator.pushNamed(context, '/mycar');
                } else if (value == 'menu2') {
                  Navigator.pushReplacementNamed(context, "/my");
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'menu1',
                  child: Text('My Car'),
                ),
                const PopupMenuItem<String>(
                  value: 'menu2',
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: FutureBuilder<List<Car>>(
          future: _carFuture,
          builder: (context, snapshot) {
            // print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the data is still loading, show a progress indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there was an error while fetching the data, show an error message
              return const Center(
                child: Text('Error loading data'),
              );
            } else {
              List<Car> cars = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                ),
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  return GridItem(
                    car: cars[index],
                    onPressed: () {
                      // Handle button press
                      // print('Button pressed for ${items[index]}');
                    },
                  );
                },
              );
            }
          },
        ));
  }
}

class GridItem extends StatelessWidget {
  final Car car;
  final VoidCallback onPressed;

  const GridItem({super.key, required this.car, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            // Use BoxFit.contain to scale the image while maintaining aspect ratio
            fit: BoxFit.contain,
            child: Image.network(
              car.carPicture,
              width: 100,
              height: 100,
            ),
          ),
          Text(
            car.carName,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () => {
              Navigator.pushNamed(context, '/detailpromotion', arguments: car)
            },
            child: const Text('Detail'),
          ),
        ],
      ),
    );
  }
}
