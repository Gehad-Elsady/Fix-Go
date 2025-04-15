import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  String name;
  String price;
  String userId;
  Timestamp createdAt;
  ServiceModel(
      {required this.name,
      required this.userId,
      required this.createdAt,
      required this.price});
  factory ServiceModel.fromJson(Map<dynamic, dynamic> json) => ServiceModel(
        name: json['name'],
        price: json['price'],
        userId: json['userId'],
        createdAt: json['createdAt'],
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'userId': userId,
        'createdAt': createdAt,
      };
}
