// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/model/usermodel.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/paymob/paymob_manager.dart';
import 'package:road_mate/screens/cart/cart-screen.dart';
import 'package:road_mate/screens/history/historyscreen.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({
    super.key,
    required this.totalPrice,
    // required this.profileModel,
    // required this.email,
    // required this.password
  });
  InAppWebViewController? _webViewController;
  final double totalPrice;
  // UserModel profileModel;
  // String email;
  // String password;

  @override
  Widget build(BuildContext context) {
    // print("profile model++++++++++++++ ${profileModel}");
    // print("email++++++++++++++ ${email}");
    // print("password++++++++++++++ ${password}");
    return Scaffold(
      appBar: AppBar(
        title: Text('payment-screen'.tr()),
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          PaymobManager()
              .getPaymentKey(totalPrice, "EGP")
              .then((String paymentKey) {
            _webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(
                  "https://accept.paymob.com/api/acceptance/iframes/915260?payment_token=$paymentKey",
                ),
              ),
            );
          });
        },
        onLoadStop: (controller, url) async {
          if (url != null && url.queryParameters.containsKey('success')) {
            if (url.queryParameters['success'] == 'true') {
              FirebaseFunctions.subscription();
              // FirebaseFunctions.SignUp(
              //   role: "Provider",
              //   emailAddress: email,
              //   password: password,
              //   phoneNumber: profileModel.phoneNumber,
              //   firstName: profileModel.firstName,
              //   lastName: profileModel.lastName,
              //   imageUrl: profileModel.imageUrl!,
              //   onSuccess: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) => AlertDialog(
              //         content: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Lottie.asset(Photos.create),
              //             const SizedBox(height: 16),
              //             const Text(
              //               "Please Verify Your Email Address to Login",
              //               textAlign: TextAlign.center,
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              //   onError: (e) {
              //     showDialog(
              //       context: context,
              //       builder: (context) => AlertDialog(
              //         title: Text("Error"),
              //         content: Text(e.toString()),
              //         actions: [
              //           TextButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             child: Text('OK'),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // );
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("payment-done".tr()),
                    actions: [
                      TextButton(
                        child: Text("ok".tr()),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginPage.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
              print("Payment Done");
            } else if (url.queryParameters['success'] == 'false') {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("payment-failed".tr()),
                    actions: [
                      TextButton(
                        child: Text("ok".tr()),
                        onPressed: () {
                          Navigator.pushNamed(context, CartScreen.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
              print("Payment Failed");
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("payment-canceled".tr()),
                        actions: [
                          TextButton(
                              child: Text("ok".tr()),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, CartScreen.routeName);
                              })
                        ]);
                  });
            }
          }
        },
      ),
    );
  }
}
