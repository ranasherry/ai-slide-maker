import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

class SingUpController extends GetxController {
  //TODO: Implement SingUpController

  final count = 0.obs;

  TextEditingController emailCTL = TextEditingController();
  TextEditingController passwordCTL = TextEditingController();

  final FirebaseAuth authService = FirebaseAuth.instance;
  RxBool showPwd = false.obs;
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

  Future<void> signUpWithEmail() async {
    EasyLoading.show(status: "Please Wait...");
    String email = emailCTL.text; // Replace with actual email value
    String password = passwordCTL.text; // Replace with actual password value
    log("Attempting Create Account...");

    try {
      UserCredential userCredential = await authService
          .createUserWithEmailAndPassword(email: email, password: password);
      log('UserUUID: ${userCredential.user!.uid}');
      log('UserName: ${userCredential.user!.displayName}');
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Signed up Successfully");
      Get.offAllNamed(Routes.SING_IN);

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

      EasyLoading.showError("Could not Signup.");
      // Handle errors appropriately (e.g., show a snackbar)
      // return false;
    }
  }
}
