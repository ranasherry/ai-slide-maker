import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/templates/tamplate1.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/invitation_maker_controller.dart';

class InvitationMakerView extends GetView<InvitationMakerController> {
  const InvitationMakerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invitation Maker',
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
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
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          verticalSpace(SizeConfig.blockSizeVertical * 1),
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
                    Get.toNamed(Routes.WeddingInvitationView);
                  },
                  child: card_widgets(Color(0xFFD6F5FF), Color(0xFFA2E2FE),
                      AppImages.wedding, "Wedding Invitation"),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.BirthdayTemplate);
                  },
                  child: card_widgets(Color(0xFFFFFBEB), Color(0xFFFCDC96),
                      AppImages.birthday, "Birthday Invitation"),
                ),
                // MyContainer(
                //     color: Color(0xFF85C0EB),
                //     image: AppImages.wedding,
                //     title: "Wedding Invitations",
                //     desc: "Create Wedding Invitation Cards instantly",
                //     routes: Routes.WeddingInvitationView),
                // MyContainer(
                //     color: Color(0xFFFBAE8B),
                //     image: AppImages.birthday,
                //     title: "Birthday Invitations",
                //     desc: "Create Birthday Invitation Cards instantly",
                //     routes: Routes.BirthdayTemplate),
              ],
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          Container(
            // height: 60,
            // color: Colors.amber,
            child: Center(
              child: !AppLovinProvider.instance.isAdsEnable || Platform.isIOS
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
        ],
      ),
    );
  }

  GestureDetector MyContainer(
      {required Color color,
      required String image,
      required String title,
      required String desc,
      required String routes}) {
    return GestureDetector(
      onTap: () {
        print("Hello");
        Get.toNamed(routes);
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 20,
        width: SizeConfig.blockSizeHorizontal * 40,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
          color: color,
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
                image,
                scale: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                desc,
                style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
