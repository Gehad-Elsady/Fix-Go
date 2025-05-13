import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:road_mate/location/model/locationmodel.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/screens/cart/model/cart-model.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';

class AcceptedModel {
  ServiceModel? serviceModel;
  String userId;
  String orderStatus;
  List<CartModel>? items;
  double totalPrice;
  String orderType;
  int orderTime;
  HistoryModel historyModel;
  ProfileModel profileModel;
  LocationModel locationModel;
  AcceptedModel(
      {required this.serviceModel,
      required this.userId,
      this.items,
      required this.totalPrice,
      required this.orderType,
      required this.orderTime,
      required this.historyModel,
      required this.profileModel,
      required this.locationModel,
      required this.orderStatus});

  Map<String, dynamic> toJson() {
    return {
      'serviceModel': serviceModel?.toJson(),
      'userId': userId,
      'orderStatus': orderStatus,
      'totalPrice': totalPrice,
      'items': items?.map((item) => item.toMap()).toList(),
      'orderType': orderType,
      'orderTime': orderTime,
      'profileModel': profileModel.toJson(),
      'historyModel': historyModel.toJson(),
      'locationModel': locationModel.toMap(),
    };
  }

  factory AcceptedModel.fromJson(Map<String, dynamic> json) {
    return AcceptedModel(
      serviceModel: ServiceModel.fromJson(json['serviceModel']),
      userId: json['userId'],
      orderStatus: json['orderStatus'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartModel.fromMap(item))
          .toList(),
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
      orderType: json['orderType'] ?? 'default',
      orderTime: json['orderTime']?.toInt() ?? 0,
      historyModel: HistoryModel.fromJson(json['historyModel']),
      profileModel: ProfileModel.fromJson(json['profileModel']),
      locationModel: LocationModel.fromMap(json['locationModel']),
    );
  }
}
