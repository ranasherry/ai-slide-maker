import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dp;

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/utills/slide_pallets.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() {
    // Purchases.setEmail(email)
    return _instance;
  }

  RemoteConfigService._internal();

  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    GetRemoteConfig().then((value) {
      SetRemoteConfig();

      remoteConfig.onConfigUpdated.listen((event) async {
        print("Remote Updated");
        //  await remoteConfig.activate();
        SetRemoteConfig();

        // Use the new config values here.
      });
    });
  }

  Future GetRemoteConfig() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ));

      await remoteConfig.setDefaults(const {
        "GeminiProKey": "GeminiProKey",
        "discountPercentage": 50,
        "slotLeft": 8,
        "interCounter": 1,
        "showCreations": false,
        "geminiModel": 'gemini-2.0-flash'
      });

      await remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      // TODO
      print("Remote Config error: $e");
    }
  }

  Future SetRemoteConfig() async {
    RCVariables.GeminiAPIKey = remoteConfig.getString('GeminiProKey');

    AppStrings.JsonTrendTopics = remoteConfig.getString('topicslist');
    RCVariables.isNewSLideUI.value = remoteConfig.getBool('isNewSLideUI');
    RCVariables.showBothInApp.value = remoteConfig.getBool('showBothInApp');
    RCVariables.showNewInapp.value = remoteConfig.getBool('showNewInapp');
    RCVariables.showCreations.value = remoteConfig.getBool('showCreations');

    RCVariables.GeminiAPIKey = remoteConfig.getString('GeminiProKey');
    RCVariables.AppName.value = remoteConfig.getString('AppName');
    RCVariables.discountPercentage =
        remoteConfig.getInt('discountPercentage').toDouble();

    RCVariables.discountTimeLeft = remoteConfig.getInt('discountTimeLeft');
    RCVariables.discountTimeStamp = remoteConfig.getString('discountTimeStamp');
    RCVariables.slotLeft.value = remoteConfig.getInt('slotLeft');
    RCVariables.delayMinutes = remoteConfig.getInt('delayMinutes');
    RCVariables.interCounter = remoteConfig.getInt('interCounter');
    RCVariables.slidyStyles = remoteConfig.getString("slidyStyles");
    RCVariables.geminiModel = remoteConfig.getString("geminiModel");

    String jsonKeys = remoteConfig.getString('GeminiKeysList');

    String assitantKeys = remoteConfig.getString('geminiAPIKeysSlideAssistant');

    dp.log("discountTimeLeft: ${RCVariables.discountTimeLeft}");
    dp.log("discountTimeStamp: ${RCVariables.discountTimeStamp}");
    dp.log("interCounter: ${RCVariables.interCounter}");
    initGemini(RCVariables.GeminiAPIKey);
    topicListParser();
    keysListParser(jsonKeys);
    //line added by rizwan
    keysListParserSlideAssistant(assitantKeys);
    setSlidyStyles();
  }

  void initGemini(String geminiAPIKey) {
    Gemini.init(apiKey: geminiAPIKey, enableDebugging: kDebugMode);

    // print("Inititializing Gemeni with Key: $geminiAPIKey");
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

  void keysListParser(String jsonList) {
    dynamic jsonData = jsonDecode(jsonList);
    List<String> tempList = jsonData['keys'].cast<String>();
    // Output: ["CES 2024 Highlights", "Volcano Erupts in Iceland"]

    // for (String topic in tempList) {
    //   dp.log("RCKeys: $topic"); // Prints each topic individually
    // }
    RCVariables.geminiAPIKeys = tempList;
  }

// method added by rizwan
  void keysListParserSlideAssistant(String jsonList) {
    dynamic jsonData = jsonDecode(jsonList);
    List<String> tempList = jsonData['keys'].cast<String>();

    for (String topic in tempList) {
      dp.log("RCKeys: $topic"); // Prints each topic individually
    }
    RCVariables.geminiAPIKeysSlideAssistant = tempList;
  }

  void setSlidyStyles() {
    dynamic slidyStyles = jsonDecode(RCVariables.slidyStyles);
    // Define a list of references to the properties in AppImages
    List<List<String>> slidyStyleProperties = [
      AppImages.slidy_style1,
      AppImages.slidy_style2,
      AppImages.slidy_style3,
      AppImages.slidy_style4,
      AppImages.slidy_style5,
      AppImages.slidy_style6,
      AppImages.slidy_style7,
      AppImages.slidy_style8,
      AppImages.slidy_style9,
    ];

    slidyStyleProperties.asMap().forEach((index, element) {
      int slidyNumber = index + 1;
      String key = "slidy_style$slidyNumber"; // Correct key format

      // Check if the key exists in the map and assign the value
      if (slidyStyles.containsKey(key)) {
        List<String> styleList = (slidyStyles[key] as List<dynamic>)
            .map((element) => element.toString())
            .toList();
        slidyStyleProperties[index] = styleList;
        developer
            .log("Assisgning slidyStyles$slidyNumber : ${slidyStyles[key]}");
      } else {
        // Handle the case where the key does not exist
        print("Warning: Key '$key' not found in slidyStyles.");
        slidyStyleProperties[index] = []; // Assign an empty list as a fallback
      }

      AppImages.slidy_style1 = slidyStyleProperties[0];
      AppImages.slidy_style2 = slidyStyleProperties[1];
      AppImages.slidy_style3 = slidyStyleProperties[2];
      AppImages.slidy_style4 = slidyStyleProperties[3];
      AppImages.slidy_style5 = slidyStyleProperties[4];
      AppImages.slidy_style6 = slidyStyleProperties[5];
      AppImages.slidy_style7 = slidyStyleProperties[6];
      AppImages.slidy_style8 = slidyStyleProperties[7];
      AppImages.slidy_style9 = slidyStyleProperties[8];
      initializeSlidePallets();
    });
  }
}
