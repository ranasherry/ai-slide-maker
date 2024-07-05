import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  //TODO: Implement SingInController

  TextEditingController emailCTL = TextEditingController();
  TextEditingController passwordCTL = TextEditingController();

  final FirebaseAuth authService = FirebaseAuth.instance;

  RxBool showPwd = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  signInWithGoogle() {}

  signInWithEmail() async {
    String email = emailCTL.text; // Replace with actual email value
    String password = passwordCTL.text; // Replace with actual password value
    log("Attempting Signin...");
    try {
      UserCredential userCredential = await authService
          .signInWithEmailAndPassword(email: email, password: password);
      log("Logged_in... ${userCredential.user!.email}");

      log('UserUUID: ${userCredential.user!.uid}');
      log('UserName: ${userCredential.user!.displayName}');
      // return true;
      // Handle successful sign-in (e.g., navigate to a home page)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that email.');
      } else {
        print(e.code); // Print other error codes
      }
      // Handle errors appropriately (e.g., show a snackbar)
      // return false;
    }
  }
}
