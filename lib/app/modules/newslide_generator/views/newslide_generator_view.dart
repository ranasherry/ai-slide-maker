import 'dart:developer';
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:im_animations/im_animations.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/provider/meta_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/newslide_generator_controller.dart';

class NewslideGeneratorView extends GetView<NewslideGeneratorController> {
  const NewslideGeneratorView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // initBanner(); //  ? commented by jamal end
    // SizeConfig().init(context);
    return Scaffold(
      // backgroundColor: Color(0xFFE7EBFA),
      appBar: AppBar(
        // backgroundColor: Color(0xFFE7EBFA),
        title: Text(
          'Slide Maker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              if (kReleaseMode) {
                if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
                  MetaAdsProvider.instance.showInterstitialAd();
                } else {
                  AppLovinProvider.instance.showInterstitial(() {});
                }
              }
              Get.back();
              // AdMobAdsProvider.instance.showInterstitialAd(() {});
              // controller.onBackPressed(); // ? Commented by jamal
            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 4),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.HistoryView);
                },
                child: Container(
                  // width: SizeConfig.screenWidth * 0.065,
                  child: Icon(
                    Icons.history,
                    size: 30,
                  ),
                ),
              )),
        ],
      ),
      body: Obx(() => Stack(children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 6,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        // color: Colors.amber,
                        child: Center(
                          child: Obx(() => RevenueCatService()
                                      .currentEntitlement
                                      .value ==
                                  Entitlement.paid
                              ? Container()
                              : MaxAdView(
                                  adUnitId: Platform.isAndroid
                                      ? AppStrings.MAX_BANNER_ID
                                      : AppStrings.IOS_MAX_BANNER_ID,
                                  adFormat: AdFormat.banner,
                                  listener: AdViewAdListener(
                                      onAdLoadedCallback: (ad) {
                                    print('Banner widget ad loaded from ' +
                                        ad.networkName);
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
                                  }))),
                        ),
                      ),
                      controller.outlineTitleFetched.value
                          ? Container()
                          : Container(
                              width: SizeConfig.screenWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.blockSizeHorizontal * 4),
                                    child: Text(
                                      'Trending Topics:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.blockSizeHorizontal * 4),
                                    child: Wrap(
                                      spacing: 3.0,
                                      runSpacing: 3.0,
                                      children: AppStrings.topicsList.value
                                          .map((suggestion) {
                                        return ActionChip(
                                          onPressed: () {
                                            controller.userInput.value =
                                                suggestion;
                                            if (!controller
                                                    .isWaitingForTime.value ||
                                                kDebugMode) {
                                              // if (!controller.isWaitingForTime.value) {
                                              controller.validate_user_input();
                                            } else {
                                              controller
                                                  .showWatchRewardPrompt();
                                            }

                                            // controller.NoOfSlides = 1;
                                          },
                                          label: Text(
                                            suggestion,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11),
                                          ),
                                          backgroundColor: AppColors.mainColor,

                                          // Theme.of(context).primaryColor,
                                          elevation: 4,
                                          shadowColor:
                                              Theme.of(context).shadowColor,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      verticalSpace(SizeConfig.blockSizeVertical * 2),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                        // color: Theme.of(context).colorScheme.primary,
                        color: AppColors.mainColor,
                        // Color(0xFF0049C8),
                        // dashPattern: [19, 2, 6, 3],
                        dashPattern: [6, 1, 8, 11],
                        radius:
                            Radius.circular(SizeConfig.blockSizeHorizontal * 4),
                        strokeWidth: 2,
                        child: AnimatedContainer(
                          width: controller.input_box_width.value,
                          height: controller.input_box_height.value,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                // Colors.grey.shade300, // Shadow color
                                spreadRadius: 2, // Spread radius
                                blurRadius: 10, // Blur radius
                                offset:
                                    Offset(0, 5), // Offset in x and y direction
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              // color: Theme.of(context).colorScheme.primary,
                              color: AppColors.mainColor,
                            ),
                          ),
                          child: controller.showInside.value
                              ? Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      outField(context),
                                      Divider(
                                        color: AppColors.mainColor,
                                      ),
                                      inputField(context),
                                    ],
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          createButton(context),
                          controller.outlineTitleFetched.value
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.screenWidth * 0.15,
                                    ),
                                    NextButton(context),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: SizeConfig.blockSizeVertical * 6,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        // colors: [Color(0xFFD5E4FF), Color(0xFFDFEBFF)],
                        colors: [
                          Color.fromARGB(255, 253, 141, 101),
                          Color.fromARGB(255, 255, 200, 180)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    // color: Color(0xFFD5E4FF),
                    borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(SizeConfig.blockSizeHorizontal * 4),
                        bottomRight: Radius.circular(
                            SizeConfig.blockSizeHorizontal * 4)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow, // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: Offset(0, 5), // Offset in x and y direction
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    "Note: This Content is AI generated",
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      // color: Color(0xFF013961)
                      // color: Colors.indigo.shade700,
                      color: AppColors.mainColor,
                    ),
                  )),
                ),
              ],
            ),

            //  ? commented by jamal start
            // Obx(() => isBannerLoaded.value &&
            //         AdMobAdsProvider.instance.isAdEnable.value
            //     ? Container(
            //         height: AdSize.banner.height.toDouble(),
            //         child: AdWidget(ad: myBanner))
            //     : Container()),
            //  ? commented by jamal end
          ])),
    );
  }

  Widget createButton(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // controller.increaseOutputHeight();
          // controller.tempList(); //? commmented by jamal

          //Just for now
          // if (kReleaseMode) {
          //   if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
          //     MetaAdsProvider.instance.showInterstitialAd();
          //   } else {
          //     AppLovinProvider.instance.showInterstitial(() {});
          //   }
          // }
          // AdMobAdsProvider.instance.showInterstitialAd(() {});
          // if (!controller.isWaitingForTime.value || kDebugMode) {
          //   // if (!controller.isWaitingForTime.value) {
          //   controller.validate_user_input();
          // } else {
          //   controller.showWatchRewardPrompt();
          // }

          controller.validate_user_input();
        },
        child: AnimatedContainer(
            width: controller.create_box_width.value,
            height: controller.create_box_height.value,
            // color: AppColors.Bright_Pink_color,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow, // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 10, // Blur radius
                  offset: Offset(0, 5), // Offset in x and y direction
                ),
              ],
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
              // border: Border.all(color: AppColors.icon_color),
              color: AppColors.mainColor,
              // gradient: LinearGradient(
              //     colors: [Colors.indigoAccent, Colors.indigo],

              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter)
            ),
            child: Obx(
              () => controller.showInside.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.isWaitingForTime.value
                            ? Text(
                                controller.outlineTitleFetched.value
                                    ? "Recreate in ${controller.timerValue.value}"
                                    : "Create in ${controller.timerValue.value}",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    color: Colors.white),
                              )
                            : Text(
                                controller.outlineTitleFetched.value
                                    ? "Recreate"
                                    : "Create",
                                style: TextStyle(
                                    fontSize: 54.sp,
                                    // SizeConfig.blockSizeHorizontal * 4,
                                    // SizeConfig.blockSizeHorizontal * 2,
                                    color: Colors.white),
                              ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.only(
                        //           left: SizeConfig.blockSizeHorizontal * 1),
                        //       child: Text(
                        //         "20",
                        //         style: TextStyle(
                        //             fontSize:
                        //                 SizeConfig.blockSizeHorizontal * 3,
                        //             color: Colors.white),
                        //       ),
                        //     ),
                        //     horizontalSpace(SizeConfig.blockSizeHorizontal * 1),
                        //     Image.asset(
                        //       AppImages.gems,
                        //       scale: 35,
                        //     )
                        //   ],
                        // )
                      ],
                    )
                  : Container(),
            )));
  }

  Widget NextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Next Button Clicked");
        if (kReleaseMode) {
          if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
            MetaAdsProvider.instance.showInterstitialAd();
          } else {
            AppLovinProvider.instance.showInterstitial(() {});
          }
        }

        // controller.increaseOutputHeight();
        // AdMobAdsProvider.instance.showInterstitialAd(() {});
        controller.hide_outlines();
      },
      child: AnimatedContainer(
        width: controller.create_box_width.value,
        height: controller.create_box_height.value,
        // color: AppColors.Bright_Pink_color,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow, // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 10, // Blur radius
              offset: Offset(0, 5), // Offset in x and y direction
            ),
          ],
          gradient: LinearGradient(
              colors: [Color(0xFF21B654), Color.fromARGB(255, 19, 104, 57)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
          // border: Border.all(color: AppColors.icon_color),
          color: AppColors.Green_color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              // controller.outlineTitleFetched.value?
              // "Recreate"
              // :
              "Next",
              style: TextStyle(
                  // fontSize: SizeConfig.blockSizeHorizontal * 4,
                  // fontSize: SizeConfig.blockSizeHorizontal * 2,
                  fontSize: 64.sp,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow, // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 5), // Offset in x and y direction
              ),
            ],
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5)),
        child: TextField(
          controller: controller.inputTextCTL,
          cursorColor: Theme.of(context).colorScheme.primary,
          style: TextStyle(
              // fontSize: SizeConfig.blockSizeHorizontal * 4,
              // fontSize: SizeConfig.blockSizeHorizontal * 1.2,
              fontSize: 54.sp,
              color: Theme.of(context).colorScheme.primary),
          decoration: InputDecoration(
            // hintText: text,

            // "Product Name",
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            labelText: "What is the presentation about?",
            hintText: "Example: What is AI?",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
                borderSide: BorderSide.none
                // borderSide: BorderSide(
                //   color: Color(0xFF0095B0), // Border color
                //   width: 1.0, // Border width
                // ),
                ),

            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
              // borderSide: BorderSide.none
              borderSide: BorderSide(
                color: AppColors.mainColor, // Border color when focused
                // width: 3.0, // Border width when focused
              ),
            ),
          ),
          // cursorColor: Colors.white,
          //               style: TextStyle(
          //                   // fontSize: SizeConfig.blockSizeHorizontal * 4,
          //                   color: Colors.white),
          // decoration: InputDecoration(labelText:
          // "Product Name",
          // // fillColor: Colors.white
          // // colo
          // ),
          onChanged: (value) {
            print(value);
            controller.userInput.value = value;
          },
        ),
      ),
    );
  }

  Widget outField(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => controller.outlineTitleFetched.value
                ? Column(
                    children: [
                      Text(
                        "Outlines of the Presentation",
                        style: TextStyle(
                            // fontSize: SizeConfig.blockSizeHorizontal * 4,
                            // fontSize: SizeConfig.blockSizeHorizontal * 1.3,
                            fontSize: 74.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Container(
                        // height: SizeConfig.screenHeight*0.32,
                        // color: Colors.yellow,
                        height: 290,

                        child: ListView.builder(
                            itemCount: controller.outlineTitles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                  leading: const Icon(Icons.arrow_forward),
                                  // trailing: const Text(
                                  //   "GFG",
                                  //   style: TextStyle(color: Colors.green, fontSize: 15),
                                  // ),
                                  title: Text(
                                    "${controller.outlineTitles[index]}",
                                    // onChanged: (value) {
                                    //   controller.outlineTitles[index] = value;
                                    //   log("New Outline: ${controller.outlineTitles[index]}");
                                    // },
                                    style: TextStyle(
                                        fontSize: 54.sp,
                                        // SizeConfig.blockSizeHorizontal * 1.2,

                                        // SizeConfig.blockSizeHorizontal * 4,

                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    // controller: TextEditingController(
                                    //   text:
                                    //       "${controller.outlineTitles[index]}",
                                    // ),
                                    // focusNode: FocusNode(),
                                    // cursorColor:
                                    //     Theme.of(context).colorScheme.primary,
                                    // backgroundCursorColor:
                                    //     Theme.of(context).colorScheme.secondary,
                                  ));
                            }),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      height: SizeConfig.screenHeight * 0.05,
                      child: Row(
                        children: [
                          Image.asset(AppImages.drawer,
                              color: AppColors.mainColor),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Create presentation about",
                            style: TextStyle(
                                // fontSize: SizeConfig.blockSizeHorizontal * 3,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          // Container(
                          //   color: AppColors.greybox,
                          //   child:
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(children: [
                          //     Image.asset(AppImagesPack2.slides,color: AppColors.icon_color,),
                          //     Text("6 pages",
                          //   style: TextStyle(
                          //   // fontSize: SizeConfig.blockSizeHorizontal * 4,
                          //   color: Colors.white),
                          //   ),
                          //   ],),
                          // ),)
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
