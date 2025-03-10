import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/Auth/model/usermodel.dart';
import 'package:road_mate/backend/firebase_functions.dart';

class CheckUser extends ChangeNotifier {
  UserModel? userModel;
  User? firebaseUser;

  CheckUser() {
    firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      initUser();
    }
  }

  Future<void> initUser() async {
    userModel = await FirebaseFunctions.readUserData();
    notifyListeners();
  }
}
