import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_pptx/flutter_pptx.dart';
import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/modules/book_writer/controllers/book_generated_ctl.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:slide_maker/app/notificationservice/local_notification_service.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/main.dart';
import 'package:slide_rating_dialog/slide_rating_dialog.dart';
import 'package:in_app_review/in_app_review.dart';

class HomeViewCtl extends GetxController with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  // TextEditingController feedback = TextEditingController();

  Rx<String> feedbackMessage = "".obs;
  String recipient = "codewithsherry@gmail.com";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    // GetRemoteConfig().then((value) {
    //   SetRemoteConfig();

    //   remoteConfig.onConfigUpdated.listen((event) async {
    //     print("Remote Updated");
    //     //  await remoteConfig.activate();
    //     SetRemoteConfig();

    //     // Use the new config values here.
    //   });
    // });

    print('2 Fetched open: ${AppStrings.OPENAI_TOKEN}');

    if (Platform.isAndroid) handlePushNotification();

    startInAppPurchaseTimer();
    // if(kIsDe)
    // ShowFeedbackBottomSheet();
  }

  checkPermission(String page) async {
    // EasyLoading.show(status: "Checking Permission..");
    // Get.offNamed(Routes.PDF_PERMISSION, arguments: page);
    Get.toNamed(page);

    // PermissionStatus status = await Permission.manageExternalStorage.status;
    // if (status == PermissionStatus.granted) {
    //   print("Storage Granted");
    //   Future.delayed(Duration(seconds: 3), () {
    //     EasyLoading.dismiss();
    //     // Get.offNamed(Routes.HomeView);
    //     Get.toNamed(page);
    //   });
    // } else {
    //   print("Storage Not Granted");
    //   Future.delayed(Duration(seconds: 3), () {
    //     EasyLoading.dismiss();

    //     Get.offNamed(Routes.PDF_PERMISSION, arguments: page);
    //   });
    // }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> sendFeedBackEmail(String message) async {
    final Email email = Email(
      recipients: [recipient],
      subject: "AI Slide Feedback",
      body: message,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      feedBackCount = 2;
      // showReviewDialogue(Get.context!);
    } catch (error) {
      // showReviewDialogue(Get.context!);

      platformResponse = error.toString();
    }

    try {
      sendFirebaseFeedback(message);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    // Get.snackbar('Email Sender', platformResponse);
  }

  Future<void> sendFirebaseFeedback(message) async {
    // Firestore storage
    final feedbackCollection =
        FirebaseFirestore.instance.collection('feedback');
    final docID =
        "${DateTime.now().millisecondsSinceEpoch}}_${FirestoreService().UserID}";

    final feedbackDocRef = await feedbackCollection.doc(docID);
    feedbackDocRef.set({
      'message': message,
      'timestamp':
          FieldValue.serverTimestamp(), // Automatically generated timestamp
    });

    // Handle success or error
    if (feedbackDocRef.id != null) {
      print('Feedback submitted successfully!');
    } else {
      print('Error submitting feedback.');
    }
  }

  // void removeAttachment(int index) {
  //   attachments.removeAt(index);
  // }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("State Changed: $state");
    switch (state) {
      case AppLifecycleState.resumed:
        await AppLovinProvider.instance.showAppOpenIfReady();
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  // ShareApp() {
  //   Share.share(
  //       "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=com.genius.aislides.generator.");
  // }

  // Future openURL(ur) async {
  //   final Uri _url = Uri.parse(ur);
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }

  final remoteConfig = FirebaseRemoteConfig.instance;

  Future GetRemoteConfig() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ));

      await remoteConfig.setDefaults(const {
        // "example_param_1": 42,
        // "example_param_2": 3.14159,
        // "example_param_3": true,
        "OpenAiToken": "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",
        "HotpotApi": "k6sv13mQAF9U2Eq2HRFFuNOj0vDZYqtx3UVIBB6cSOPxrm1TUT",
        "GeminiProKey": "GeminiProKey",
        // "GoogleShoppingAPI": "886ff05605mshbebba3b2ff469aap1fb826jsn0b627542f3e9",
        "isHotpotActive": false,
        // "activeBardForShopping": true,
      });

      await remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      // TODO
      print("Remote Config error: $e");
    }
  }

  Future SetRemoteConfig() async {
    print('Fetched open: ${remoteConfig.getString('OpenAiToken')}');
    print('Fetched open: ${remoteConfig.getString('HotpotApi')}');
    print('Fetched open: ${remoteConfig.getString('isHotpotActive')}');
    print('isNewSLideUI Enabled: ${remoteConfig.getString('isHotpotActive')}');

    AppStrings.OPENAI_TOKEN = remoteConfig.getString('OpenAiToken');
    AppStrings.HOTPOT_API = remoteConfig.getString('HotpotApi');
    AppStrings.GeminiProKey = remoteConfig.getString('GeminiProKey');
    // AppStrings.GOOGLE_SHOPPING_APIKEY = remoteConfig.getString('GoogleShoppingAPI');
    AppStrings.SHOW_HOTPOT_API_IMAGES = remoteConfig.getBool('isHotpotActive');
    AppStrings.JsonTrendTopics = remoteConfig.getString('topicslist');
    RCVariables.isNewSLideUI.value = remoteConfig.getBool('isNewSLideUI');
    RCVariables.GeminiAPIKey = remoteConfig.getString('GeminiProKey');

    initGemini(RCVariables.GeminiAPIKey);
    topicListParser();

    // AppStrings.ACTIVE_BARD = remoteConfig.getBool('activeBardForShopping');
    // AppStrings.SHOW_HOTPOT_API_IMAGES = true;
  }

  void topicListParser() {
    dynamic jsonData = jsonDecode(AppStrings.JsonTrendTopics);
    List<String> topicsList = jsonData['topicslist'].cast<String>();
    print(
        topicsList); // Output: ["CES 2024 Highlights", "Volcano Erupts in Iceland"]

    for (String topic in topicsList) {
      print("TrendingTopic $topic"); // Prints each topic individually
    }
    AppStrings.topicsList.value = topicsList;
  }

  handlePushNotification() async {
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  int inAppPurchaseCounter = 0;
  void startInAppPurchaseTimer() async {
    inAppPurchaseCounter++;
    if (inAppPurchaseCounter > 2) return;
    const duration = Duration(seconds: 100);

    Future.delayed(Duration(seconds: 5)).then((value) {
      RevenueCatService().GoToPurchaseScreen();
    });

    while (true) {
      await Future.delayed(duration);
      RevenueCatService().GoToPurchaseScreen();
    }
  }

  void initGemini(String geminiAPIKey) {
    Gemini.init(apiKey: geminiAPIKey, enableDebugging: true);
  }

  int feedBackCount = 5;

  void ShowFeedbackBottomSheet({bool fromSettings = false}) {
    log("ShowBottomSheetCalled..");
    if (feedBackCount >= 5 || fromSettings) {
      Future.delayed(Duration(seconds: fromSettings ? 0 : 2), () {
        Get.bottomSheet(Container(
          height: SizeConfig.blockSizeVertical * 60,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: Theme.of(Get.context!).colorScheme.background,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                  topRight:
                      Radius.circular(SizeConfig.blockSizeHorizontal * 3))),
          child: Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.feedback,
                        scale: 14,
                      ),
                      Text(
                        "Rate your experience",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5,
                            color: Theme.of(Get.context!).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        AppImages.feedback,
                        scale: 14,
                      ),
                    ],
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset(
                        //   AppImages.feedback,
                        //   scale: 10,
                        // ),
                        Text(
                          "Note: ",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5,
                              color: Theme.of(Get.context!).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 75,
                          child: Text(
                            "We consider your feedback very seriously and will try to improve the app according to your feedback ",
                            softWrap: true,
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color:
                                    Theme.of(Get.context!).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  // feedback_field(
                  //     context, "Recipient", controller.recipient),
                  // verticalSpace(SizeConfig.blockSizeVertical * 1),
                  // feedback_field(context, "Subject", controller.subject),
                  // verticalSpace(SizeConfig.blockSizeVertical * 1),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 95,
                    height: SizeConfig.blockSizeVertical * 25,
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        cursorColor: Theme.of(Get.context!).colorScheme.primary,
                        onChanged: (value) => feedbackMessage.value = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter feedback';
                          }
                          return null;
                        },

                        textAlignVertical: TextAlignVertical.top,

                        textAlign: TextAlign.left,
                        expands: true,
                        maxLines: null,

                        // controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 2),
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(),
                          //   borderRadius: BorderRadius.circular(
                          //       SizeConfig.blockSizeHorizontal * 2),
                          // ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(Get.context!).colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 2),
                          ),
                          // labelText: 'Name',
                          // labelStyle: TextStyle(color: Colors.blue),
                          hintText: "Add your feedback",
                          hintStyle: TextStyle(color: Colors.grey),
                          // prefixIcon:
                          //     Icon(Icons.text_fields, color: Colors.blue),
                          // suffixIcon:
                          //     Icon(Icons.check_circle, color: Colors.green),
                          filled: true,
                          fillColor:
                              Theme.of(Get.context!).colorScheme.secondary,
                          // contentPadding: EdgeInsets.symmetric(
                          //   vertical: SizeConfig.blockSizeVertical * 10,
                          //   horizontal: SizeConfig.blockSizeHorizontal * 2,
                          // ),
                        ),
                      ),
                    ),
                  ),

                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        sendFeedBackEmail(feedbackMessage.value);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: SizeConfig.blockSizeVertical * 1),
                      height: SizeConfig.blockSizeVertical * 5.5,
                      width: SizeConfig.blockSizeHorizontal * 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3,
                          ),
                          gradient: LinearGradient(
                              colors: [Colors.indigo, Colors.indigoAccent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      });
    } else {
      feedBackCount++;
    }
  }

  int reviewCount = 5;

  Future<void> showReviewDialogue(BuildContext context,
      {bool isSettings = false}) async {
    log("showReviewDialogue");
    if (reviewCount < 3 && !isSettings) {
      reviewCount++;
      return;
    }
    int finalRating = 4;
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isReviewed = pref.getBool("isReviewed") ?? false;

    if (isReviewed) {
      ShowFeedbackBottomSheet();

      return;
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext cont) => SlideRatingDialog(
              onRatingChanged: (rating) {
                print(rating.toString());
                finalRating = rating;
              },
              buttonOnTap: () async {
                final _inAppReview = InAppReview.instance;
                if (finalRating >= 3) {
                  // Review on PlayStore
                  // LaunchReview.launch(
                  //   androidAppId: "com.genius.aislides.generator",
                  // );
                  // Get.back();
                  if (isReviewed) {
                    Get.snackbar("Thanks",
                        "The submission of your review has already been completed.",
                        snackStyle: SnackStyle.FLOATING,
                        backgroundColor: Colors.white,
                        colorText: Colors.black);
                  } else {
                    if (await _inAppReview.isAvailable()) {
                      print('request actual review from store');
                      _inAppReview.requestReview();
                    } else {
                      print('open actual store listing');
                      // TODO: use your own store ids
                      _inAppReview.openStoreListing(
                        appStoreId: 'com.genius.aislides.generator',
                        // microsoftStoreId: '<your microsoft store id>',
                      );
                      reviewCount = 0;
                      pref.setBool("isReviewed", true);
                    }
                  }

                  Get.back();

                  await storeReviewCount(finalRating);
                  // EasyLoading.showSuccess("Thanks for the Rating");
                } else {
                  Get.back();

                  //? Store Review on Firebase
                  await storeReviewCount(finalRating);
                  // EasyLoading.showSuccess("Thanks for the Rating");
                }

                ShowFeedbackBottomSheet();

                // Do your Business Logic here;
              },
            ));
  }

  Future<void> storeReviewCount(int rating) async {
    final firestore = FirebaseFirestore.instance;
    final ratingDocRef = firestore.collection('Rating').doc(rating.toString());

    // Use a transaction to ensure data consistency
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ratingDocRef);
      if (!snapshot.exists) {
        transaction
            .set(ratingDocRef, {'count': 0}); // Create with initial count
      }
      transaction.update(ratingDocRef, {'count': FieldValue.increment(1)});
    });
  }
}
