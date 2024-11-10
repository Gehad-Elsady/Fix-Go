import 'package:road_mate/screens/add-services/model/service-model.dart';
import 'package:road_mate/screens/cart/model/cart-model.dart';

class Historymaodel {
  String? id;
  List<CartModel>? items;
  String? userId;
  String? OrderType;
  ServiceModel? serviceModel;

  Historymaodel(
      {this.id, this.items, this.userId, this.OrderType, this.serviceModel});

  Historymaodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['items'] != null) {
      items = json['items'].map((item) => CartModel.fromMap(item)).toList();
    }
    userId = json['userId'];
    OrderType = json['OrderType'];
    serviceModel = ServiceModel.fromJson(json['serviceModel']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['items'] = items?.map((item) => item.toMap()).toList();
    data['userId'] = userId;
    data['OrderType'] = OrderType;
    data['serviceModel'] = serviceModel?.toJson();
    return data;
  }
}
