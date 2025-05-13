import 'package:road_mate/location/model/locationmodel.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/screens/cars/models/car.dart';
import 'package:road_mate/screens/cart/model/cart-model.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';

class HistoryModel {
  String? id;
  List<CartModel>? items;
  String? userId;
  String? orderType;
  String? orderStatus;
  String? orderOwnerName;
  String? orderOwnerPhone;
  ServiceModel? serviceModel;
  LocationModel? locationModel;
  double? totalPrice;
  int? timestamp;
  Car? car; // Make it nullable to avoid required in constructor
  ProfileModel? profileModel;
  LocationModel? providerLocationModel;

  HistoryModel({
    this.id,
    this.items,
    this.userId,
    this.orderType,
    this.serviceModel,
    this.locationModel,
    this.timestamp,
    this.orderStatus,
    this.orderOwnerName,
    this.orderOwnerPhone,
    this.totalPrice,
    this.car,
    this.profileModel,
    this.providerLocationModel,
  });

  // Named constructor for deserialization
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartModel.fromMap(item))
          .toList(),
      userId: json['userId'] as String?,
      orderType: json['OrderType'] as String?,
      serviceModel: json['serviceModel'] != null
          ? ServiceModel.fromJson(json['serviceModel'])
          : null,
      locationModel: json['locationModel'] != null
          ? LocationModel.fromMap(json['locationModel'])
          : null,
      timestamp: json['timestamp'] != null ? (json['timestamp'] as int) : null,
      orderStatus: json['orderStatus'] as String?,
      orderOwnerName: json['orderOwnerName'] as String?,
      orderOwnerPhone: json['orderOwnerPhone'] as String?,
      totalPrice: json['totalPrice'] != null
          ? (json['totalPrice'] as num).toDouble()
          : null,
      car: json['car'] != null ? Car.fromJson(json['car']) : null,
      profileModel: json['profileModel'] != null
          ? ProfileModel.fromJson(json['profileModel'])
          : null,
      providerLocationModel: json['providerLocationModel'] != null
          ? LocationModel.fromMap(json['providerLocationModel'])
          : null,
    );
  }

  // Method for serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['items'] = items?.map((item) => item.toMap()).toList();
    data['userId'] = userId;
    data['OrderType'] = orderType;
    data['serviceModel'] = serviceModel?.toJson();
    data['locationModel'] = locationModel?.toMap();
    data['timestamp'] = timestamp;
    data['orderStatus'] = orderStatus;
    data['orderOwnerName'] = orderOwnerName;
    data['orderOwnerPhone'] = orderOwnerPhone;
    data['totalPrice'] = totalPrice;
    data['car'] = car?.toJson();
    data['profileModel'] = profileModel?.toJson();
    data['providerLocationModel'] = providerLocationModel?.toMap();
    return data;
  }
}
