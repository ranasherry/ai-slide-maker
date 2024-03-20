import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/modules/intro_screens/views/introscreen_onboarding.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';

import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/intro_screens_controller.dart';

class IntroScreensView extends GetView<IntroScreensController> {
  const IntroScreensView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:  Text('IntroScreensView'),
      //   centerTitle: true,
      // ),
      body: IntroScreenOnboarding(
        introductionList: [
          MyIntroduction(
            title: 'Create AI Presentation',
            subTitle:
                'Let AI craft your killer slides. Own your next on demand presentation.',
            imageUrl: AppImages.PPT_BG1,
            titleTextStyle: TextStyle(fontSize: 100.sp),
          ),
          MyIntroduction(
            title: 'Your Math Problem Solver',
            subTitle: 'Unlock the power of AI to conquer any math challenge.',
            imageUrl: AppImages.PPT_BG1,
            titleTextStyle: TextStyle(fontSize: 100.sp),
          ),
          MyIntroduction(
            title: 'Document Viewer',
            subTitle: 'Open Any Document in the app as an add on',
            imageUrl: AppImages.PPT_BG1,
            titleTextStyle: TextStyle(fontSize: 100.sp),
          ),
        ],
        onTapSkipButton: () {
          controller.goToHomePage();
        },
      ),
    );
  }
}

class MyIntroduction extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subTitle;
  final double? imageWidth;
  final double? imageHeight;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;

  MyIntroduction({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    this.titleTextStyle = const TextStyle(fontSize: 20),
    this.subTitleTextStyle = const TextStyle(fontSize: 20),
    this.imageWidth = 360,
    this.imageHeight = 360,
  });

  @override
  State<StatefulWidget> createState() {
    return MyIntroductionState();
  }
}

class MyIntroductionState extends State<MyIntroduction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 3),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center(
          //   child: Image(
          //     image: AssetImage(widget.imageUrl),
          //     height: widget.imageHeight,
          //     width: widget.imageWidth,
          //   ),
          // ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: widget.titleTextStyle,
              ),
            ],
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 15),

          Text(
            widget.subTitle,
            style: widget.subTitleTextStyle,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 2),

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

          verticalSpace(SizeConfig.blockSizeVertical * 2),
        ],
      ),
    );
  }
}
