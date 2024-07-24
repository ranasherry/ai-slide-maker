import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/title_input_fragment.dart.dart';

class PresentaionGeneratorController extends GetxController {
  //TODO: Implement PresentaionGeneratorController

  final count = 0.obs;
  RxInt currentIndex = 0.obs;

  List<Widget> mainFragments = [titleInputFragment()];
  RxInt noOfSlide = 6.obs;
  String toneOfVoice = "";

  TextEditingController titleTextCTL = TextEditingController();

  Rx<TextAmount> textAmount = TextAmount.Brief.obs;

  RxList<String> plannedOutlines = <String>[].obs;

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

enum TextAmount { Brief, Medium, Detailed }
