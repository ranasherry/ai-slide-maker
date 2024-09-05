import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/utills/remoteConfigVariables.dart';

class NewslideGeneratorController extends GetxController {
  //TODO: Implement NewslideGeneratorController

  //? Bool Variables
  RxBool outlineTitleFetched = false.obs;
  RxBool showInside = false.obs;

  RxBool isWaitingForTime = false.obs;

//? String Variables
  RxString userInput = "".obs;
  RxString timerValue = "".obs;

//? Animation Controller Values
  RxDouble create_box_width = 0.0.obs;
  RxDouble create_box_height = 0.0.obs;
  RxDouble input_box_width = 0.0.obs;
  RxDouble input_box_height = 0.0.obs;

  int tokensConsumed = 0;

  //? TextEditing Controller
  TextEditingController inputTextCTL = TextEditingController();

  //?Lists

  RxList<String> outlineTitles = <String>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    show_input_field();

    Future.delayed(Duration(seconds: 1), () {
      show_create_button();
    });

    initializeTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  show_input_field() {
    Future.delayed(Duration(milliseconds: 500), () {
      // input_box_width.value = SizeConfig.screenWidth *0.8;
      input_box_width.value = 300;
      // input_box_height.value = SizeConfig.screenHeight *0.2;
      input_box_height.value = 180;
    }).then((value) {
      Future.delayed(Duration(seconds: 1), () {
        showInside.value = true;
      });
    });
  }

  hide_input_field() {
    showInside.value = false;

    Future.delayed(Duration(seconds: 1), () {
      // input_box_width.value = SizeConfig.screenWidth *0.8;
      input_box_width.value = 300;
      // input_box_height.value = SizeConfig.screenHeight *0.2;
      input_box_height.value = 180;
    });
  }

  show_create_button() {
    create_box_width.value = 140;
    // create_box_height.value = SizeConfig.screenHeight *0.05;
    create_box_height.value = 55;
  }

