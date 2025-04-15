import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/model/usermodel.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/screens/user%20home/main_hame.dart';
import 'package:road_mate/widget/services-item.dart';

class CustomerHomeScreen extends StatelessWidget {
  static const String routeName = 'customer-home-screen';
  const CustomerHomeScreen({super.key});

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
          ), // Applying Domine font to the title
        ),
        actions: [
          IconButton(
            icon: ImageIcon(
              AssetImage("assets/images/calendar.png"),
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              FirebaseFunctions.signOut();
              Navigator.pushReplacementNamed(
                context,
                LoginPage.routeName,
              );
            },
          ),
        ],
      ),
      body: Column(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Hello ${userModel.firstName} ${userModel.lastName}",
                        style: GoogleFonts.lora(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "We have some recommendations for you",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(height: 50),
          Text("Services",
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<List<ServiceModel>>(
              stream: FirebaseFunctions.getServicesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No services available'));
                }

                List<ServiceModel> serviceModel = snapshot.data!;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio:
                        115 / 156, // Adjusted for exact width & height
                  ),
                  itemCount: serviceModel.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color(0xffF6F6F6),
                      child: SizedBox(
                        width: 115,
                        height: 156,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                        8)), // Optional: Rounded corners
                                child: Image.asset(
                                  "assets/images/services/${serviceModel[index].name}.png",
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit
                                      .contain, // Ensures the image fills the available space
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                serviceModel[index].name,
                                style: GoogleFonts.lora(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color(0xff303539),
                                    size: 15,
                                  ),
                                  Text(
                                    "4.25",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
