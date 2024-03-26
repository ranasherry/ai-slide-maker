import 'dart:io';
import 'dart:ui';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:slide_maker/app/data/slideResponce.dart';
import 'package:slide_maker/app/modules/controllers/history_ctl.dart';
import 'package:slide_maker/app/modules/controllers/history_slide_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/flutter_deck_app.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../packages/slick_slides/slick_slides.dart';

const _defaultTransition = SlickFadeTransition(
  color: Colors.white,
);

class HistorySlideView extends GetView<HistorySlideCTL> {
  HistorySlideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFE7EBFA),
      bottomNavigationBar: Container(
        height: 60,
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
      ),
      appBar: AppBar(
        title: Text(
          // "History",
          controller.slidesHistory != null
              ? controller.slidesHistory!.title
              : "Slide",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.primary,
            )),
        // backgroundColor: Color(0xFFE7EBFA),
      ),
      body: Column(
        children: [slideShow()],
      ),
    );
  }

  // Widget slideShow() {
  //   return Obx(() => controller.slideResponseList.isNotEmpty
  //       ? FlutterDeckExample(
  //           slideResponseList: controller.slideResponseList,
  //           NoOfSlides: controller.slideResponseList.length,
  //           // showExtra: true,
  //         )
  //       : Container());
  // }

  Widget slideShow() {
    // print("isShowExtraSlide: ${controller.showExtraSlides.value}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //     height: SizeConfig.blockSizeVertical * 40,
        //     child: FlutterDeckExample(
        //       slideResponseList: controller.slideResponseList,
        //       NoOfSlides: controller.slideResponseList.length,
        //       // showExtra: controller.showExtraSlides.value,
        //     )

        //     ),

        _slickSlide(controller.slideResponseList),
        verticalSpace(SizeConfig.blockSizeVertical * 1.5),
        // MoreSlidesButton(),

        MaxAdView(
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
    );

    // Container(
    //   // padding: EdgeInsets.only(top: 60, bottom: 60),
    //   height: SizeConfig.screenHeight * 0.75,
    //   child: Obx(() => ListView.builder(
    //       // padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
    //       // itemCount: controller.outlineTitles.length,
    //       itemCount: controller.slideResponseList.length,
    //       cacheExtent: 99999,
    //       // addAutomaticKeepAlives: true, // the number of items in the list
    //       itemBuilder: (context, index) {
    //         return Stack(
    //           children: [
    //             singleSlide(index),
    //             Align(
    //               alignment: Alignment.topRight,
    //               child: Card(
    //                 color: AppColors.Green_color,
    //                 child: Padding(
    //                   padding: EdgeInsets.all(5.0),
    //                   child: Text(
    //                     "Slide ${index + 1}",
    //                     style: StyleSheet.Intro_Sub_heading,
    //                   ),
    //                 ),
    //               ),
    //             )
    //           ],
    //         );
    //         // ListTile(
    //         //   title: Text('Item ${index + 1}'), // the title of each item
    //         // );
    //       })),
    // );
    // // singleSlide();
  }

  Container _slickSlide(List<SlideResponse> slideResponseList) {
    return Container(
        // height: SizeConfig.blockSizeVertical * 20,
        // width: SizeConfig.screenWidth,
        child: SlideDeck(
            // presenterView: true,
            theme: SlideThemeData.light(
                backgroundBuilder: (context) {
                  return Image.asset(AppImages.PPT_BG2);
                },
                textTheme: SlideTextThemeData.light(
                    body: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontSize: 55.0,
                        fontWeight: FontWeight.w600,
                        fontVariations: [FontVariation('wght', 400)]))),
            slides: List.generate(
              slideResponseList.length,
              (index) {
                List<String> _bullets =
                    slideResponseList[index].slideDescription.split(".");
                return BulletsSlide(
                  title: slideResponseList[index].slideTitle,
                  bulletByBullet: true,
                  bullets: _bullets,
                  // transition: _defaultTransition,
                );
              },
            )));
  }
}