  void validate_user_input() async {
    if (userInput.isNotEmpty) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        EasyLoading.show(status: "Generating Outlines..");
        generateOutlines(userInput.value);
      } else {
        Toster("No internet Connection", AppColors.Lime_Green_color);
        print("Internet OFF");
        EasyLoading.dismiss();
      }
    } else {
      Toster("Please write somthing!", AppColors.Lime_Green_color);
      EasyLoading.dismiss();
    }
  }

  void showWatchRewardPrompt() {
    // EasyLoading.showError("Wait for the time");
    showWatchAdDialog(
      onWatchAd: () {
        // Implement logic to handle "Watch Ad" button click
        print("Watch Ad clicked");
        AppLovinProvider.instance.showRewardedAd(setRewardUnlock);
      },
      onCancel: () {
        // Implement logic to handle "Cancel" button click
        print("Cancel clicked");
      },
      timerText: timerValue,
    );
  }

  Future<void> setRewardUnlock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set the last generation time to 10 minutes before the current time
    DateTime lastGenerationTime =
        DateTime.now().subtract(Duration(minutes: 20));

    prefs.setString('lastGenerationTime', lastGenerationTime.toIso8601String());
    // initializeTimer();
  }

  hide_outlines() {
    showInside.value = false;
    Future.delayed(Duration(seconds: 1), () {
      input_box_width.value = 0;
      input_box_height.value = 0;
    }).then((value) {
      hide_buttons().then((value) {
        Future.delayed(Duration(seconds: 1), () {
          MoveToSlidesScreeen();
        });
      });
    });
  }

  Future hide_buttons() async {
    create_box_height.value = 0;
    create_box_width.value = 0;
  }

  increaseOutputHeight() {
    input_box_width.value = 300;
    // input_box_height.value = SizeConfig.screenHeight *0.5;
    input_box_height.value = 450;
    Future.delayed(Duration(seconds: 1), () {
      // show_create_button();
      outlineTitleFetched.value = true;
      show_create_button();
    });
    // if (NoOfSlides == 1) {
    //   outlineTitleFetched.value = true;
    //   NeverShowOutlines();
    // } else {
    //   // input_box_width.value = SizeConfig.screenWidth *0.8;
    //   input_box_width.value = 300;
    //   // input_box_height.value = SizeConfig.screenHeight *0.5;
    //   input_box_height.value = 450;
    //   Future.delayed(Duration(seconds: 1), () {
    //     // show_create_button();
    //     outlineTitleFetched.value = true;
    //   })

    //   ;
    // }
  }

  void MoveToSlidesScreeen() async {
    Get.toNamed(Routes.SlideDetailedGeneratedView,
            arguments: [userInput.value, outlineTitles])!
        .then((value) {
      AppLovinProvider.instance.showInterstitial(() {});
      Get.back();
    });
  }

  Toster(msg, color) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: AppColors.white_color,
        fontSize: 16.0);
  }

  void generateOutlines(String inputTopic) async {
    // String apiRequest =
    //     '''Generate the Outlines for the Book with the following detailes.
    // Book Title: ${inputTopic}
    // Subtitle: ${inputTopic}
    // Style: Descriptive

    // Note: The Outlines must be comma seperated only chapter names without numbering and must contains only 5 chapters.
    // ''';

    String apiRequest =
        ''' Generate the Main Titles for the presentation slide on the Topic $inputTopic
    For Example For the Topic AI Following will be Your response for the titles:
    Intro of AI , How AI Works , IS AI safe to Use , AI Advantages , AI Disadvantages , Conclusion

    You must follow the given example response annd write the titles in comma seperated values. Note Each Title should not be more then 3 words and you only need to provide six titles
     ''';
    String? rawResponse = await gemeniAPICall(apiRequest);

    if (rawResponse != null) {
      outlineTitles.value = parseStringToList(rawResponse);
      if (outlineTitles.length > 0) {
        EasyLoading.dismiss();
        increaseOutputHeight();
      }

      developer.log("List of OutLines: $outlineTitles ");
      developer.log("List of OutLines Lenght: ${outlineTitles.length} ");
    } else {
      EasyLoading.dismiss();
      Toster("Currently We are out of limit. Please Try again later",
          AppColors.Lime_Green_color);
      // Get.back();
    }
  }

  List<String> parseStringToList(String text) {
    final parsedList = text.split(',');
    return parsedList;
  }

  int geminiRequestCounter = 0;
  Future<String?> gemeniAPICall(String request) async {
    developer.log("RequestCounter: $geminiRequestCounter");
    final apiKey = RCVariables.geminiAPIKeys[geminiRequestCounter];
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          maxOutputTokens: 200,
          // responseMimeType: "application/json",
        ));

    final content = [Content.text(request)];
    try {
      final response = await model.generateContent(content);

      if (response.text != null) {
        if (response.usageMetadata != null) {
          developer
              .log("Tokens Count: ${response.usageMetadata!.totalTokenCount}");
          tokensConsumed += response.usageMetadata!.totalTokenCount ?? 0;
        }
        String? generatedMessage = response.text;
        geminiRequestCounter = 0;

        developer.log("Gemini Response: $generatedMessage");
        return generatedMessage;
      } else {
        if (geminiRequestCounter >= RCVariables.geminiAPIKeys.length - 1) {
          geminiRequestCounter = 0;

          return null;
        } else {
          geminiRequestCounter++;
          String? generatedMessage = await gemeniAPICall(request);
          return generatedMessage;
        }
      }
    } catch (e) {
      if (kDebugMode) developer.log('Gemini Error $e key: $apiKey  ', error: e);
      // return "Could not generate due to some techniqal issue. please try again after a few minutes ";
      if (geminiRequestCounter >= RCVariables.geminiAPIKeys.length - 1) {
        geminiRequestCounter = 0;

        return null;
      } else {
        geminiRequestCounter++;
        String? generatedMessage = await gemeniAPICall(request);
        return generatedMessage;
      }

      // generatedMessage = "Error Message $e";
    }
  }

  Future<void> initializeTimer() async {
    try {
      // Load last generation time from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // DateTime? lastGenerationTime =
      //     prefs.getString('lastGenerationTime') != null
      //         ? DateTime.parse(prefs.getString('lastGenerationTime')!)
      //         : null;

      // Start a timer to update the variable periodically
      Timer.periodic(Duration(seconds: 1), (timer) async {
        try {
          DateTime? lastGenerationTime =
              prefs.getString('lastGenerationTime') != null
                  ? DateTime.parse(prefs.getString('lastGenerationTime')!)
                  : null;
          if (lastGenerationTime != null) {
            // Calculate the difference between last generation time and current time
            Duration difference = DateTime.now().difference(lastGenerationTime);

            // Calculate the remaining time as a countdown
            Duration countdown =
                Duration(minutes: RCVariables.delayMinutes) - difference;
            countdown = Duration(
                seconds: countdown.inSeconds < 0 ? 0 : countdown.inSeconds);

            // Update the RxString with the formatted time difference

            // If the countdown reaches zero, stop the timer
            if (countdown.inSeconds <= 0) {
              // timer.cancel();
              timerValue.value = formatDuration(countdown);

              isWaitingForTime.value = false;
            } else {
              timerValue.value = formatDuration(countdown);

              isWaitingForTime.value = true;
            }

            // print("Last Generation: $lastGenerationTime");
            // print("Difference: $difference");
            // print("Timer: ${timerValue.value} ");
          } else {
            // Handle the case when lastGenerationTime is null
            isWaitingForTime.value = false;
            print("No lastGenerationTime available.");
          }
        } catch (e) {
          print("Error in timer execution: $e");
          // Handle the error gracefully without stopping the timer
        }
      });
    } catch (e) {
      print("Error in initializeTimer: $e");
    }
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> setNewTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastGenerationTime', DateTime.now().toIso8601String());
    // initializeTimer();
  }
}
