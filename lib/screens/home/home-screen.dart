import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/screens/home/widget/appbar.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/theme/app-colors.dart';
import 'package:road_mate/widget/devider/mydevider.dart';
import 'package:road_mate/widget/drawer/mydrawer.dart';
import 'package:road_mate/screens/home/widget/services-part.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home-screen';
  HomeScreen({super.key});

  // List of images for the Carousel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Photos.logo,
              height: 40,
            ),
            SizedBox(width: 10), // Added spacing between logo and title
            Text(
              'fix-and-go'.tr(),
              style: GoogleFonts.domine(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ), // Applying Domine font to the title
            ),
          ],
        ),
        backgroundColor: Color(0xFF0091ad),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backGround,
            ),
          ),
          child: Column(
            children: [
              // Carousel Slider
              MyAppBar(),
              SizedBox(
                  height:
                      20), // Adding some spacing between carousel and grid of images
              MyDivider(
                text: "services".tr(),
              ),
              // show what services we offer
              ServicesPart(),
              MyDivider(text: "partners".tr()),
              // Fixed height for GridView
              Container(
                height: 400, // Set fixed height for GridView
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
