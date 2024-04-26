import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SubSlideView extends StatelessWidget {
  const SubSlideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Presentation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
      body: Column(
        children: [
          verticalSpace(SizeConfig.blockSizeVertical * 1),
          Center(
            child: !AppLovinProvider.instance.isAdsEnable || Platform.isIOS
                ? Container()
                : MaxAdView(
                    adUnitId: Platform.isAndroid
                        ? AppStrings.MAX_BANNER_ID
                        : AppStrings.IOS_MAX_BANNER_ID,
                    adFormat: AdFormat.banner,
                    listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                      print('Banner widget ad loaded from ' + ad.networkName);
                    }, onAdLoadFailedCallback: (adUnitId, error) {
                      print('Banner widget ad failed to load with error code ' +
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
          // Text(
          //   "AI Assistant",
          //   style: TextStyle(
          //     fontSize: SizeConfig.blockSizeHorizontal * 4.5,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    AppLovinProvider.instance.showInterstitial(() {});
                    Get.toNamed(Routes.SlideMakerView);
                  },
                  child: card_widgets(Color(0xFFD6F5FF), Color(0xFFA2E2FE),
                      AppImages.presentation, "AI Slide Maker"),
                ),
                GestureDetector(
                  onTap: () {
                    AppLovinProvider.instance.showInterstitial(() {});
                    Get.toNamed(Routes.AiSlideAssistant);
                  },
                  child: card_widgets(Color(0xFFF8EDFE), Color(0xFFEAC0FF),
                      AppImages.chatbot, "AI Assistant"),
                )
                // GestureDetector(
                //   onTap: () {
                //     Get.toNamed(Routes.SlideMakerView);
                //     AppLovinProvider.instance.showInterstitial(() {});
                //   },
                //   child: Container(
                //     height: SizeConfig.blockSizeVertical * 20,
                //     width: SizeConfig.blockSizeHorizontal * 40,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(
                //             SizeConfig.blockSizeHorizontal * 4),
                //         color: Colors.cyan
                //         // gradient: LinearGradient(
                //         //     colors: [Color(0xFFC5401D), Color(0xFFFF8B69)],
                //         //     begin: Alignment.topCenter,
                //         //     end: Alignment.bottomCenter)
                //         // color: Color(0xFFFF7642),
                //         // Color(0xFFFBAE8B),
                //         ),
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: SizeConfig.blockSizeHorizontal * 2,
                //           vertical: SizeConfig.blockSizeVertical * 1),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Image.asset(
                //             AppImages.drawer,
                //             scale: 8,
                //           ),
                //           Text(
                //             "Slide Maker",
                //             style: TextStyle(
                //               fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text(
                //             "Create slides instantly",
                //             style: TextStyle(
                //                 fontSize: SizeConfig.blockSizeHorizontal * 3),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Get.toNamed(Routes.AiSlideAssistant);
                //     AppLovinProvider.instance.showInterstitial(() {});
                //   },
                //   child: Container(
                //     height: SizeConfig.blockSizeVertical * 20,
                //     width: SizeConfig.blockSizeHorizontal * 40,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(
                //           SizeConfig.blockSizeHorizontal * 4),
                //       color: Colors.teal,
                //     ),
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: SizeConfig.blockSizeHorizontal * 2,
                //           vertical: SizeConfig.blockSizeVertical * 1),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Image.asset(
                //             AppImages.chatbot,
                //             scale: 10,
                //           ),
                //           Text(
                //             "AI Assistant",
                //             style: TextStyle(
                //               fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text(
                //             "Unleash Your Creativity",
                //             style: TextStyle(
                //               fontSize: SizeConfig.blockSizeHorizontal * 3,
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          !AppLovinProvider.instance.isAdsEnable || Platform.isIOS
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
        ],
      ),
    );
  }
}
