import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/location/location.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/screens/cars/models/car.dart';
import 'package:road_mate/screens/cart/model/cart-model.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';
import 'package:road_mate/services/car_service.dart';

class RequestBottomSheet extends StatelessWidget {
  RequestBottomSheet(
      {super.key,
      this.serviceModel,
      this.items,
      this.orderType,
      this.totalPrice});
  ServiceModel? serviceModel;
  List<CartModel>? items;
  String? orderType;
  double? totalPrice;

  final CarService _carService = CarService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFADE8F4),
            Color(0xFFCAF0F8),
            Color(0xFF90E0EF),
            Color(0xFF90E0EF),
            Color(0xFF48CAE4),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            "select-car".tr(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: _carService.getCars(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('error'.tr() + ': ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return  Center(child: Text('no-cars-found'.tr()));
                }

                final cars = snapshot.data!;

                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Icon(
                          Icons.directions_car,
                          size: 50,
                          color: Colors.blue.withOpacity(0.5),
                        ),
                        title: Text(
                          '${car.make} ${car.model}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'year'.tr() + ': ${car.year}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'color'.tr() + ': ${car.color}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'license'.tr() + ': ${car.licensePlate}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'vin'.tr() + ': ${car.vin}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (orderType == "Quick Order") {
                            try {
                              // Fetch the user profile
                              ProfileModel? profileModel =
                                  await FirebaseFunctions.getUserProfile(
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .first;

                              if (profileModel == null) {
                                // Show an alert dialog if the profile is null
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('no-profile'.tr()),
                                      content: Text(
                                          'profile-error'.tr()),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('ok'.tr()),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Log the user's name for debugging
                                print(
                                    '--------------Name is ${profileModel.firstName}');

                                // Create a HistoryModel instance
                                final historymaodel = HistoryModel(
                                    serviceModel: serviceModel,
                                    orderType: "Quick Order",
                                    car: car);

                                // Navigate to the GPS screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Gps(
                                      historymaodel: historymaodel,
                                      totalPrice:
                                          double.parse(serviceModel!.price),
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Handle exceptions and display an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else if (orderType == "Cart") {
                            try {
                              // Fetch the user profile
                              ProfileModel? profileModel =
                                  await FirebaseFunctions.getUserProfile(
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .first;

                              if (profileModel == null) {
                                // Show an alert dialog if the profile is null
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('no-profile'.tr()),
                                      content: Text('profile-error'.tr()),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('ok'.tr()),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Log the user's name for debugging
                                print(
                                    '--------------Name is ${profileModel.firstName}');
                                HistoryModel historymaodel = HistoryModel(
                                    totalPrice: totalPrice,
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    items: items,
                                    orderType: "Cart",
                                    car: car);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Gps(
                                      historymaodel: historymaodel,
                                      totalPrice: totalPrice!,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              // Handle exceptions and display an error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
