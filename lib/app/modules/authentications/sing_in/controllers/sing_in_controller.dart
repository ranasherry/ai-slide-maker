import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/provider/userdata_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/auth_services.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/services/shared_pref_services.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:uuid/uuid.dart';

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

  signInWithGoogle() async {
    User? user = await AuthService().signInWithGoogle();
    if (user != null) {
      await onLoginSuccess(user);
    } else {
      //TODO: Could not Signed in Dialogue
    }
  }

  signInWithEmail() async {
    String email = emailCTL.text; // Replace with actual email value
    String password = passwordCTL.text; // Replace with actual password value
    log("Attempting Signin...");
    EasyLoading.show(status: "Please wait...");
    try {
      UserCredential userCredential = await authService
          .signInWithEmailAndPassword(email: email, password: password);
      log("Logged_in... ${userCredential.user!.email}");

      log('UserUUID: ${userCredential.user!.uid}');
      log('UserName: ${userCredential.user!.displayName}');

      await onLoginSuccess(userCredential.user!);
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Successfully Logined");

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
      EasyLoading.dismiss();
      EasyLoading.showError("Email or Password is wrong");
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
      // String? userUUID = SharedPrefService().getUUID();
      // String finalUID = "";

      // if (userUUID != null) {
      //   finalUID = userUUID;
      // } else {
      //   finalUID = Uuid().v4(); // Generate a new UUID
      //   await SharedPrefService().setUUID(finalUID);
      // }
      await SharedPrefService().setUUID(user.uid);

      // Check if User Already Exists
      final docRef = FirebaseFirestore.instance
          .collection(FirestoreService().userCollectionPath)
          .doc(user.uid);

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
        String userName = generateUniqueUserName("user");
        String? gender = await SharedPrefService().getGender();
        UserData userData = UserData(
            id: user.uid,
            name: user.displayName ?? userName,
            email: user.email ?? "",
            revenueCatUserId: revenueCatUserId,
            gender: gender ?? "",
            profilePicUrl: user.photoURL ?? "");
// user.photoURL;
        // final newUser = {
        //   'id': user.uid,
        //   'name': user.displayName,
        //   'email': user.email,
        //   'revenueCatUserId': "revenueCatUserId",
        // };

        await docRef.set(userData.toMap());
        final userdataProvider =
            Provider.of<UserdataProvider>(Get.context!, listen: false);
        userdataProvider.setUserData = userData;

        print('New user created!');
      }

      // Navigate to HomeScreen
      ComFunction.GotoHomeScreen();
      // Get.offAndToNamed(Routes.HOMEVIEW1);
    } catch (e) {
      // Handle any errors here
      print('Error during login process: $e');
    }
  }

  String generateUniqueUserName(String baseName) {
    // Generate a random number between 0 and 9999999 (7 digits max)
    int randomNumber = math.Random().nextInt(9999999);

    // Format the number with leading zeros to ensure it's 7 digits long
    String formattedNumber = randomNumber.toString().padLeft(7, '0');

    // Concatenate the base name with the formatted number
    return '$baseName$formattedNumber';
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
