import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/slideResponce.dart';
import 'package:slide_maker/app/data/slide_history.dart';
import 'package:slide_maker/app/data/slides_history_dbhandler.dart';
import 'package:slide_maker/app/utills/CM.dart';

class HistorySlideCTL extends GetxController {
  SlideItem? slidesHistory;
  RxList<BookPageModel> bookPages = <BookPageModel>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    slidesHistory =
        Get.arguments[0] as SlideItem?; // Get argument and cast as nullable

    // Handle null case:
    if (slidesHistory == null) {
      // Example: Show an error message or navigate back
      Get.snackbar('Error', 'Slide history not found in arguments.');
      Get.back();
    } else {
      // Process slidesHistory
      bookPages
          .assignAll(slidesHistory!.listOfPages); // Access slidesList safely
      log("Slide Saved Page Lenght: ${bookPages.length}");

      for (var element in slidesHistory!.listOfPages) {
        log("Slide Saved Page: ${element.ChapData}");
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  sharePPTX() async {
    await generatePPTXFile();
  }

  Future<void> generatePPTXFile() async {
    EasyLoading.show(status: "Generating PPTX File");
    try {
      final pres = await ComFunction().createPresentation(
          bookPages: bookPages, Title: slidesHistory!.slideTitle);

      await ComFunction().downloadPresentation(pres);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Could not Generate Slide");
      // TODO
    }
  }
}
