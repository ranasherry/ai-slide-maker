import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/provider/meta_ads_provider.dart';

import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement HomeControlle
  bool? isFirstTime = true;
  final prefs = SharedPreferences.getInstance();
  // AppLovin_CTL appLovin_CTL = Get.find();
  // GoogleAdsCTL googleAdsCT=Get.find();

  var tabIndex = 0.obs;
  Rx<int> percent = 0.obs;
  Rx<bool> isLoaded = false.obs;
  @override
  void onInit() async {
    super.onInit();
    AppLovinProvider.instance.init();
    MetaAdsProvider.instance.initialize();
    Timer? timer;
    timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      int n = Random().nextInt(10) + 5;
      percent.value += n;
      if (percent.value >= 100) {
        percent.value = 100;
        Get.offNamed(Routes.SlideMakerView);
        // isLoaded.value = true;

        timer!.cancel();
      }
    });

    // prefs.then((SharedPreferences pref) {
    //   isFirstTime = pref.getBool('first_time') ?? true;

    //   print("Is First Time from Init: $isFirstTime");
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  // void setFirstTime(bool bool) {
  //   prefs.then((SharedPreferences pref) {
  //     pref.setBool('first_time', bool);
  //     print("Is First Time: $isFirstTime");
  //   });
  // }
}
