import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/screens/services/all-services-screen.dart';
import 'package:road_mate/screens/cart/cart-screen.dart';
import 'package:road_mate/screens/contact/contact-screen.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/home/home-screen.dart';
import 'package:road_mate/screens/settings/settings_tab.dart';
import 'package:road_mate/screens/profile/user-profile-screen.dart';
import 'package:road_mate/widget/drawer/social-media-icons.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFunctions.getUserProfile(
                  FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2e6f95),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            snapshot.data!.profileImage,
                          ),
                        ),
                        Text(
                          snapshot.data!.email,
                          style: GoogleFonts.domine(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF2e6f95),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF2e6f95),
                    ),
                    child: Center(
                      child: Text(
                        "Unable to load profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              }),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'home'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.home,
                    color: Color(0xFF723c70),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                    'services'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.miscellaneous_services_outlined,
                    color: Color(0xFF723c70),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AllServicesScreen.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                    'cart'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.shopping_cart_rounded,
                    color: Color(0xFF723c70),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                    'contact'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  leading: const Icon(
                    Icons.contact_page,
                    color: Color(0xFF723c70),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ContactScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: Color(0xFF723c70),
                  ),
                  title: Text(
                    'profile'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, UserProfile.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Color(0xFF723c70),
                  ),
                  title: Text(
                    'settings'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, SettingsTab.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Color(0xFF723c70),
                  ),
                  title: Text(
                    'logout'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    FirebaseFunctions.signOut();
                    Navigator.pushReplacementNamed(
                        context, LoginPage.routeName);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          SocialMediaIcons(),
        ],
      ),
    );
  }
}
