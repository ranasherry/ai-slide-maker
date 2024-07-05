import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

class IntroScreensController extends GetxController {
  //TODO: Implement IntroScreensController

  final count = 0.obs;
  final prefs = SharedPreferences.getInstance();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void goToHomePage() {
    setFirstTime(false);
    AppLovinProvider.instance.showInterstitial(() {});
  }

  void setFirstTime(bool bool) {
    prefs.then((SharedPreferences pref) {
      pref.setBool('first_time', bool);
      Get.offNamed(Routes.HomeView);
    });
  }
}
