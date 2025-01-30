import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/screens/engineers/engineera_screen.dart';
import 'package:road_mate/screens/history/historyscreen.dart';
import 'package:road_mate/screens/services/all-services-screen.dart';
import 'package:road_mate/screens/cart/cart-screen.dart';
import 'package:road_mate/screens/contact/contact-screen.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/home/home-screen.dart';
import 'package:road_mate/screens/settings/settings_tab.dart';
import 'package:road_mate/screens/profile/user-profile-screen.dart';
import 'package:road_mate/screens/user%20home/main_hame.dart';
import 'package:road_mate/screens/user%20home/user_home.dart';
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
                      color: Colors.blue,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/005/720/408/small_2x/crossed-image-icon-picture-not-available-delete-picture-symbol-free-vector.jpg',
                        )),
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
                      color: Colors.blue,
                    ),
                  ),
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                    'services'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  leading: const Icon(
                    Icons.miscellaneous_services_outlined,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, AllServicesScreen.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                    'engineers'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  leading: const Icon(
                    Icons.engineering_rounded,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, EngineersScreen.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                    'cart'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  leading: const Icon(
                    Icons.shopping_cart_rounded,
                    color: Colors.black,
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
                      color: Colors.blue,
                    ),
                  ),
                  leading: const Icon(
                    Icons.contact_page,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ContactScreen.routeName);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: Colors.black,
                  ),
                  title: Text(
                    'profile'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
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
                    Icons.history,
                    color: Colors.black,
                  ),
                  title: Text(
                    'history'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, HistoryScreen.routeName);
                    print(FirebaseAuth.instance.currentUser?.uid);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  title: Text(
                    'settings'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
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
                    color: Colors.black,
                  ),
                  title: Text(
                    'logout'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
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
