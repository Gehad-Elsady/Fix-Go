import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/signup-screen.dart';
import 'package:road_mate/Auth/signup_provider_screen.dart';

class AuthPage extends StatelessWidget {
  static const String routeName = 'AuthPage';
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/Informative Card.png",
                fit: BoxFit.cover, // Ensures the image covers the whole screen
              ),
              Positioned(
                bottom: 50, // Adjust this value for positioning
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "welcome-to-fixgo".tr(),
                      style: GoogleFonts.lora(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10), // Space between texts
                    Text(
                      "we-care-about-your-safety".tr(),
                      style: GoogleFonts.lora(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff797A7B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 120),
          Divider(
            color: Colors.grey,
            thickness: 1,
            endIndent: 20,
            indent: 20,
          ), // Space between image and buttons
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, SignUpPage.routeName);
              },
              child: Text(
                "i-am-a-customer".tr(),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff041D56),
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
          SizedBox(height: 50), // Space between buttons
          Divider(
            color: Colors.grey,
            thickness: 1,
            endIndent: 20,
            indent: 20,
          ), // Space between image and buttons
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, SignupProvider.routeName);
              },
              child: Text(
                "i-am-a-provider".tr(),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff266CA9),
                padding: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
          SizedBox(height: 30), // Space between buttons and login text
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: "have-an-account".tr(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: "login".tr(),
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
