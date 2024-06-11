import 'dart:io';
import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeView extends GetView<HomeViewCtl> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xFFE7EBFA),
        title: Text(
          'Slide Maker',
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
        leading: GestureDetector(
            onTap: () {
              Get.bottomSheet(Container(
                height: SizeConfig.blockSizeVertical * 40,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                        topRight: Radius.circular(
                            SizeConfig.blockSizeHorizontal * 3))),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.feedback,
                              scale: 14,
                            ),
                            Text(
                              "Rate your experience",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            Image.asset(
                              AppImages.feedback,
                              scale: 14,
                            ),
                          ],
                        ),
                        verticalSpace(SizeConfig.blockSizeVertical * 2),
                        // feedback_field(
                        //     context, "Recipient", controller.recipient),
                        // verticalSpace(SizeConfig.blockSizeVertical * 1),
                        // feedback_field(context, "Subject", controller.subject),
                        // verticalSpace(SizeConfig.blockSizeVertical * 1),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 95,
                          height: SizeConfig.blockSizeVertical * 25,
                          child: TextField(
                            cursorColor: Theme.of(context).colorScheme.primary,
                            onChanged: (value) =>
                                controller..subject.value = value,

                            textAlignVertical: TextAlignVertical.top,

                            textAlign: TextAlign.left,
                            expands: true,
                            maxLines: null,

                            // controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockSizeHorizontal * 2),
                              ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(),
                              //   borderRadius: BorderRadius.circular(
                              //       SizeConfig.blockSizeHorizontal * 2),
                              // ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockSizeHorizontal * 2),
                              ),
                              // labelText: 'Name',
                              // labelStyle: TextStyle(color: Colors.blue),
                              hintText: "Add your feedback",
                              hintStyle: TextStyle(color: Colors.grey),
                              // prefixIcon:
                              //     Icon(Icons.text_fields, color: Colors.blue),
                              // suffixIcon:
                              //     Icon(Icons.check_circle, color: Colors.green),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              // contentPadding: EdgeInsets.symmetric(
                              //   vertical: SizeConfig.blockSizeVertical * 10,
                              //   horizontal: SizeConfig.blockSizeHorizontal * 2,
                              // ),
                            ),
                          ),
                        ),

                        verticalSpace(SizeConfig.blockSizeVertical * 2),
                        GestureDetector(
                          onTap: () {
                            controller.send();
                          },
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5.5,
                            width: SizeConfig.blockSizeHorizontal * 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  SizeConfig.blockSizeHorizontal * 3,
                                ),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.indigo,
                                      Colors.indigoAccent
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
            },
            child: Icon(Icons.menu)),

        actions: [
          Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 2),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.SettingsView);
                },
                child: Container(
                  width: SizeConfig.screenWidth * 0.065,
                  child: Image.asset(
                    AppImages.setting,
                    color: Theme.of(context).colorScheme.primary,
                    scale: 2.8,
                  ),
                ),
              )),
          Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 4),
              child: Obx(() => RevenueCatService().currentEntitlement.value ==
                      Entitlement.free
                  ? Container(
                      width: SizeConfig.screenWidth * 0.065,
                      child: GestureDetector(
                          onTap: () {
                            if (RevenueCatService().currentEntitlement.value ==
                                Entitlement.free) {
                              Get.toNamed(
                                Routes.IN_APP_PURCHASES,
                              );
                            }
                          },
                          child: Image.asset(
                            AppImages.vip,
                            // scale: 1.8,
                          )))
                  : Container()))
// )
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 3,
                top: SizeConfig.blockSizeVertical * 1),
            child: Text(
              "Welcome Back!",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 6,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
            child: Text(
              "Generate your presentation in minutes",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 2,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    AppLovinProvider.instance.showInterstitial(() {});
                    Get.toNamed(Routes.SubSlideView);
                  },
                  child: card_widgets(Color(0xFFD6F5FF), Color(0xFFA2E2FE),
                      AppImages.presentation, "Presentation"),
                ),
                GestureDetector(
                  onTap: () {
                    AppLovinProvider.instance.showInterstitial(() {});
                    Get.toNamed(Routes.INVITATION_MAKER);
                  },
                  child: card_widgets(Color(0xFFF8EDFE), Color(0xFFEAC0FF),
                      AppImages.invite, "Invitation"),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      AppLovinProvider.instance.showInterstitial(() {});
                      Get.toNamed(Routes.BOOK_WRITER);
                    },
                    child: card_widgets(Color(0xFFCFFFDA), Color(0xFF84F99E),
                        AppImages.book, "AI Book Writer")),
                GestureDetector(
                  onTap: () {
                    AppLovinProvider.instance.showInterstitial(() {});
                    Get.toNamed(Routes.SubHomeView);
                  },
                  child: card_widgets(Color(0xFFFFFBEB), Color(0xFFFCDC96),
                      AppImages.more, "More"),
                ),
              ],
            ),
          ),
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
          verticalSpace(SizeConfig.blockSizeVertical),
        ],
      ),
    );
  }

  Padding feedback_field(
      BuildContext context, String text, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2,
          right: SizeConfig.blockSizeHorizontal * 2),
      child: TextField(
        cursorColor: Theme.of(context).colorScheme.primary,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(),
          //   borderRadius: BorderRadius.circular(
          //       SizeConfig.blockSizeHorizontal * 2),
          // ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1.0),
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
          ),
          // labelText: 'Name',
          // labelStyle: TextStyle(color: Colors.blue),
          hintText: text,
          hintStyle: TextStyle(color: Colors.grey),
          // prefixIcon:
          //     Icon(Icons.text_fields, color: Colors.blue),
          // suffixIcon:
          //     Icon(Icons.check_circle, color: Colors.green),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Padding drawer_widget(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 5,
          top: SizeConfig.blockSizeVertical * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: SizeConfig.blockSizeHorizontal * 7,
            color: AppColors.neonBorder,
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 12),
          Text(
            text,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
