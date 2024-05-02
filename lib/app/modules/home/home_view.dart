import 'dart:io';
import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
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
      // backgroundColor: Color(0xFFE7EBFA),
      // key: controller.scaffoldKey,
      // drawer: Drawer(
      //   width: SizeConfig.blockSizeHorizontal * 75,
      //   child: Column(
      //     children: [
      //       Container(
      //         width: SizeConfig.screenWidth,
      //         height: SizeConfig.blockSizeVertical * 30,
      //         color: AppColors.neonBorder,
      //         child: Image.asset(
      //           AppImages.drawer,
      //           scale: 5,
      //         ),
      //       ),
      //       GestureDetector(
      //           onTap: () {
      //             LaunchReview.launch(
      //               androidAppId: "com.genius.aislides.generator",
      //             );
      //           },
      //           child: drawer_widget(Icons.thumb_up, "Rate Us")),
      //       GestureDetector(
      //           onTap: () {
      //             controller.ShareApp();
      //           },
      //           child: drawer_widget(Icons.share, "Share")),
      //       GestureDetector(
      //           onTap: () {
      //             controller
      //                 .openURL("https://sites.google.com/view/appgeniusx/home");
      //           },
      //           child: drawer_widget(Icons.privacy_tip, "Privacy Policy"))
      //     ],
      //   ),
      // ),
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
        actions: [
          Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 2),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.SettingsView);
                },
                child: Image.asset(
                  AppImages.setting,
                  color: Theme.of(context).colorScheme.primary,
                  scale: 2.8,
                ),
              ))
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // verticalSpace(SizeConfig.blockSizeVertical * 1),
          // Container(
          //   height: 60,
          //   // color: Colors.amber,
          //   child: Center(
          //     child: !AppLovinProvider.instance.isAdsEnable
          //         ? Container()
          //         : MaxAdView(
          //             adUnitId: Platform.isAndroid
          //                 ? AppStrings.MAX_BANNER_ID
          //                 : AppStrings.IOS_MAX_BANNER_ID,
          //             adFormat: AdFormat.banner,
          //             listener: AdViewAdListener(onAdLoadedCallback: (ad) {
          //               print('Banner widget ad loaded from ' +
          //                   ad.networkName);
          //             }, onAdLoadFailedCallback: (adUnitId, error) {
          //               print(
          //                   'Banner widget ad failed to load with error code ' +
          //                       error.code.toString() +
          //                       ' and message: ' +
          //                       error.message);
          //             }, onAdClickedCallback: (ad) {
          //               print('Banner widget ad clicked');
          //             }, onAdExpandedCallback: (ad) {
          //               print('Banner widget ad expanded');
          //             }, onAdCollapsedCallback: (ad) {
          //               print('Banner widget ad collapsed');
          //             })),
          //   ),
          // ),
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
                        AppImages.book, "Book Writer")),
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

          // Padding(
          //   padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           Get.toNamed(Routes.SubSlideView);
          //           AppLovinProvider.instance.showInterstitial(() {});
          //         },
          //         child: Container(
          //           height: SizeConfig.blockSizeVertical * 20,
          //           width: SizeConfig.blockSizeHorizontal * 40,
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(
          //                   SizeConfig.blockSizeHorizontal * 4),
          //               gradient: LinearGradient(
          //                   colors: [Color(0xFFC5401D), Color(0xFFFF8B69)],
          //                   begin: Alignment.topCenter,
          //                   end: Alignment.bottomCenter)
          //               // color: Color(0xFFFF7642),
          //               // Color(0xFFFBAE8B),
          //               ),
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: SizeConfig.blockSizeHorizontal * 2,
          //                 vertical: SizeConfig.blockSizeVertical * 1),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: [
          //                 Image.asset(
          //                   AppImages.drawer,
          //                   scale: 8,
          //                 ),
          //                 Text(
          //                   "Slide Maker",
          //                   style: TextStyle(
          //                     fontSize: SizeConfig.blockSizeHorizontal * 4.5,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Text(
          //                   "Create slides instantly",
          //                   style: TextStyle(
          //                       fontSize: SizeConfig.blockSizeHorizontal * 3),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           Get.toNamed(Routes.INVITATION_MAKER);
          //           AppLovinProvider.instance.showInterstitial(() {});
          //         },
          //         child: Container(
          //           height: SizeConfig.blockSizeVertical * 20,
          //           width: SizeConfig.blockSizeHorizontal * 40,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(
          //                 SizeConfig.blockSizeHorizontal * 4),
          //             color: Color(0xFF85C0EB),
          //           ),
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: SizeConfig.blockSizeHorizontal * 2,
          //                 vertical: SizeConfig.blockSizeVertical * 1),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: [
          //                 Image.asset(
          //                   AppImages.invitation,
          //                   scale: 10,
          //                 ),
          //                 Text(
          //                   "Invitation Maker",
          //                   style: TextStyle(
          //                     fontSize: SizeConfig.blockSizeHorizontal * 4.5,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 Text(
          //                   "Create Invitation Cards",
          //                   style: TextStyle(
          //                     fontSize: SizeConfig.blockSizeHorizontal * 3,
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Platform.isAndroid
          //     ? Container(
          //         padding: EdgeInsets.symmetric(
          //             horizontal: SizeConfig.blockSizeHorizontal * 5),
          //         child: GestureDetector(
          //           onTap: () {
          //             Get.toNamed(Routes.SubHomeView);
          //           },
          //           child: Container(
          //             margin: EdgeInsets.only(
          //                 top: SizeConfig.blockSizeVertical * 3),
          //             height: SizeConfig.blockSizeVertical * 12,
          //             width: SizeConfig.blockSizeHorizontal * 85,
          //             decoration: BoxDecoration(
          //               color: Color(0xFF9DB0EC),
          //               borderRadius: BorderRadius.circular(
          //                   SizeConfig.blockSizeHorizontal * 4),
          //             ),
          //             child: Padding(
          //               padding: EdgeInsets.only(
          //                   right: SizeConfig.blockSizeHorizontal * 3),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Padding(
          //                     padding: EdgeInsets.only(
          //                       left: SizeConfig.blockSizeHorizontal * 3,
          //                       top: SizeConfig.blockSizeVertical * 1,
          //                     ),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           "More Features",
          //                           style: TextStyle(
          //                             fontSize:
          //                                 SizeConfig.blockSizeHorizontal * 4.5,
          //                             fontWeight: FontWeight.bold,
          //                           ),
          //                         ),
          //                         Text(
          //                           "Maths, PDF, PPT, History",
          //                           style: TextStyle(
          //                             fontSize:
          //                                 SizeConfig.blockSizeHorizontal * 3,
          //                           ),
          //                         ),
          //                         Container(
          //                           margin: EdgeInsets.only(
          //                               top:
          //                                   SizeConfig.blockSizeVertical * 0.5),
          //                           height: SizeConfig.blockSizeVertical * 3,
          //                           width: SizeConfig.blockSizeHorizontal * 16,
          //                           decoration: BoxDecoration(
          //                             color: Color(0xFF284D79),
          //                             boxShadow: [
          //                               BoxShadow(
          //                                 color: Colors.white70,
          //                                 spreadRadius: 2,
          //                                 blurRadius: 10,
          //                                 offset: Offset(0, 5),
          //                               ),
          //                             ],
          //                             borderRadius: BorderRadius.circular(
          //                               SizeConfig.blockSizeHorizontal * 1,
          //                             ),
          //                           ),
          //                           child: Center(
          //                             child: Text(
          //                               "Check",
          //                               style: TextStyle(color: Colors.white),
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   // Image added to the right side
          //                   Image.asset(
          //                     AppImages.more_features,
          //                     scale: 8,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : Container(),

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
          verticalSpace(SizeConfig.blockSizeVertical),
        ],
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
