import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dp;

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';

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
    RCVariables.GeminiAPIKey = remoteConfig.getString('GeminiProKey');
    RCVariables.discountPercentage =
        remoteConfig.getInt('discountPercentage').toDouble();

    RCVariables.discountTimeLeft = remoteConfig.getInt('discountTimeLeft');
    String jsonKeys = remoteConfig.getString('GeminiKeysList');

    dp.log("discountTimeLeft: ${RCVariables.discountTimeLeft}");
    initGemini(RCVariables.GeminiAPIKey);
    topicListParser();
    keysListParser(jsonKeys);
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
    print(
        tempList); // Output: ["CES 2024 Highlights", "Volcano Erupts in Iceland"]

    for (String topic in tempList) {
      dp.log("RCKeys: $topic"); // Prints each topic individually
    }
    RCVariables.geminiAPIKeys = tempList;
  }
}
