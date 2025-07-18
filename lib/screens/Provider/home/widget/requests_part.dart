// Your imports remain the same
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/location/model/locationmodel.dart';
import 'package:road_mate/notifications/notification_back.dart';
import 'package:road_mate/screens/Provider/add-services/addservicescreen.dart';
import 'package:road_mate/screens/Provider/home/model/accepted_model.dart';
import 'package:road_mate/screens/Provider/location/order_location.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';

class RequestsPart extends StatelessWidget {
  const RequestsPart({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Container(
      height: 375,
      child: StreamBuilder<List<ServiceModel>>(
        stream: FirebaseFirestore.instance
            .collection('services')
            .where('userId', isEqualTo: currentUserId)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => ServiceModel.fromJson(doc.data()))
                .toList()),
        builder: (context, servicesSnapshot) {
          if (servicesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (servicesSnapshot.hasError) {
            return Center(
                child:
                    Text("Error loading services: ${servicesSnapshot.error}"));
          }

          if (!servicesSnapshot.hasData || servicesSnapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("no-services-message".tr()),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddServicePage.routeName);
                    },
                    child: Text("add-services".tr()),
                  ),
                ],
              ),
            );
          }

          final userServiceNames =
              servicesSnapshot.data!.map((s) => s.name).toList();

          return StreamBuilder<List<HistoryModel>>(
            stream: FirebaseFunctions.getAdminRequestStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text("Error loading history: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("request-empty".tr()));
              }

              final historyList = snapshot.data!.where((history) {
                if (history.serviceModel != null) {
                  return userServiceNames.contains(history.serviceModel!.name);
                }
                if (history.items != null && history.items!.isNotEmpty) {
                  return history.items!.any((item) =>
                      userServiceNames.contains(item.serviceModel.name));
                }
                return false;
              }).toList();

              if (historyList.isEmpty) {
                return Center(child: Text("no-matching-requests".tr()));
              }

              return SizedBox(
                height: 395,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    final history = historyList[index];

                    DateTime timestamp = history.timestamp != null
                        ? DateTime.fromMillisecondsSinceEpoch(
                            history.timestamp!)
                        : DateTime.now();
                    String formattedTime = DateFormat.yMd().add_jm()
                        .format(timestamp.toLocal());

                    const whiteTextStyle =
                        TextStyle(color: Colors.white, fontSize: 18);
                    const boldWhiteTextStyle = TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold);

                    return SingleChildScrollView(
                      child: Container(
                        width: 198,
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Card(
                          color: Color(0xff01082D),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(history.orderType ?? '',
                                    style: whiteTextStyle),
                                SizedBox(height: 8),
                                Text(formattedTime, style: whiteTextStyle),
                                Text(history.orderOwnerName ?? 'No Name',
                                    style: whiteTextStyle),
                                Text(history.orderOwnerPhone ?? 'No Phone',
                                    style: whiteTextStyle),
                                TextButton(
                                  onPressed: () {
                                    if (history.locationModel != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderLocation(
                                            longitude: history
                                                .locationModel!.longitude,
                                            latitude:
                                                history.locationModel!.latitude,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("order-location".tr(),
                                      style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                ),
                                if (history.serviceModel != null) ...[
                                  SizedBox(height: 4),
                                  Text(history.serviceModel!.name,
                                      style: whiteTextStyle),
                                  Text(history.serviceModel!.price + " EGP",
                                      style: whiteTextStyle),
                                ],
                                if (history.items != null &&
                                    history.items!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: history.items!.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${item.serviceModel.name}",
                                                style: whiteTextStyle),
                                            Text(
                                                item.serviceModel.price +
                                                    " EGP",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                SizedBox(height: 10),
                                Center(
                                  child: history.orderStatus == 'Pending'
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF0091ad)),
                                          onPressed: () async {
                                            try {
                                              final currentOrders =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('MyOrders')
                                                      .where('userId',
                                                          isEqualTo:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                      .get();

                                              if (currentOrders.docs.length >=
                                                  3) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'maximum-number-of-orders-reached'
                                                            .tr()),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                return;
                                              }

                                              ProfileModel? profileModel =
                                                  await FirebaseFunctions
                                                          .getUserProfile(
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                      .first;

                                              Location location = Location();
                                              bool _serviceEnabled =
                                                  await location
                                                      .serviceEnabled();
                                              if (!_serviceEnabled) {
                                                _serviceEnabled = await location
                                                    .requestService();
                                                if (!_serviceEnabled)
                                                  throw Exception(
                                                      'Location service not enabled');
                                              }

                                              PermissionStatus
                                                  _permissionGranted =
                                                  await location
                                                      .hasPermission();
                                              if (_permissionGranted ==
                                                  PermissionStatus.denied) {
                                                _permissionGranted =
                                                    await location
                                                        .requestPermission();
                                                if (_permissionGranted !=
                                                    PermissionStatus.granted) {
                                                  throw Exception(
                                                      'Location permission not granted');
                                                }
                                              }

                                              final userLocation =
                                                  await location.getLocation();
                                              final locationModel =
                                                  LocationModel(
                                                latitude:
                                                    userLocation.latitude ?? 0.0,
                                                longitude:
                                                    userLocation.longitude ??
                                                        0.0,
                                              );

                                              await FirebaseFunctions
                                                  .acceptedOrder(
                                                      history.userId!,
                                                      history.timestamp!,
                                                      profileModel!,
                                                      locationModel);

                                              AcceptedModel acceptedModel =
                                                  AcceptedModel(
                                                historyModel: history,
                                                orderTime: DateTime.now()
                                                    .millisecondsSinceEpoch,
                                                orderType: history.orderType!,
                                                totalPrice:
                                                    history.totalPrice!,
                                                serviceModel:
                                                    history.serviceModel,
                                                items: history.items,
                                                userId: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                orderStatus: "Not completed",
                                                profileModel: profileModel,
                                                locationModel: locationModel,
                                              );

                                              await FirebaseFunctions
                                                  .addOrderToMyList(
                                                      acceptedModel);

                                              NotificationBack
                                                  .sendAcceptNotification(
                                                      history.userId!);
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error accepting order: ${e.toString()}'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: Text("accept-order".tr(),
                                              style: boldWhiteTextStyle),
                                        )
                                      : Text(
                                          "this-order-is-already-accepted".tr(),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
