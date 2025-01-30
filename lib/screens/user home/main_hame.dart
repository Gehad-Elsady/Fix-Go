import 'package:flutter/material.dart';
import 'package:road_mate/screens/history/historyscreen.dart';
import 'package:road_mate/screens/profile/user-profile-screen.dart';
import 'package:road_mate/screens/user%20home/user_home.dart';

class MainHame extends StatefulWidget {
  static const String routeName = 'main-hame';
  const MainHame({super.key});

  @override
  State<MainHame> createState() => _MainHameState();
}

class _MainHameState extends State<MainHame> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: 30,
            ),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: "Profile",
          ),
        ],
      ),
      body: screens[selectedIndex],
    );
  }

  List<Widget> screens = [UserHome(), HistoryScreen(), UserProfile()];
}
