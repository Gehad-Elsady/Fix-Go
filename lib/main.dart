import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/signup-screen.dart';
import 'package:road_mate/OnBoarding/boarding-screen.dart';
import 'package:road_mate/SplashScreen/splash-screen.dart';
import 'package:road_mate/all-services-screen.dart';
import 'package:road_mate/cart-screen.dart';
import 'package:road_mate/contact-screen.dart';
import 'package:road_mate/firebase_options.dart';
import 'package:road_mate/home-screen.dart';
import 'package:road_mate/providers/check-user.dart';
import 'package:road_mate/providers/finish-onboarding.dart';
import 'package:road_mate/settings_tab.dart';
import 'package:road_mate/test.dart';
import 'package:road_mate/user-profile-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FinishOnboarding()),
    ChangeNotifierProvider(create: (_) => CheckUser()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        // RecycleUser.routeName: (context) => RecycleUser(),
        UserProfile.routeName: (context) => UserProfile(),
        AddServicePage.routeName: (context) => AddServicePage(),
        AllServicesScreen.routeName: (context) => AllServicesScreen(),
        CartScreen.routeName: (context) => CartScreen(),
        ContactScreen.routeName: (context) => ContactScreen(),
        SettingsTab.routeName: (context) => SettingsTab()
      },
    );
  }
}
