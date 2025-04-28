import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/location/location.dart';
import 'package:road_mate/screens/bottom%20sheet/request_bootomsheet.dart';
import 'package:road_mate/screens/cart/widget/cartitem.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'cart'.tr(),
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xFF0091ad),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("are-you-sure".tr()),
                    actions: [
                      TextButton(
                        child: Text("yes".tr()),
                        onPressed: () {
                          FirebaseFunctions.clearCart(
                              FirebaseAuth.instance.currentUser!.uid);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("no".tr()),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFunctions.getCardStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(Photos.emptyCart),
                  Text(
                    'cart-empty'.tr(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }

            // Calculate the total price by summing the prices of all items
            int totalPrice = snapshot.data!
                .map((item) => int.parse(
                    item.serviceModel.price)) // Safe parse with fallback
                .reduce((value, element) => value + element); // Sum all prices

            return Column(
              children: [
                // List of cart items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final service = snapshot.data![index].serviceModel;
                      String itemId = snapshot.data![index].itemId ?? "";
                      return Column(
                        children: [
                          CartItem(service: service, itemId: itemId),
                        ],
                      );
                    },
                  ),
                ),
                // Total price at the bottom of the page
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total-price'.tr(),
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'checkout'.tr(),
                        style: GoogleFonts.domine(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      onPressed: () async {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          backgroundColor: Colors.white,
                          builder: (context) {
                            return RequestBottomSheet(
                              items: snapshot.data,
                              orderType: "Cart",
                              totalPrice: totalPrice.toDouble(),
                            );
                          },
                        );
                        // try {
                        //   // Fetch the user profile
                        //   ProfileModel? profileModel =
                        //       await FirebaseFunctions.getUserProfile(
                        //               FirebaseAuth.instance.currentUser!.uid)
                        //           .first;

                        //   if (profileModel == null) {
                        //     // Show an alert dialog if the profile is null
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) {
                        //         return AlertDialog(
                        //           title: Text('no-profile'.tr()),
                        //           content: Text('profile-error'.tr()),
                        //           actions: <Widget>[
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //               child: Text('ok'.tr()),
                        //             ),
                        //           ],
                        //         );
                        //       },
                        //     );
                        //   } else {
                        //     // Log the user's name for debugging
                        //     print(
                        //         '--------------Name is ${profileModel.firstName}');
                        //     HistoryModel historymaodel = HistoryModel(
                        //       totalPrice: totalPrice.toDouble(),
                        //       userId: FirebaseAuth.instance.currentUser!.uid,
                        //       items: snapshot.data!,
                        //       orderType: "Cart",
                        //     );
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => Gps(
                        //           historymaodel: historymaodel,
                        //           totalPrice: totalPrice,
                        //         ),
                        //       ),
                        //     );
                        //   }
                        // } catch (e) {
                        //   // Handle exceptions and display an error message
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text('Error: ${e.toString()}'),
                        //       backgroundColor: Colors.red,
                        //     ),
                        //   );
                        // }
                      }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
