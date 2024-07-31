import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
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
              child: Obx(() => RevenueCatService().currentEntitlement.value ==
                      Entitlement.paid
                  ? Container()
                  : MaxAdView(
                      adUnitId: Platform.isAndroid
                          ? AppStrings.MAX_BANNER_ID
                          : AppStrings.IOS_MAX_BANNER_ID,
                      adFormat: AdFormat.banner,
                      listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                        print('Banner widget ad loaded from ' + ad.networkName);
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
                      })))),
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
                    if (RCVariables.isNewSLideUI.value) {
                      Get.toNamed(Routes.NEWSLIDE_GENERATOR);
                    } else {
                      Get.toNamed(Routes.SlideMakerView);
                    }
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
              ],
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  AppLovinProvider.instance.showInterstitial(() {});

                  Get.toNamed(Routes.PRESENTAION_GENERATOR);
                },
                child: Container(
                  height: SizeConfig.blockSizeVertical * 10,
                  width: SizeConfig.blockSizeHorizontal * 90,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFAA6C),
                            Color.fromARGB(255, 252, 151, 43)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 2)),
                  child: Row(
                    children: [
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                      Image.asset(
                        AppImages.drawer,
                        color: Colors.deepOrange,
                        scale: 8,
                      ),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 3.5),
                      Column(
                        children: [
                          verticalSpace(SizeConfig.blockSizeVertical * 2.6),
                          Text("AI Slide Maker Beta",
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-1.5, -1.5),
                                        color: Color(0xFFFF911D)),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(1.5, -1.5),
                                        color: Color(0xFFFF911D)),
                                    Shadow(
                                        // topRight
                                        offset: Offset(1.5, 1.5),
                                        color: Color(0xFFFF911D)),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-1.5, 1.5),
                                        color: Color(0xFFFF911D)),
                                  ])),
                          Text(
                            "Join the AI slide revolution click to start!",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 2,
                                    color: Colors.white)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: SizeConfig.blockSizeHorizontal * 70,
                top: SizeConfig.blockSizeVertical * 0.3,
                child: Container(
                    height: SizeConfig.blockSizeVertical * 5,
                    width: SizeConfig.blockSizeHorizontal * 20,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppImages.limited))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "New",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color: Colors.white),
                          ),
                          Image.asset(
                            AppImages.hot,
                            scale: 1.5,
                          )
                        ],
                      ),
                    )),
              )
            ],
          ),
          // GestureDetector(
          //   onTap: () {
          //     AppLovinProvider.instance.showInterstitial(() {});

          //     Get.toNamed(Routes.PRESENTAION_GENERATOR);
          //   },
          //   child: card_widgets(Color(0xFFD6F5FF), Color(0xFFA2E2FE),
          //       AppImages.presentation, "AI Presentation New Method"),
          // ),
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          Obx(() =>
              RevenueCatService().currentEntitlement.value == Entitlement.paid
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
                      }))),
        ],
      ),
    );
  }
}
