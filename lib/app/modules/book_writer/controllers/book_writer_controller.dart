import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookWriterController extends GetxController {
  //TODO: Implement BookWriterController

  final count = 0.obs;
  var titleController = TextEditingController();
  var topicController = TextEditingController();
  var languageController = TextEditingController();
  var authorController = TextEditingController();
  var pagesController = TextEditingController();
  var descriptionController = TextEditingController();
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
}
