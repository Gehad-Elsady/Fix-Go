import 'package:cloud_firestore/cloud_firestore.dart';

class EngModel {
  String name;
  String image;
  String bio;
  String price;
  String userId;
  Timestamp createdAt;
  String phone;
  String address;
  EngModel(
      {required this.name,
      required this.image,
      required this.bio,
      required this.price,
      required this.userId,
      required this.phone,
      required this.address,
      required this.createdAt});

  factory EngModel.fromJson(Map<dynamic, dynamic> json) => EngModel(
        name: json['name'],
        image: json['image'],
        bio: json['bio'],
        price: json['price'],
        userId: json['userId'],
        createdAt: json['createdAt'],
        phone: json['phone'],
        address: json['address'],
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'bio': bio,
        'price': price,
        'userId': userId,
        'createdAt': createdAt,
        'phone': phone,
        'address': address,
      };
}
