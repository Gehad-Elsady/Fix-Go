import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';
import 'package:road_mate/screens/profile/user-profile-screen.dart';

class ProviderInfo extends StatelessWidget {
  const ProviderInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFunctions.getUserProfile(
          FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading spinner
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Row(
            children: [
              CircleAvatar(
                radius: 50.0,
              ),
              const SizedBox(width: 18.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "welcome-to-fix-and-go".tr(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "user-name".tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, UserProfile.routeName);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Text("edit-profile".tr())))
            ],
          );
        }
        ProfileModel userProfile = snapshot.data!;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}",
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userProfile.email ?? "No email provided",
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, UserProfile.routeName);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: Text("edit-profile".tr())))
              ],
            ),
            CircleAvatar(
              radius: 50.0,
              backgroundImage: (userProfile.profileImage ?? '').isNotEmpty
                  ? NetworkImage(userProfile.profileImage)
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
            ),
          ],
        );
      },
    );
  }
}
