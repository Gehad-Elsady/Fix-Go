import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/model/usermodel.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/Admin/admin_home.dart';

import 'dart:async';

import 'package:road_mate/screens/SplashScreen/OnBoarding/boarding-screen.dart';
import 'package:road_mate/screens/home/home-screen.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/screens/SplashScreen/provider/check-user.dart';
import 'package:road_mate/screens/SplashScreen/provider/finish-onboarding.dart';
import 'package:road_mate/screens/user%20home/main_hame.dart';
// import 'package:road_mate/theme/app-colors.dart';
// import 'package:recycling_app/home-screen.dart'; // Import HomeScreen

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash-screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Remove the Provider access from initState
    // Delay navigation to allow context to be ready
    getUserData();
    Future.delayed(Duration.zero, () {
      navigateToNextScreen();
    });
  }

// Function to fetch user data
  Future<UserModel?> getUserData() async {
    try {
      UserModel? userRole = await FirebaseFunctions.readUserData();
      return userRole;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

// Function to navigate to the next screen
  void navigateToNextScreen() async {
    var provider = Provider.of<FinishOnboarding>(context, listen: false);
    var user = Provider.of<CheckUser>(context, listen: false);

    Timer(const Duration(seconds: 10), () async {
      print("Onboarding completed: ${provider.isOnBoardingCompleted}");

      if (user.firebaseUser != null) {
        // Fetch user data
        UserModel? userRole = await getUserData();

        if (userRole != null) {
          if (userRole.role == "User") {
            Navigator.pushReplacementNamed(context, MainHame.routeName);
          } else if (userRole.role == "Provider") {
            Navigator.pushReplacementNamed(context, AdminHome.routeName);
          } else {
            print("Error: User role is unknown.");
          }
        } else {
          print("Error: User data is null.");
        }
      } else {
        Navigator.pushReplacementNamed(
          context,
          provider.isOnBoardingCompleted
              ? LoginPage.routeName
              : OnboardingScreen.routeName,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height and width for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: AppColors.backGround,
          // ),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: size.height * 0.08),
                  Image.asset(
                    Photos.loading,
                    height: size.height * 0.4,
                  ),
                  SizedBox(height: size.height * 0.08),
                  Text(
                    "slogan".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "splash-slogan".tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
