// ignore_for_file: unused_local_variable

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/signup-screen.dart';
import 'package:road_mate/backend/bloc/observer.dart';
import 'package:road_mate/notifications/notification.dart';
import 'package:road_mate/screens/Admin/add_eng.dart';
import 'package:road_mate/screens/Admin/admin_home.dart';
import 'package:road_mate/screens/Admin/admin_srttings.dart';
import 'package:road_mate/screens/Admin/manege_services.dart';
import 'package:road_mate/screens/Admin/manegeeng.dart';
import 'package:road_mate/screens/Admin/update_eng.dart';
import 'package:road_mate/screens/Admin/update_services.dart';
import 'package:road_mate/screens/SplashScreen/OnBoarding/boarding-screen.dart';
import 'package:road_mate/screens/SplashScreen/splash-screen.dart';
import 'package:road_mate/screens/engineers/engineera_screen.dart';
import 'package:road_mate/screens/history/historyscreen.dart';
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
import 'package:road_mate/screens/user%20home/main_hame.dart';
import 'package:road_mate/screens/user%20home/user_home.dart';

bool isConnectdet = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  // Initialize EasyLocalization with error handling
  try {
    await EasyLocalization.ensureInitialized();
  } catch (e) {
    print('Error initializing EasyLocalization: $e');
  }

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  // Optionally, initialize Firebase Analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // Initialize Firebase Messaging with error handling
  MyNotification.initialize();

  final connectionChecker = InternetConnectionChecker();
  final subscription = connectionChecker.onStatusChange.listen(
    (InternetConnectionStatus status) {
      if (status == InternetConnectionStatus.connected) {
        print('Data connection is available.');
        isConnectdet = true;
      } else {
        print('You\'re disconnected from the internet.');
        isConnectdet = false;
      }
    },
  );
  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en'),
      Locale('ar'),
    ],
    path: 'assets/translation',
    saveLocale: true,
    startLocale: Locale("en"),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FinishOnboarding()),
        ChangeNotifierProvider(create: (_) => CheckUser()),
      ],
      child: const MyApp(),
    ),
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
        SettingsTab.routeName: (context) => SettingsTab(),
        HistoryScreen.routeName: (context) => HistoryScreen(),
        AdminHome.routeName: (context) => AdminHome(),
        AddEng.routeName: (context) => AddEng(),
        ManegeServices.routeName: (context) => ManegeServices(),
        UpdateServices.routeName: (context) => UpdateServices(),
        Manegeeng.routeName: (context) => Manegeeng(),
        UpdateEng.routeName: (context) => UpdateEng(),
        EngineersScreen.routeName: (context) => EngineersScreen(),
        AdminSettingsTab.routeName: (context) => AdminSettingsTab(),
        UserHome.routeName: (context) => UserHome(),
        MainHame.routeName: (context) => MainHame(),
      },
    );
  }
}
