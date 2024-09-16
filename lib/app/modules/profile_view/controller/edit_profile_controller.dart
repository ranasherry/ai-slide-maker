import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileController extends GetxController {
  TextEditingController profileName = TextEditingController();
  TextEditingController profileDOB = TextEditingController();
  var pickedImage = Rx<File?>(null); // Observable to hold the picked image
  final ImagePicker picker = ImagePicker();
  Rx<DateTime> selectedDate = DateTime.now().obs;

  var selectedChoice = ''.obs;
  var SelectedGender = ''.obs;
  final prefs = SharedPreferences.getInstance();

  void selectChoice(String choice) {
    selectedChoice.value = choice;
  }

  final RxList<String> chipOptions = <String>[
    'Male',
    'Female',
    'non-binary',
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
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
    }
  }
}
