import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SubHomeView extends GetView<HomeViewCtl> {
  const SubHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFE7EBFA),
      appBar: AppBar(
        // backgroundColor: Color(0xFFE7EBFA),
        title: Text(
          'More Features',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.primary,
            )),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
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
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.MathsSolverView);
                    AppLovinProvider.instance.showInterstitial(() {});
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 4),
                      color: Color(0xFF85C0EB),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.scan,
                            scale: 10,
                          ),
                          Text(
                            "AI Maths Solver",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Simplify math complexities effortlessly",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.HistoryView);
                    AppLovinProvider.instance.showInterstitial(() {});
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 4),
                      color: Color(0xFFFBAE8B),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.history,
                            scale: 10,
                          ),
                          Text(
                            "History",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Watch over your history collection",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.toNamed(Routes.PDF_VIEW);/
                    // Get.toNamed(Routes.MathsSolverView);
                    controller.checkPermission(Routes.PDF_VIEW);
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 4),
                      // color: Color(0xFF85C0EB),
                      color: Color(0xFFFBAE8B),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.pdf,
                            scale: 10,
                          ),
                          Text(
                            "PDF Reader",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Read any type of PDF file",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Get.toNamed(Routes.);
                    // Get.toNamed(Routes.MathsSolverView);
                    // Get.toNamed(Routes.HistoryView);
                    controller.checkPermission(Routes.PPTListView);
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 4),
                      // color: Color(0xFFFBAE8B),
                      color: Color(0xFF85C0EB),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.ppt_ic,
                            // color: Colors.transparent,
                            scale: 8,
                          ),
                          Text(
                            "PPT Viewer",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Edit PDF on the go",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 3),
          Container(
            // height: 60,
            // color: Colors.amber,
            child: Center(
              child: !AppLovinProvider.instance.isAdsEnable
                  ? Container()
                  : MaxAdView(
                      adUnitId: Platform.isAndroid
                          ? AppStrings.MAX_Mrec_ID
                          : AppStrings.IOS_MAX_MREC_ID,
                      adFormat: AdFormat.mrec,
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
                      })),
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical),
        ],
      ),
    );
  }
}
