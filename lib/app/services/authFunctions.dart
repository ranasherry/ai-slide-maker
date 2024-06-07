import 'dart:developer';

// import 'package:ai_chatbot/app/services/firebaseFunctions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/data/authType.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../data/authType.dart';
// import '../modules/routes/app_pages.dart';
// import 'package:flutterapp/services/functions/firebaseFunctions.dart';

class AuthServices {
//   static saveGoogleUserData(name,email) async {
//   // Get the current user from Firebase Auth
//   User? user = FirebaseAuth.instance.currentUser;

//   // Create a reference to the users collection
//   CollectionReference users = FirebaseFirestore.instance.collection('GoogleUsers');

//   // Create a map of data to store
//   Map<String, dynamic> userData = {
//     'name': name,
//     'email': email
//   };

//   // Add the data to the collection with the user's uid as the document id
//   await users.doc(user!.uid).set(userData);

//   // Print a confirmation message
//   print('User data saved successfully');
//   log("done");
// }
}
