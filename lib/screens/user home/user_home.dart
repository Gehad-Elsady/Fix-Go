import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/constants/photos/photos.dart';
import 'package:road_mate/screens/user%20home/frist_part.dart';
import 'package:road_mate/screens/user%20home/second_part.dart';
import 'package:road_mate/screens/user%20home/third_part.dart';

class UserHome extends StatelessWidget {
  static const String routeName = 'user-home';
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Photos.logo, // Ensure this asset exists
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'fix-and-go'.tr(),
              style: GoogleFonts.domine(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FristPart(),
            SizedBox(height: 20),
            SecoundPart(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Services",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            ThirdPart(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "Services History",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomClipPath extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height - 100);

//     // First downward curve
//     path.quadraticBezierTo(
//         size.width * 0.25, size.height - 140, size.width * 0.5, size.height);

//     // Second upward curve
//     path.quadraticBezierTo(
//         size.width * 0.75, size.height + 80, size.width, size.height);

//     path.lineTo(size.width, 0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }
