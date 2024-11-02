import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/signup-screen.dart';
import 'package:road_mate/screens/SplashScreen/OnBoarding/boarding-screen.dart';
import 'package:road_mate/screens/SplashScreen/splash-screen.dart';
import 'package:road_mate/screens/services/all-services-screen.dart';
import 'package:road_mate/screens/cart/cart-screen.dart';
import 'package:road_mate/screens/contact/contact-screen.dart';
import 'package:road_mate/backend/firebase_options.dart';
import 'package:road_mate/screens/home/home-screen.dart';
import 'package:road_mate/screens/SplashScreen/provider/check-user.dart';
import 'package:road_mate/screens/SplashScreen/provider/finish-onboarding.dart';
import 'package:road_mate/screens/settings/settings_tab.dart';
import 'package:road_mate/screens/add-services/addservicescreen.dart';
import 'package:road_mate/screens/profile/user-profile-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en'),
      Locale('ar'),
    ],
    path: 'assets/translation',
    saveLocale: true,
    startLocale: Locale("ar"),
    child: MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => FinishOnboarding()),
      ChangeNotifierProvider(create: (_) => CheckUser()),
    ], child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
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
