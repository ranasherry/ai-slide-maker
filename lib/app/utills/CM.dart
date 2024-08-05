import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pptx/flutter_pptx.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/helping_enums.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide1.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/utills/images.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'dart:core';

import '../modules/newslide_generator/views/helping_widget.dart/mymarkdown_widget.dart';

class ComFunction {
  static bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  static hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static showExitDialog({
    required String title,
    required String msg,
  }) {
    Get.defaultDialog(
        title: title,
        middleText: msg,
        textConfirm: "Yes",
        textCancel: "No",
        onCancel: () {
          // Get.back();
        },
        onConfirm: () {
          SystemNavigator.pop();
        },
        titleStyle: TextStyle(color: Colors.blue),
        confirmTextColor: Colors.white);
  }

  static showInfoDialog({
    required String title,
    required String msg,
  }) {
    Get.defaultDialog(
        title: title,
        middleText: msg,
        radius: 10,
        textConfirm: "OK",
        onConfirm: () {
          Get.back();
        },
        titleStyle: TextStyle(color: Colors.blue),
        confirmTextColor: Colors.white);
  }

  // static showToast(String message) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: AppColor.primaryBlue,
  //       textColor: AppColor.white,
  //       fontSize: 16.0);
  // }

  static showProgressLoader(String msg) {
    EasyLoading.show(status: msg);
  }

  static hideProgressLoader() {
    EasyLoading.dismiss();
  }

  static void initializeLoader() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 60
      ..radius = 20
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.blue
      ..textColor = Colors.white
      ..userInteractions = true
      ..dismissOnTap = false
      ..indicatorType = EasyLoadingIndicatorType.circle;
  }

  static void showErrorDialog({
    required String title,
    required String errorMessage,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: errorMessage,
      textConfirm: "OK",
      confirmTextColor: Colors.red,
      onConfirm: () => Get.back(),
    );
  }

  bool containsTable(String markdownString) {
    // Regex pattern to match table separators
    final tableSeparatorPattern = r"^\s*\|(.+?)\|\s*$";

    // Split the string into lines using split method
    final lines = markdownString.split("\n");

    // Check if any line starts with "|" and ends with "|"
    for (final line in lines) {
      if (RegExp(tableSeparatorPattern).hasMatch(line)) {
        return true;
      }
    }
    return false;
  }

  //? Save PPTX File Methods
  Future<FlutterPowerPoint> createPresentation(
      {required List<BookPageModel> bookPages, required String Title}) async {
    final pres = FlutterPowerPoint();

//? Title Slide
    await pres.addWidgetSlide(
      (size) => MyMarkDownWidget(
        page: BookPageModel(
            ChapName: Title,
            ChapData: "",
            imageType: SlideImageType.svg,
            ImagePath: AppImages.Theme2_horizontal[0],
            containsImage: true),
        size: size,
        isTitle: true,
      ),
    );

    int i = 1;
    for (final BookPageModel page in bookPages) {
      // developer.log("Page Data: ${page.ChapData}");
      await pres.addWidgetSlide(
        (size) => MyMarkDownWidget(
          page: page,
          size: size,
          isTitle: false,
        ),
      );

      double value = (i / bookPages.length);
      EasyLoading.showProgress(value, status: "Generating PPTX");
      i++;
    }

    pres.showSlideNumbers = true;

    return pres;
  }

  Future<FlutterPowerPoint> createSlidyPresentation(
      {required List<MySlide> mySlides,
      required String Title,
      required SlidePallet slidePallet}) async {
    final pres = FlutterPowerPoint();

//? Title Slide
    // await pres.addWidgetSlide(
    //   (size) => MyMarkDownWidget(
    //     page: BookPageModel(
    //         ChapName: Title,
    //         ChapData: "",
    //         imageType: SlideImageType.svg,
    //         ImagePath: AppImages.Theme2_horizontal[0],
    //         containsImage: true),
    //     size: size,
    //     isTitle: true,
    //   ),
    // );

    int i = 1;
    for (final MySlide slide in mySlides) {
      // developer.log("Page Data: ${page.ChapData}");
      if (i == 0) {
        await pres.addWidgetSlide(
          (size) => TitleSlide1(
            mySlide: slide,
            slidePallet: slidePallet,
            size: size,
          ),
        );
      } else if (i == 1) {
        await pres.addWidgetSlide(
          (size) => SectionedSlide2(
            mySlide: slide,
            slidePallet: slidePallet,
            size: size,
          ),
        );
      } else {
        await pres.addWidgetSlide(
          (size) => SectionedSlide1(
            mySlide: slide,
            slidePallet: slidePallet,
            size: size,
          ),
        );
      }

      double value = (i / mySlides.length);
      EasyLoading.showProgress(value, status: "Generating PPTX");
      i++;
    }

    pres.showSlideNumbers = true;

    return pres;
  }

  Future<void> downloadPresentation(FlutterPowerPoint pres) async {
    final bytes = await pres.save();
    if (bytes == null) {
      EasyLoading.dismiss();
      return;
    }
    downloadFile('presentation.pptx', bytes);
  }

  Future<void> downloadFile(String filename, Uint8List bytes) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Get the temporary directory for safe file creation

      // Create a new file with the specified filename
      final file = File('$tempPath/$filename');

      // Write the bytes to the file
      await file.writeAsBytes(bytes);

      // Share the downloaded file using ShareXFile
      final xFile = XFile(file.path);
      ShareResult result = await Share.shareXFiles([xFile]);
      if (result.status == ShareResultStatus.success) {
        EasyLoading.dismiss();
        AppLovinProvider.instance.showInterstitial(() {});
      } else {
        EasyLoading.dismiss();
      }

      print('File downloaded successfully: ${file.path}');
    } on FileSystemException catch (e) {
      // Handle file system errors (e.g., insufficient storage)
      print('Error downloading file: $e');
      EasyLoading.dismiss();
    } catch (e) {
      // Handle other unexpected errors
      print('Unexpected error: $e');
      EasyLoading.dismiss();
    }
  }
}
