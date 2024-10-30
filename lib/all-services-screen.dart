import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Models/cart-model.dart';
import 'package:road_mate/firebase_functions.dart';
import 'package:road_mate/theme/app-colors.dart';
import 'package:road_mate/widget/mydrawer.dart';
import 'package:road_mate/widget/services-item.dart';

class AllServicesScreen extends StatelessWidget {
  static const String routeName = 'all-services-screen';
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Services',
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF0091ad),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backGround,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFunctions.getServicesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.none) {
              return Text('No services found');
            }
            final services = snapshot.data!;
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  elevation: 15,
                  shadowColor: Color(0xFF723c70),
                  color: Color(0xFF2e6f95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ServicesItem(
                        service: service,
                        buttonTitle: "Add to cart",
                        callBack: () {
                          CartModel model = CartModel(
                            serviceModel: service,
                            userId: FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                          );
                          FirebaseFunctions.addService(model);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
