import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsViewCTL extends GetxController {
  RxBool isDarkMode = false.obs;
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

  ShareApp() {
    Share.share(
        "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=com.genius.aislides.generator.");
  }

  Future openURL(ur) async {
    final Uri _url = Uri.parse(ur);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> signOut() async {
    EasyLoading.show(status: "Logging out...");
    await FirebaseAuth.instance.signOut();
    await RevenueCatService().signOut();
    EasyLoading.dismiss();
    Get.offAllNamed(Routes.HomeView);
  }

  Future<void> deleteAccount() async {
    EasyLoading.show(status: "Please Wait...");
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      EasyLoading.dismiss();
      EasyLoading.showSuccess("Account deleted successfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
      EasyLoading.dismiss();
      EasyLoading.showError("Could not delete the account");
    }
  }
}
