import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';

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

      onLoginSuccess(userCredential.user!);

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

  // onLoginSuccess(User user) {
  //   //TODO: Check if User Already exist
  //   //?  if Exist then initialize Revenuecat>> check Revenue Cat Subscription and if user paid then  unlock Premium >> Navigate to HomeScreen

  //   //TODO: Check if User Already exist
  //   //?  if Does not Exist then
  //   //? initialize revenuecat >> get Revenucat User ID >> create new User with user details Along with Revenuecat user ID, navigate to HomeScreen

  //   Get.offAndToNamed(Routes.HomeView);
  // }

  Future<void> onLoginSuccess(User user) async {
    try {
      // Check if User Already Exists
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // User exists, handle existing user data
        final userMap = docSnapshot.data() as Map<String, dynamic>;
        UserData userData = UserData.fromMap(userMap);
        // Perform actions with existing user data (e.g., print name)
        print('User found: ${userData.email}');

        RevenueCatService().initialize(userData.revenueCatUserId);
      } else {
        // User doesn't exist, create a new user
        final revenueCatUserId = await RevenueCatService().initialize(null);

        UserData userData = UserData(
            id: user.uid,
            name: user.displayName ?? "",
            email: user.email ?? "",
            revenueCatUserId: revenueCatUserId);

        // final newUser = {
        //   'id': user.uid,
        //   'name': user.displayName,
        //   'email': user.email,
        //   'revenueCatUserId': "revenueCatUserId",
        // };

        await docRef.set(userData.toMap());
        print('New user created!');
      }

      // Navigate to HomeScreen
      Get.offAndToNamed(Routes.HomeView);
    } catch (e) {
      // Handle any errors here
      print('Error during login process: $e');
    }
  }

  Future<void> createNewUser(User user, String revenueCatUserId) async {
    // Implement your logic to create a new user in your database
    // Example:
    // await database.createUser({
    //   'id': user.id,
    //   'name': user.name,
    //   'email': user.email,
    //   'revenueCatUserId': revenueCatUserId,
    // });
  }
}
