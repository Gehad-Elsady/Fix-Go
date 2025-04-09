import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  String name;
  String image;
  String description;
  String price;
  String userId;
  Timestamp createdAt;
  ServiceModel(
      {required this.name,
      required this.image,
      required this.description,
      required this.userId,
      required this.createdAt,
      required this.price});
  factory ServiceModel.fromJson(Map<dynamic, dynamic> json) => ServiceModel(
        name: json['name'],
        image: json['image'],
        description: json['description'],
        price: json['price'],
        userId: json['userId'],
        createdAt: json['createdAt'],
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'description': description,
        'price': price,
        'userId': userId,
        'createdAt': createdAt,
      };
}
