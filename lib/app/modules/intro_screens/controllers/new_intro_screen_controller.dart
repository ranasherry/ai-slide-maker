import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

class newInroScreenCTL extends GetxController {
  var selectedChoice = ''.obs;
  var SelectedGender = ''.obs;
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
    'Other',
  ].obs;

  final RxList<String> genderOptions = <String>[
    'Male',
    'Female',
    'Non-binary',
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

  Future<void> goToHomePage() async {
    // setUserProfession(selectedChoice.string);

    setFirstTime(false);
    AppLovinProvider.instance.showInterstitial(() {});
  }

  Future<void> goToProfessionPage() async {
    Get.toNamed(Routes.NEW_INTRO_SCREENS);
  }

  void setFirstTime(bool bool) {
    prefs.then((SharedPreferences pref) {
      pref.setBool('first_time', bool);

      Get.offNamed(Routes.HomeView);
    });
  }

  Future<void> setUserProfession(String profession) async {
    EasyLoading.show(status: "Please Wait...");
    await FirebaseAnalytics.instance
        .setUserProperty(name: 'Profession', value: profession);
    await updateProfessionCount(profession);
    EasyLoading.dismiss();

    goToHomePage();
  }

  Future<void> updateProfessionCount(String profession) async {
    final professionDoc =
        FirebaseFirestore.instance.collection('professions').doc(profession);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(professionDoc);

      if (!snapshot.exists) {
        transaction.set(professionDoc, {'count': 1});
      } else {
        int newCount = snapshot.data()!['count'] + 1;
        transaction.update(professionDoc, {'count': newCount});
      }
    });
  }

  Future<void> selectGender(String gender) async {
    EasyLoading.show(status: "Please Wait");
    await FirebaseAnalytics.instance
        .setUserProperty(name: 'Gender', value: gender);

    await updateGenderCount(gender);
    EasyLoading.dismiss();
    // goToHomePage();
    goToProfessionPage();
  }

  Future<void> updateGenderCount(String gender) async {
    final professionDoc =
        FirebaseFirestore.instance.collection('gender').doc(gender);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(professionDoc);

      if (!snapshot.exists) {
        transaction.set(professionDoc, {'count': 1});
      } else {
        int newCount = snapshot.data()!['count'] + 1;
        transaction.update(professionDoc, {'count': newCount});
      }
    });
  }
}
