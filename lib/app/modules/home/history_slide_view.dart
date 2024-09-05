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
import 'package:slide_maker/app/modules/newslide_generator/views/themes/theme1/t1_style1.dart';
import 'package:slide_maker/app/modules/newslide_generator/views/themes/theme1/t1_title1.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/flutter_deck_app.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

// const _defaultTransition = SlickFadeTransition(
//   color: Colors.white,
// );

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
                  }))),
        ),
      ),
      appBar: AppBar(
        title: Text(
          // "History",
          controller.slidesHistory != null
              ? controller.slidesHistory!.slideTitle
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

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                controller.sharePPTX();
              },
              child: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        ],
        // backgroundColor: Color(0xFFE7EBFA),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Obx(() => PageView(
                  controller: PageController(
                      viewportFraction:
                          .9), // Optional for custom scrolling behavior
                  children:
                      List.generate(controller.bookPages.length + 1, (index) {
                    return _slideCardMethod(context, index);
                  }),
                )),
          )
        ],
      ),
    );
  }

  Widget _slideCardMethod(BuildContext context, int index) {
    if (index == 0) {
      return T1_Title1History(index: index, controller: controller);
    } else {
      return T1_Style1History(index: index - 1, controller: controller);
    }
  }
}
