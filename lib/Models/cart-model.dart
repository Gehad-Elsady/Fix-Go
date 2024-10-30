import 'package:road_mate/Models/service-model.dart';

class CartModel {
  ServiceModel serviceModel;
  String userId;
  CartModel({required this.serviceModel, required this.userId});
  Map<String, dynamic> toMap() {
    return {
      'serviceModel': serviceModel.toJson(),
      'userId': userId,
    };
  }

  static CartModel fromMap(Map<String, dynamic> map) {
    return CartModel(
      serviceModel: ServiceModel.fromJson(map['serviceModel']),
      userId: map['userId'],
    );
  }
}
