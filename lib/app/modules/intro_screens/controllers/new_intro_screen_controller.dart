import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

class newInroScreenCTL extends GetxController {
  var selectedChoice = ''.obs;
  final prefs = SharedPreferences.getInstance();

  void selectChoice(String choice) {
    selectedChoice.value = choice;
  }

  final RxList<String> chipOptions = <String>[
    'Information Technology',
    'Creativity',
    'Healthcare',
    'Education',
    'Engineering',
    'Business Management',
    'Law & Public Service',
    'Accounting & Finance',
    'Science & Research',
    'Hospitality & Tourism',
    'Art & Entertainment',
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

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
