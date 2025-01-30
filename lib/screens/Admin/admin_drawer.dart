import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/Admin/add_eng.dart';
import 'package:road_mate/screens/Admin/admin_srttings.dart';
import 'package:road_mate/screens/Admin/manege_services.dart';
import 'package:road_mate/screens/Admin/manegeeng.dart';
import 'package:road_mate/screens/add-services/addservicescreen.dart';
import 'package:road_mate/screens/settings/settings_tab.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: const NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                  ),
                ),
                Text(
                  'admin'.tr(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.domine(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    'add-service'.tr(),
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
                    Navigator.pop(context);

                    Navigator.pushNamed(context, AddServicePage.routeName);
                  },
                ),
                ListTile(
                  title: Text(
                    'add-engineers'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  leading: const Icon(
                    Icons.engineering,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AddEng.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.manage_accounts_outlined,
                    color: Colors.black,
                  ),
                  title: Text(
                    'manage-services'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, ManegeServices.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.update,
                    color: Colors.black,
                  ),
                  title: Text(
                    'manage-engineers'.tr(),
                    style: GoogleFonts.domine(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, Manegeeng.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.update,
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
                    Navigator.pop(context);

                    Navigator.pushNamed(context, AdminSettingsTab.routeName);
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
        ],
      ),
    );
  }
}
