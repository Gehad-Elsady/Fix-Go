import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';

class FristPart extends StatelessWidget {
  const FristPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder(
          stream: FirebaseFunctions.getUserProfile(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            ProfileModel? model = snapshot.data;
            return Stack(
              children: [
                ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    height: 200,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Welcome", // Corrected spelling
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            model?.firstName ?? "User",
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                model?.profileImage ??
                                    'https://static.vecteezy.com/system/resources/thumbnails/005/720/408/small_2x/crossed-image-icon-picture-not-available-delete-picture-symbol-free-vector.jpg',
                              )
                              // Replace with a valid image
                              ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width - 190, size.height - 90, size.width - 160, size.height + 30);
    path.quadraticBezierTo(
        size.width + 300, size.height, size.width + 300, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
