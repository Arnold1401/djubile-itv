// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Car {
  final int id;
  final int userId;
  final String carName;
  final String promotionEndDate;
  final String description;
  final int price;
  final String Address;
  final int mileage;
  final String carPicture;

  Car({
    required this.id,
    required this.userId,
    required this.carName,
    required this.promotionEndDate,
    required this.description,
    required this.price,
    required this.Address,
    required this.mileage,
    required this.carPicture,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'carName': carName,
      'promotionEndDate': promotionEndDate,
      'description': description,
      'price': price,
      'Address': Address,
      'mileage': mileage,
      'carPicture': carPicture,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as int,
      userId: map['userId'] as int,
      carName: map['carName'] as String,
      promotionEndDate: map['promotionEndDate'] as String,
      description: map['description'] as String,
      price: map['price'] as int,
      Address: map['Address'] as String,
      mileage: map['mileage'] as int,
      carPicture: map['carPicture'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  // factory Car.fromJson(String source) =>
  //     Car.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Car(userId: $userId, carName: $carName, promotionEndDate: $promotionEndDate, description: $description, price: $price, Address: $Address, mileage: $mileage, carPicture: $carPicture)';
  }
// }

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json["id"],
      userId: json['userId'],
      carName: json['carName'],
      promotionEndDate: json['promotionEndDate'],
      description: json['description'],
      price: json['price'] as int,
      Address: json['Address'] == null ? "" : json["Address"],
      mileage: json['mileage'] as int,
      carPicture: json['carPicture'],
    );
  }
}
