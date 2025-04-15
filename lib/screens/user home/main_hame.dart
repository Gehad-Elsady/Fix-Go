import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:road_mate/screens/Search/search_screen.dart';
import 'package:road_mate/screens/history/historyscreen.dart';
import 'package:road_mate/screens/home/customer_home_screen.dart';
import 'package:road_mate/screens/profile/user-profile-screen.dart';
import 'package:road_mate/screens/user%20home/prfile_tap.dart';
import 'package:road_mate/screens/user%20home/user_home.dart';

class MainHome extends StatefulWidget {
  static const String routeName = 'main-hame';
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHameState();
}

class _MainHameState extends State<MainHome>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [
    Color(0xffADE1FB),
    Color(0xffADE1FB),
    Color(0xffADE1FB),
  ];
  final Color unselectedColor = Colors.grey; // Define unselected color

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    tabController = TabController(length: 3, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomBar(
        child: TabBar(
          controller: tabController,
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: currentPage == 0
                  ? colors[0]
                  : currentPage == 1
                      ? colors[1]
                      : currentPage == 2
                          ? colors[2]
                          : unselectedColor,
              width: 4,
            ),
            insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
          ),
          tabs: [
            _buildTabIcon(Icons.home, 0),
            _buildTabIcon(Icons.person, 1),
            _buildTabIcon(Icons.search, 2),
          ],
        ),
        fit: StackFit.expand,
        icon: (width, height) => Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: null,
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: unselectedColor,
              size: width,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(500),
        duration: Duration(seconds: 1),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width * 0.8,
        barColor: colors[currentPage].computeLuminance() > 0.5
            ? Color(0xff01082D)
            : Colors.white,
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 35,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: [
            CustomerHomeScreen(), // Screen 1
            ProfileTap(), // Screen 2
            ServicesSearchPage(), // Screen 3
          ],
        ),
      ),
    );
  }

  // Helper method to build tabs with icons
  Widget _buildTabIcon(IconData icon, int index) {
    return SizedBox(
      height: 55,
      width: 40,
      child: Center(
        child: Icon(
          icon,
          color: currentPage == index ? colors[index] : unselectedColor,
        ),
      ),
    );
  }
}
