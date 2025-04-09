import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/model/usermodel.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/screens/Provider/admin_drawer.dart';
import 'package:road_mate/screens/Provider/home/widget/requests_part.dart';

class ProviderHomeTap extends StatelessWidget {
  static const String routeName = 'admin-home';
  const ProviderHomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AdminDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.asset(Photos.logo),
        centerTitle: true,
        title: Text(
          'fix-and-go'.tr(),
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ), // Applying Domine font to the title
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.access_time_rounded,
              color: Colors.black,
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
            FutureBuilder(
              future: FirebaseFunctions.readUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('No user data found'));
                } else {
                  UserModel userModel = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      textAlign: TextAlign.start,
                      "Hello ${userModel.firstName} ${userModel.lastName}",
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }
              },
            ),
            RequestsPart(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                // height: 369,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Pending Requests",
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.5,
                      ),
                      Text(
                        "Oil Change",
                        style: GoogleFonts.lora(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Maadi",
                        style: GoogleFonts.lora(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("49.99 EGP", style: GoogleFonts.lora()),
                      SizedBox(height: 10),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffADE1FB),
                          ),
                          onPressed: () {},
                          child: Text("Waiting",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ))),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
