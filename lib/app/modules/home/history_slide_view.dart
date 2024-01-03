import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/modules/controllers/history_ctl.dart';
import 'package:slide_maker/app/modules/controllers/history_slide_ctl.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/flutter_deck_app.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistorySlideView extends GetView<HistorySlideCTL> {
  const HistorySlideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7EBFA),
      bottomNavigationBar: Container(
        height: 60,
        // color: Colors.amber,
        child: Center(
          child: MaxAdView(
              adUnitId: AppStrings.MAX_BANNER_ID,
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
        backgroundColor: Color(0xFFE7EBFA),
      ),
      body: Column(
        children: [slideShow()],
      ),
    );
  }

  Widget slideShow() {
    return Obx(() => controller.slideResponseList.isNotEmpty
        ? FlutterDeckExample(
            slideResponseList: controller.slideResponseList,
            NoOfSlides: controller.slideResponseList.length,
          )
        : Container());
  }
}
