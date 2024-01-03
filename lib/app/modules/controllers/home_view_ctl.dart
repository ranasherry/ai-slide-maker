import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewCtl extends GetxController with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  // checkPermission() async {
  //   PermissionStatus status = await Permission.manageExternalStorage.status;
  //   if (status == PermissionStatus.granted) {
  //     print("Storage Granted");
  //     Future.delayed(Duration(seconds: 3), () {
  //       // Get.offNamed(Routes.HomeView);
  //       Get.toNamed(Routes.PDF_VIEW);
  //     });
  //   } else {
  //     print("Storage Not Granted");
  //     Future.delayed(Duration(seconds: 3), () {
  //       Get.offNamed(Routes.PDF_PERMISSION);
  //     });
  //   }
  // }

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
}
