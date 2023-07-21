import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCarScreen extends StatefulWidget {
  AddCarScreen({Key? key}) : super(key: key);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _carNameController = TextEditingController();
  final _promotionEndDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _mileageController = TextEditingController();
  final _carPictureController = TextEditingController();
  String _imageUrl = '';
  @override
  void dispose() {
    _carNameController.dispose();
    _promotionEndDateController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _mileageController.dispose();
    _carPictureController.dispose();
    super.dispose();
  }

  void _updateImage() {
    setState(() {
      _imageUrl = _carPictureController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Car Screen"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imageUrl.isNotEmpty
                  ? Image.network(
                      _imageUrl,
                      height: 100,
                      width: 100,
                    )
                  : Container(),
              TextFormField(
                controller: _carNameController,
                decoration: InputDecoration(labelText: 'Car Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _promotionEndDateController,
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );

                  if (selectedDate != null) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        _promotionEndDateController.text =
                            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} ${selectedTime.format(context)}';
                      });
                    }
                  }
                },
                decoration: InputDecoration(labelText: 'Promotion End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the promotion end date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (value.length > 8) {
                    return 'Price is out of range 8 digit';
                  }
                  // You can add additional validation for numeric input
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _mileageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Mileage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the mileage';
                  }
                  // You can add additional validation for numeric input
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _carPictureController,
                decoration: InputDecoration(labelText: 'Car Pictur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car picture';
                  }
                  return null;
                },
                onChanged: (value) {
                  _updateImage();
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, process the data
                    final formData = {
                      'carName': _carNameController.text,
                      'promotionEndDate': _promotionEndDateController.text,
                      'description': _descriptionController.text,
                      'price': _priceController.text,
                      'address': _addressController.text,
                      'mileage': _mileageController.text,
                      'carPicture': _carPictureController.text,
                    };

                    // Process the form data as needed (e.g., save to database)
                    print(formData);
                    doAddCar();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token').toString();
  }

  Future<void> doAddCar() async {
    // The URL to which you want to send the POST request
    var url = Uri.parse('http://localhost:3001/cars/add');

    // The data you want to send in the request body
    var data = {
      'carName': _carNameController.text,
      'promotionEndDate': _promotionEndDateController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'Address': _addressController.text,
      'mileage': _mileageController.text,
      'carPicture': _carPictureController.text,
    };

    // Encode the data into JSON format
    var jsonData = json.encode(data);

    // Set up the headers for the request
    var headers = {
      'Content-Type': 'application/json',
      'access_token': await getAccessToken()
    };

    // Make the POST request
    var response = await http.post(
      url,
      headers: headers,
      body: jsonData,
    );

    // Check if the request was successful
    if (response.statusCode == 201) {
      // Decode the response JSON
      print(response.statusCode);
      Navigator.pop(this.context);
      //because the response from server it cover with {statusCode:200,data:{...}}
    } else {
      var responseData = json.decode(response.body);
      var errorMessage = responseData["data"];
      print(errorMessage);
    }
  }
}
