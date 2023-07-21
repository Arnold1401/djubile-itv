import 'package:djubli/class/car.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as gl;
import 'package:shared_preferences/shared_preferences.dart';

class EditCarScreen extends StatefulWidget {
  final Car car;
  EditCarScreen({required this.car, Key? key}) : super(key: key);

  @override
  _EditCarScreenState createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
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
  void initState() {
    super.initState();
    _carNameController.text = widget.car.carName;
    _promotionEndDateController.text = widget.car.promotionEndDate;
    _descriptionController.text = widget.car.description;
    _priceController.text = widget.car.price.toString();
    _addressController.text = widget.car.Address;
    _mileageController.text = widget.car.mileage.toString();
    _carPictureController.text = widget.car.carPicture;
  }

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
        title: Text("Edit Car Screen"),
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
                decoration: InputDecoration(labelText: 'Car Picture'),
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
                    doEdit();
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

  Future<void> doEdit() async {
    // The URL to which you want to send the POST request
    var url = Uri.parse('${gl.ipnumber}/cars/${widget.car.id}');

    // The data you want to send in the request body
    var data = {
      'id': widget.car.id,
      'carName': _carNameController.text,
      'promotionEndDate': _promotionEndDateController.text,
      'description': _descriptionController.text,
      'price': int.parse(_priceController.text),
      'Address': _addressController.text,
      'mileage': int.parse(_mileageController.text),
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
    var response = await http.put(
      url,
      headers: headers,
      body: jsonData,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the response JSON
      Navigator.pop(context);
      //because the response from server it cover with {statusCode:200,data:{...}}
    } else {
      print(response.body);
      var responseData = json.decode(response.body);
      var errorMessage = responseData["data"];
      print(errorMessage);
    }
  }
}
