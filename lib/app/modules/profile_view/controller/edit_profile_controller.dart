import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/provider/userdata_provider.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/services/firebaseFunctions.dart';

class EditProfileController extends GetxController {
  TextEditingController profileName = TextEditingController();
  TextEditingController profileDOB = TextEditingController();
  RxString networkImageLink = "".obs;
  var pickedImage = Rx<File?>(null); // Observable to hold the picked image
  final ImagePicker picker = ImagePicker();
  Rx<DateTime> selectedDate = DateTime.now().obs;

  var selectedChoice = ''.obs;
  var selectedGender = ''.obs;
  final prefs = SharedPreferences.getInstance();

  void selectChoice(String choice) {
    selectedChoice.value = choice;
    selectedGender.value = choice;
  }

  final RxList<String> chipOptions = <String>[
    'Male',
    'Female',
    'non-binary',
  ].obs;

  // Rx<UserData?> userData = Rx<UserData?>(null);
  UserData? userData;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    developer.log("Edit Profile initializing..");
    if (Get.arguments != null && Get.arguments.isNotEmpty) {
      developer.log("Edit Profile initializing Argument exist");

      userData = Get.arguments[0] as UserData;
      assignUserData(userData!);
    } else {
      developer.log("Edit Profile initializing Argument does not exist");
    }
  }

  // Assign userData to variables and TextEditingControllers
  void assignUserData(UserData userData) {
    profileName.text = userData.name ?? '';

    print("UserName: ${profileName.text}");
    profileDOB.text = userData.dob ?? '';
    selectedGender.value = userData.gender.capitalizeFirst ?? userData.gender;
    selectedChoice.value = selectedChoice.value;
    developer.log("Selected Gender: ${selectedGender.value}");

    // Assuming profilePicUrl will be used to show the image, if available
    if (userData.profilePicUrl != null && userData.profilePicUrl!.isNotEmpty) {
      networkImageLink.value = userData.profilePicUrl ?? "";

      // pickedImage.value =
      //     File(userData.profilePicUrl!); // Adjust based on your use case
    } else {
      // networkImageLink.value =
      //     "https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcSAHmDSOdLA5YgFlEkMmgdweIf3jyGI0EGKqU5U7TpO70GFAY48v1N51eMRpY6mbG-VzfPvgObhOwB8lX4";
    }
    if (userData.dob != null && userData.dob!.isNotEmpty) {
      // Convert the dob string to DateTime and set it
      selectedDate.value = DateTime.tryParse(userData.dob!) ?? DateTime.now();
    }
  }

  @override
  void onClose() {
    profileName.dispose();
    profileDOB.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  // Method to pick image from the gallery
  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path); // Update the picked image
    } else {
      Get.snackbar("Error", "No image selected");
    }
  }

  // Method to pick image from the camera
  Future<void> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path); // Update the picked image
    } else {
      Get.snackbar("Error", "No image selected");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate; // Update the selected date
      profileDOB.text = pickedDate.toIso8601String(); // Update the text field
    }
  }

  Future<void> SaveData() async {
    EasyLoading.show(status: "Updating Profile..");
    if (pickedImage.value != null) {
      EasyLoading.show(status: "Uploading Profile Pic..");

      networkImageLink.value =
          await uploadProfilePic(pickedImage.value!) ?? networkImageLink.value;
    }
    EasyLoading.show(status: "Updating Profile data.");

    userData!.dob = profileDOB.text;
    userData!.gender = selectedGender.value;
    userData!.name = profileName.text;
    if (networkImageLink.value.isNotEmpty) {
      userData!.profilePicUrl = networkImageLink.value;
    }

    bool isUpdated =
        await FirestoreService().updateUserProfile(userData!.id, userData!);

    if (isUpdated) {
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Profile Updated Successfully");
      final userdataProvider =
          Provider.of<UserdataProvider>(Get.context!, listen: false);
      userdataProvider.setUserData = userData;
      Get.back();
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError("Failed to update user profile. Please try again");
      Get.snackbar("Error", "Failed to update user profile. Please try again.");
    }
  }

  Future<String?> uploadProfilePic(File fileToUpload) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final profilePicsRef =
          storageRef.child('profile_pics/${userData!.id}.jpg');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = profilePicsRef.putFile(fileToUpload);

      // Get the download URL after upload is complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      developer.log(" Uploaded Profile Url: $debugPrint");
      return downloadUrl;
    } catch (e) {
      print("Error uploading profile picture: $e");
      Get.snackbar(
          "Error", "Failed to upload profile picture. Please try again.");
      return null;
    }
  }
}
