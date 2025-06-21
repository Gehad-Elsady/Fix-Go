// ignore_for_file: unused_local_variable

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:road_mate/Auth/auth_page.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/Auth/signup-screen.dart';
import 'package:road_mate/Auth/signup_provider_screen.dart';
import 'package:road_mate/backend/bloc/observer.dart';
import 'package:road_mate/notifications/notification.dart';
import 'package:road_mate/screens/Provider/engneers/add_eng.dart';
import 'package:road_mate/screens/Provider/home/provider_home.dart';
import 'package:road_mate/screens/Provider/home/taps/provider_home_tap.dart';
import 'package:road_mate/screens/Provider/settings/provider_srttings.dart';
import 'package:road_mate/screens/Provider/services/manege_services.dart';
import 'package:road_mate/screens/Provider/engneers/manegeeng.dart';
import 'package:road_mate/screens/Provider/engneers/update_eng.dart';
import 'package:road_mate/screens/Provider/services/update_services.dart';
import 'package:road_mate/screens/cars/cars_screen.dart';
import 'package:road_mate/screens/home/taps/Search/search_screen.dart';
import 'package:road_mate/screens/SplashScreen/OnBoarding/boarding-screen.dart';
import 'package:road_mate/screens/SplashScreen/splash-screen.dart';
import 'package:road_mate/screens/engineers/engineera_screen.dart';
import 'package:road_mate/screens/history/historyscreen.dart';
import 'package:road_mate/screens/home/taps/customer_home_screen.dart';
import 'package:road_mate/screens/services/all-services-screen.dart';
import 'package:road_mate/screens/cart/cart-screen.dart';
import 'package:road_mate/screens/contact/contact-screen.dart';
import 'package:road_mate/backend/firebase_options.dart';
import 'package:road_mate/screens/SplashScreen/provider/check-user.dart';
import 'package:road_mate/screens/SplashScreen/provider/finish-onboarding.dart';
import 'package:road_mate/screens/settings/settings_tab.dart';
import 'package:road_mate/screens/Provider/add-services/addservicescreen.dart';
import 'package:road_mate/screens/profile/user-profile-screen.dart';
import 'package:road_mate/screens/home/main_hame.dart';

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
    startLocale: Locale('ar'),
    fallbackLocale: Locale('ar'),
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
        ProviderHomeTap.routeName: (context) => ProviderHomeTap(),
        AddEng.routeName: (context) => AddEng(),
        ManegeServices.routeName: (context) => ManegeServices(),
        UpdateServices.routeName: (context) => UpdateServices(),
        Manegeeng.routeName: (context) => Manegeeng(),
        UpdateEng.routeName: (context) => UpdateEng(),
        EngineersScreen.routeName: (context) => EngineersScreen(),
        ProviderSettings.routeName: (context) => ProviderSettings(),
        MainHome.routeName: (context) => MainHome(),
        AuthPage.routeName: (context) => AuthPage(),
        SignupProvider.routeName: (context) => SignupProvider(),
        CustomerHomeScreen.routeName: (context) => CustomerHomeScreen(),
        ProviderHome.routeName: (context) => ProviderHome(),
        ServicesSearchPage.routeName: (context) => ServicesSearchPage(),
        CarsScreen.routeName: (context) => CarsScreen(),
      },
    );
  }
}
