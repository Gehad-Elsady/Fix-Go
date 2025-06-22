import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/screens/Provider/settings/provider_srttings.dart';
import 'package:road_mate/screens/Provider/home/widget/provider_info.dart';
import 'package:road_mate/screens/Provider/services/manege_services.dart';
import 'package:road_mate/screens/Provider/add-services/addservicescreen.dart';

class ProviderProfileTap extends StatelessWidget {
  ProviderProfileTap({super.key});

  List<String> cardsName = [
    "services".tr(),
    "add-services".tr(),
    'settings'.tr(),
  ];
  List<String> cardsImage = [
    "assets/images/Tool.png",
    "assets/images/wrench (1).png",
    "assets/images/settings.png",
  ];
  List<String> cardsRoute = [
    ManegeServices.routeName,
    AddServicePage.routeName,
    ProviderSettings.routeName,
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "profile".tr(), // Add to your .json translations
              style: GoogleFonts.lora(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const ProviderInfo(),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey, thickness: 1.5),
            const SizedBox(height: 20),
            Text(
              "account-details".tr(), // Add to your .json translations
              style: GoogleFonts.lora(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            // Wrap GridView inside Expanded
            Expanded(
              child: GridView.builder(
                itemCount: cardsName.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, cardsRoute[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffEAEAEA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            cardsImage[index],
                            height: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            cardsName[
                                index], // Also add to your .json translations
                            style: GoogleFonts.lora(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
