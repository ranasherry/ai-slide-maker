import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import "dart:developer" as developer;
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
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide1.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide1_editor.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2_editor.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/slide_styles/title_slide1_editor.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';
import 'dart:core';

import '../modules/newslide_generator/views/helping_widget.dart/mymarkdown_widget.dart';

class ComFunction {
  static bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  static Future<void> GotoHomeScreen() async {
    // if (RCVariables.showCreations.value) {
    //   await Get.offAllNamed(Routes.NAVVIEW);
    // } else {
    //   await Get.offAllNamed(Routes.HOMEVIEW1);
    // }

    await Get.offAllNamed(Routes.HOMEVIEW1);

    // await Get.offAllNamed(Routes.HOMEVIEW1);
  }

  static Future<void> GotoHomeThenPresHome() async {
    await Get.offAllNamed(Routes.HOMEVIEW1, arguments: [true]);
    // await Get.offAllNamed(Routes.NAVVIEW, arguments: [true]);
  }

  static hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static SlidePallet getSlidePalletFromID(String id) {
    int index = palletList.indexWhere((s) => s.palletId == int.parse(id));
    if (index >= 0) {
      return palletList[index];
    } else {
      return palletList[0];
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
      developer.log(
          "This is slide pallet inside the createSlidyPresenatation ${slidePallet.slideTitlesTextProperties![0].fontWeight}");
      // developer.log("Page Data: ${page.ChapData}");
      if (i == 1) {
        await pres.addWidgetSlide(
          (size) => TitleSlide1Editor(
            mySlide: slide,
            slidePallet: slidePallet,
            size: size,
            index: i - 1,
            isEditViewOpen: false,
          ),
        );
      } else if (i == 2) {
        await pres.addWidgetSlide(
          (size) => SectionedSlide2Editor(
            mySlide: slide,
            slidePallet: slidePallet,
            size: size,
            index: i - 1,
            isEditViewOpen: false,
          ),
        );
      } else {
        await pres.addWidgetSlide(
          (size) => SectionedSlide1Editor(
            mySlide: slide,
            slidePallet: slidePallet,
            size: size,
            index: i - 1,
            isEditViewOpen: false,
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

  static void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Center(
            child: Text(
              "Stay Tuned!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 50,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 20),
              Text(
                "This feature is coming soon.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showSignInRequire(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Center(
            child: Text(
              "Signin Require!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 50,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 20),
              Text(
                "Please Sign in to use this feature.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Get.toNamed(Routes.SING_IN);
              },
              child: Text(
                "Sign in",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
