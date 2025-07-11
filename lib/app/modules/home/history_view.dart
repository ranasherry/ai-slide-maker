import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/modules/controllers/history_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

class HistoryView extends GetView<HistoryCTL> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFE7EBFA),
      appBar: AppBar(
        title: Text(
          // "History",
          "History",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
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
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.primary,
            )),
        // backgroundColor: Color(0xFFE7EBFA),
      ),
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
                    })))),
      ),
      body: Column(
        children: [
          Obx(() => controller.savedSlides.isEmpty
              ? Expanded(
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.empty,
                            scale: 5,
                          ),
                          Text(
                            "No history found!",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: controller.savedSlides.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 5,
                              vertical: SizeConfig.blockSizeVertical * 0.75),
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(Routes.HistorySlideView,
                                  arguments: [controller.savedSlides[index]]);
                              AppLovinProvider.instance.showInterstitial(() {});
                            },
                            leading: Image.asset(AppImages.drawer),
                            title:
                                Text(controller.savedSlides[index].slideTitle),
                            subtitle: Text(timeago.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    controller.savedSlides[index].timestamp))),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20)), // Border radius
                            tileColor: Color(0xFF85C0EB),
                            // Background color
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            trailing:
                                Icon(Icons.arrow_forward), // Adjusted padding
                          ),
                        );

                        //  Container(
                        //     child: Text(controller.savedSlides[index].title));
                      }),
                ))
        ],
      ),
    );
  }
}
