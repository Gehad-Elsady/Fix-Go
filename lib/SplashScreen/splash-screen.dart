import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:road_mate/Auth/login-screen.dart';

import 'dart:async';

import 'package:road_mate/OnBoarding/boarding-screen.dart';
import 'package:road_mate/home-screen.dart';
import 'package:road_mate/photos/photos.dart';
import 'package:road_mate/providers/check-user.dart';
import 'package:road_mate/providers/finish-onboarding.dart';
import 'package:road_mate/theme/app-colors.dart';
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
    Future.delayed(Duration.zero, () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    var provider = Provider.of<FinishOnboarding>(context, listen: false);
    var user = Provider.of<CheckUser>(context,
        listen: false); // Updated to listen: false

    Timer(const Duration(seconds: 10), () {
      print(
          "000000000000000000000000000000000000000000000000000000${provider.isOnBoardingCompleted}");

      Navigator.pushReplacementNamed(
        context,
        user.firebaseUser != null
            ? HomeScreen.routeName
            : provider.isOnBoardingCompleted
                ? LoginPage.routeName
                : OnboardingScreen.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height and width for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backGround,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: size.height * 0.08),
                  Lottie.asset(
                    Photos.loading,
                    height: size.height * 0.4,
                  ),
                  SizedBox(height: size.height * 0.08),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: AppColors.title)
                            .createShader(bounds),
                    child: Text(
                      "Welcome to Fix & Go",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: AppColors.title)
                            .createShader(bounds),
                    child: Text(
                      "We care about Safety",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
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
