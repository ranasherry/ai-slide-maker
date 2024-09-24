import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pptx/flutter_pptx.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_home_controller.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

class PresentationOpenCtl extends GetxController {
  // PresentationHomeController presHomeCtl = Get.find();

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;

  RxString presentationTitle = "".obs;
  RxInt currentSelectedIndex = 0.obs;
  Rx<SlidePallet> slidePallet = SlidePallet(
          palletId: 9, // Updated to ensure uniqueness
          name: "marshmallow",
          slideCategory: "Light",
          bigTitleTColor: Colors.black.value,
          normalTitleTColor: Colors.black.value,
          sectionHeaderTColor: Colors.black.value,
          normalDescTColor: Colors.black.value,
          sectionDescTextColor: Colors.black.value,
          imageList: AppImages.slidy_style9,
          fadeColor: const Color.fromARGB(64, 187, 222, 251),
          isPaid: true)
      .obs;

  Rx<MyPresentation> myPresentation = MyPresentation(
          presentationId: 0,
          presentationTitle: "",
          slides: <MySlide>[].obs,
          createrId: null,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          styleId: '1'.obs,
          likesCount: 0,
          commentsCount: 0,
          isLiked: false)
      .obs;

  RxBool isOtherUser = false.obs;

  @override
  void onInit() async {
    super.onInit();
    MyPresentation pres = Get.arguments[0] as MyPresentation;
    SlidePallet slidePalletGet = Get.arguments[1] as SlidePallet;
    slidePallet.value = slidePalletGet;
    presentationTitle.value = pres.presentationTitle;
    myPresentation.value = pres;

    if (Get.arguments.length > 1) {
      isOtherUser.value = Get.arguments[1] as bool;
    }

    developer.log("Opened Slide: ${pres.toMap()}");
    developer.log("IsOtherUser: ${isOtherUser.value}");
  }

  @override
  void onClose() {
    super.onClose();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  Future<void> createPresentation() async {
    EasyLoading.show(status: "Generating PPTX File");
    try {
      final pres = await ComFunction().createSlidyPresentation(
          mySlides: myPresentation.value.slides,
          Title: myPresentation.value.presentationTitle,
          slidePallet:
              getSlidePalletFromID(myPresentation.value.styleId.value));

      await ComFunction().downloadPresentation(pres);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Could not Generate Slide");
      // TODO
    }
  }

  SlidePallet getSlidePalletFromID(String id) {
    int index = palletList.indexWhere((s) => s.palletId == int.parse(id));
    if (index >= 0) {
      return palletList[index];
    } else {
      return palletList[0];
    }
  }

  void deleteSlide(int index) {
    if (index >= 0 && index < myPresentation.value.slides.length) {
      myPresentation.value.slides.removeAt(index);
    } else {
      print("Index out of range");
    }
  }

  void changePallet() {
    int currentIndex = palletList.indexWhere((pallet) =>
        pallet.palletId == int.parse(myPresentation.value.styleId.value));

    int nextIndex = (currentIndex + 1) % palletList.length;
    SlidePallet nextPallet = palletList[nextIndex];

    myPresentation.value.styleId.value = nextPallet.palletId.toString();

    developer.log("PalletID: ${myPresentation.value.styleId}");
    // myPresentation.value.pallet = nextPallet;
  }
}
