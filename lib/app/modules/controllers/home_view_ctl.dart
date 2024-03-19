import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_maker/app/notificationservice/local_notification_service.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/main.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewCtl extends GetxController with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    GetRemoteConfig().then((value) {
      SetRemoteConfig();

      remoteConfig.onConfigUpdated.listen((event) async {
        print("Remote Updated");
        //  await remoteConfig.activate();
        SetRemoteConfig();

        // Use the new config values here.
      });
    });
    print('2 Fetched open: ${AppStrings.OPENAI_TOKEN}');
    handlePushNotification();
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

    AppStrings.OPENAI_TOKEN = remoteConfig.getString('OpenAiToken');
    AppStrings.HOTPOT_API = remoteConfig.getString('HotpotApi');
    AppStrings.GeminiProKey = remoteConfig.getString('GeminiProKey');
    // AppStrings.GOOGLE_SHOPPING_APIKEY = remoteConfig.getString('GoogleShoppingAPI');
    AppStrings.SHOW_HOTPOT_API_IMAGES = remoteConfig.getBool('isHotpotActive');
    AppStrings.JsonTrendTopics = remoteConfig.getString('topicslist');
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
}
