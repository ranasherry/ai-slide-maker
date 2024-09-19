import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/services/firebaseFunctions.dart';

class UserdataProvider extends ChangeNotifier {
  UserData? userData;
  bool isLoggedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for userData
  UserData? get getUserData => userData;

  // Setter for userData
  set setUserData(UserData? value) {
    userData = value;
    if (userData != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    notifyListeners(); // Notify listeners when userData changes
  }

  // Getter for isLoggedIn
  bool get getIsLoggedIn => isLoggedIn;
  UserdataProvider() {
    developer.log("User Provider initialized..");
    getSignedInInfo();
  }
  // Setter for isLoggedIn
  set setIsLoggedIn(bool value) {
    isLoggedIn = value;
    notifyListeners(); // Notify listeners when isLoggedIn changes
  }

  Future<void> getSignedInInfo() async {
    if (_auth.currentUser != null) {
      developer.log("User is Logged In");
      userData = await FirestoreService().getUserByID(_auth.currentUser!.uid);
      if (userData != null) {
        developer.log("Signed in User: ${userData!.toMap()}");
      } else {
        developer.log("User with UserID: ${_auth.currentUser!.uid}");
      }
    }
  }
}
