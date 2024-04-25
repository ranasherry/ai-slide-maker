import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:slide_maker/app/modules/controllers/settings_view_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/theme/app_theme.dart';

class SettingsView extends GetView<SettingsViewCTL> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      // Color(0xFFE7EBFA),
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.background,
        // Color(0xFFE7EBFA),
        title: Text(
          "Settings",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        bottom: PreferredSize(
            child: Container(
              margin: EdgeInsets.only(
                  right: SizeConfig.blockSizeHorizontal * 3,
                  left: SizeConfig.blockSizeHorizontal * 3),
              color: Theme.of(context).colorScheme.primary,
              height: 1.5,
            ),
            preferredSize: Size.fromHeight(6.0)),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Container(
        child: Column(
          children: [
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            Container(
              // height: 60,
              // color: Colors.amber,
              child: Center(
                child: !AppLovinProvider.instance.isAdsEnable
                    ? Container()
                    : MaxAdView(
                        adUnitId: Platform.isAndroid
                            ? AppStrings.MAX_BANNER_ID
                            : AppStrings.IOS_MAX_BANNER_ID,
                        adFormat: AdFormat.banner,
                        listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                          print(
                              'Banner widget ad loaded from ' + ad.networkName);
                        }, onAdLoadFailedCallback: (adUnitId, error) {
                          print(
                              'Banner widget ad failed to load with error code ' +
                                  error.code.toString() +
                                  ' and message: ' +
                                  error.message);
                        }, onAdClickedCallback: (ad) {
                          print('Banner widget ad clicked');
                        }, onAdExpandedCallback: (ad) {
                          print('Banner widget ad expanded');
                        }, onAdCollapsedCallback: (ad) {
                          print('Banner widget ad collapsed');
                        })),
              ),
            ),
            verticalSpace(SizeConfig.blockSizeVertical),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 7,
                  right: SizeConfig.blockSizeHorizontal * 4),
              child: Row(
                children: [
                  Icon(
                      controller.isDarkMode.value
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Colors.blue),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Theme Mode",
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Light / Dark Theme",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                            color: Colors.blue),
                      )
                    ],
                  ),
                  Spacer(),
                  Obx(
                    () => Switch(
                      value: !controller.isDarkMode.value,
                      onChanged: (value) {
                        print("Is dark mode:  ${Get.isDarkMode}");
                        Get.changeThemeMode(
                            Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                        controller.isDarkMode.value = Get.isDarkMode;
                      },
                      activeColor: Colors.blue,
                      inactiveThumbColor: Colors.blueGrey,
                      activeTrackColor: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                LaunchReview.launch(
                  androidAppId: "com.genius.aislides.generator",
                );
              },
              child: settings_btn(
                  "Rate Us",
                  CupertinoIcons.hand_thumbsup_fill,
                  "Help us to grow with your 5 star",
                  Theme.of(context).colorScheme.primary),
            ),
            GestureDetector(
              onTap: () {
                controller.ShareApp();
              },
              child: settings_btn("Invite your friends", Icons.person_add_alt_1,
                  "Spread the World", Theme.of(context).colorScheme.primary),
            ),
            GestureDetector(
                onTap: () {
                  controller
                      .openURL("https://sites.google.com/view/appgeniusx/home");
                },
                child: settings_btn("Privacy Policy", Icons.privacy_tip,
                    "Rights of user", Theme.of(context).colorScheme.primary)),
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            !AppLovinProvider.instance.isAdsEnable
                ? Container()
                : MaxAdView(
                    adUnitId: Platform.isAndroid
                        ? AppStrings.MAX_Mrec_ID
                        : AppStrings.IOS_MAX_MREC_ID,
                    adFormat: AdFormat.mrec,
                    listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                      FirebaseAnalytics.instance.logAdImpression(
                        adFormat: "Mrec",
                        adSource: ad.networkName,
                        value: ad.revenue,
                      );
                      print('Mrec widget ad loaded from ' + ad.networkName);
                    }, onAdLoadFailedCallback: (adUnitId, error) {
                      print('Mrec widget ad failed to load with error code ' +
                          error.code.toString() +
                          ' and message: ' +
                          error.message);
                    }, onAdClickedCallback: (ad) {
                      print('Mrec widget ad clicked');
                    }, onAdExpandedCallback: (ad) {
                      print('Mrec widget ad expanded');
                    }, onAdCollapsedCallback: (ad) {
                      print('Mrec widget ad collapsed');
                    })),
            verticalSpace(SizeConfig.blockSizeVertical),
          ],
        ),
      ),
    );
  }

  Padding settings_btn(
      String text1, IconData icon1, String text2, Color color) {
    return Padding(
      padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 4,
          left: SizeConfig.blockSizeHorizontal * 7,
          right: SizeConfig.blockSizeHorizontal * 5),
      child: Row(
        children: [
          Icon(
            icon1,
            color: Colors.blue,
            size: SizeConfig.blockSizeHorizontal * 7,
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: color),
              ),
              Text(
                text2,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 3,
                    color: Colors.blue),
              )
            ],
          ),
        ],
      ),
    );
  }
}
