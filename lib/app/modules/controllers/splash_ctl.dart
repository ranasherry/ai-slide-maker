import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/data/platform.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/provider/meta_ads_provider.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';

import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement HomeControlle
  bool isFirstTime = true;
  final prefs = SharedPreferences.getInstance();
  // AppLovin_CTL appLovin_CTL = Get.find();
  // GoogleAdsCTL googleAdsCT=Get.find();

  var tabIndex = 0.obs;
  // Rx<int> percent = 0.obs;
  Rx<bool> isLoaded = false.obs;
  @override
  void onInit() async {
    super.onInit();
    AppLovinProvider.instance.init();
    MetaAdsProvider.instance.initialize();

    // Timer? timer;
    // timer = Timer.periodic(Duration(milliseconds: 1000), (_) {
    //   int n = Random().nextInt(10) + 5;
    //   percent.value += n;
    //   if (percent.value >= 100) {
    //     percent.value = 100;
    //     // checkPermission();/
    //     checkFirstTime();

    //     // isLoaded.value = true;

    //     timer!.cancel();
    //   }
    // });

    Future.delayed(Duration(milliseconds: 2000), () {
      checkFirstTime();
    });
    RevenueCatService().initialize(null);
    // checkplatform();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void setFirstTime(bool bool) {
    prefs.then((SharedPreferences pref) {
      pref.setBool('first_time', bool);
      print("Is First Time: $isFirstTime");
    });
  }

  void checkFirstTime() {
    prefs.then((SharedPreferences pref) {
      isFirstTime = pref.getBool('first_time') ?? true;

      print("Is First Time from Init: $isFirstTime");
      if (isFirstTime) {
        // if (kDebugMode) {
        //   //TODO: Testing
        //   Get.toNamed(Routes.SING_IN);
        //   return;
        // }
        Get.toNamed(Routes.NEW_INTRO_SCREENS);
      } else {
        // if (kDebugMode) {
        //   //TODO: Testing
        //   Get.toNamed(Routes.SING_IN);
        //   return;
        // }
        Get.offNamed(Routes.HomeView);
        // Get.offNamed(Routes.NEW_INTRO_SCREENS);
      }
    });
  }
}
