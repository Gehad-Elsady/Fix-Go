import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/screens/home/widgets/appbar.dart';

import 'package:road_mate/screens/home/widgets/my_orders.dart';
import 'package:road_mate/screens/home/widgets/services_part.dart';
import 'package:road_mate/screens/home/widgets/user_data.dart';

class CustomerHomeScreen extends StatefulWidget {
  static const String routeName = 'customer-home-screen';
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset(Photos.loading),
        centerTitle: true,
        title: Text(
          'fix-and-go'.tr(),
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: const Color.fromARGB(255, 137, 96, 96),
              size: 30,
            ),
            onPressed: () {
              // Handle notification button press
              // Navigator.pushNamed(context, MainHome.routeName);
              FirebaseFunctions.signOut();
              Navigator.pushReplacementNamed(
                context,
                LoginPage.routeName,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserData(),
            SizedBox(height: 25),
            MyAppBar(),
            SizedBox(height: 25,),
            
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("my-orders".tr(),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: screenHeight * 0.3, // adjust based on your design
              child: UserOrders(),
            ),
            SizedBox(height: 30),
            Text("services".tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                )),
            SizedBox(height: 20),
            SizedBox(
              height: screenHeight * 0.3, // adjust based on your design
              child: ServicesPart(),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
