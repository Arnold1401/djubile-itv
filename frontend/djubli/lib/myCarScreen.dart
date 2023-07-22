import 'dart:convert';
import 'globals.dart' as gl;
import 'package:djubli/class/car.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({Key? key}) : super(key: key);

  @override
  _MyCarScreenState createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  late Future<List<Car>> _carFuture;

  @override
  void initState() {
    super.initState();
    _carFuture = fetchMyCar();
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

  void deleteCar(Car car) async {
    var url = Uri.parse('${gl.ipnumber}/cars/${car.id}');

// Add headers to the request
    var headers = {
      'Content-Type': 'application/json', // Add your desired headers here
      'access_token':
          await getAccessToken(), // Example: Authorization header for authentication
    };

    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      setState(() {
        _carFuture = fetchMyCar();
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load car');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, Car car) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want delete ${car.carName} ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete operation here
                // ...
                deleteCar(car);

                Navigator.of(context).pop(); // Close the dialog
                // Show a toast or snackbar confirming the deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item deleted')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cars"),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/addCar');
              },
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
                    showoption: () {
                      _showDeleteConfirmationDialog(context, cars[index]);
                    },
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
  final VoidCallback showoption;

  const GridItem(
      {super.key,
      required this.car,
      required this.onPressed,
      required this.showoption});

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
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () =>
                      {Navigator.pushNamed(context, '/detail', arguments: car)},
                  child: const Text('Detail'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => {showoption()},
                  child: const Icon(Icons.delete),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
