import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as dartui;
import 'package:applovin_max/applovin_max.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:im_animations/im_animations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:lottie/lottie.dart';

import 'package:slide_maker/app/data/slideResponce.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/provider/meta_ads_provider.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/big_fact_slides.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/flutter_deck_app.dart';
import 'package:slide_maker/packages/slick_slides/slick_slides.dart';
import 'package:slide_maker/packages/slick_slides/src/deck/deck_controls.dart';
import '../../provider/admob_ads_provider.dart';
import '../../routes/app_pages.dart';
import '../../utills/app_strings.dart';
import '../../utills/colors.dart';
import '../../utills/images.dart';
import '../../utills/size_config.dart';
import '../../utills/style.dart';
import '../controllers/slide_maker_controller.dart';

const _defaultTransition = SlickFadeTransition(
  color: Colors.white,
);

class SlideMakerView extends GetView<SlideMakerController> {
  SlideMakerView({Key? key}) : super(key: key);

  //  ? commented by jamal end

  /// Banner Ad Implementation End ///
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
          Obx(() => Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.convertToPPT();
                      controller.Toster("Opening...", AppColors.Green_color);
                    },
                    child: controller.showSlides.value
                        ? Platform.isAndroid
                            ? Card(
                                margin: EdgeInsets.only(
                                    right: SizeConfig.blockSizeHorizontal * 2),
                                color: AppColors.foreground_color2,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Share",
                                    // style: StyleSheet.Intro_Sub_heading_black,
                                  ),
                                ),
                              )
                            : Container()
                        : Container(),
                  ),
                ],
              ))
        ],
      ),
      body: Obx(() => Center(
            child: Stack(children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 6,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                              SizeConfig.blockSizeHorizontal *
                                                  4),
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
                                              SizeConfig.blockSizeHorizontal *
                                                  4),
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
                                                controller
                                                    .validate_user_input("Six");
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
                                            backgroundColor: Colors.indigo,

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
                        controller.showSlides.value
                            ? slideShow(context)
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                padding: EdgeInsets.all(
                                    SizeConfig.blockSizeHorizontal * 3),
                                color: Theme.of(context).colorScheme.primary,
                                // Color(0xFF0049C8),
                                // dashPattern: [19, 2, 6, 3],
                                dashPattern: [6, 1, 8, 11],
                                radius: Radius.circular(
                                    SizeConfig.blockSizeHorizontal * 4),
                                strokeWidth: 2,
                                child: AnimatedContainer(
                                  width: controller.input_box_width.value,
                                  height: controller.input_box_height.value,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow,
                                        // Colors.grey.shade300, // Shadow color
                                        spreadRadius: 2, // Spread radius
                                        blurRadius: 10, // Blur radius
                                        offset: Offset(0,
                                            5), // Offset in x and y direction
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  child: controller.showInside.value
                                      ? Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              outField(context),
                                              Divider(),
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
                          colors: [Color(0xFFD5E4FF), Color(0xFFDFEBFF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      // color: Color(0xFFD5E4FF),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 4),
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
                          color: Colors.indigo.shade700),
                    )),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
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
                              listener:
                                  AdViewAdListener(onAdLoadedCallback: (ad) {
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
                              })))),
                ),
              ),
            ]),
          )),
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

  Widget slideShow(BuildContext context) {
    // print("isShowExtraSlide: ${controller.showExtraSlides.value}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
                  child: AnimatedButton(
                    width: SizeConfig.blockSizeHorizontal * 30,
                    text: controller.isEditable.value ? "Save" : "Edit",
                    icon:
                        controller.isEditable.value ? Icons.check : Icons.edit,
                    color: controller.isEditable.value
                        ? dartui.Color.fromARGB(255, 67, 167, 105)
                        : Colors.red,
                    pressEvent: () {
                      print("You pressed Icon Elevated Button");
                      controller.isEditable.value =
                          !controller.isEditable.value;

                      if (controller.isEditable.value) {
                        final tempList = controller.slideResponseList.toList();
                        controller.editableSlideResponseList.clear();
                        controller.editableSlideResponseList.value =
                            tempList.toList();
                        print("is Editable true");
                      } else {
                        final tempList =
                            controller.editableSlideResponseList.toList();
                        controller.slideResponseList.clear();
                        controller.slideResponseList.value = tempList.toList();
                        AppLovinProvider.instance.showInterstitial(() {});
                        print("is Editable false");
                      }
                    },
                  ),
                )),
            horizontalSpace(SizeConfig.blockSizeHorizontal * 2)
          ],
        ),
        verticalSpace(SizeConfig.blockSizeVertical * 0.2),

        Obx(() => controller.isEditable.value
            ? EditSlideContent(controller: controller)
            : _slickSlide(controller.slideResponseList)),
        // EditSlideContent(controller: controller),
        verticalSpace(SizeConfig.blockSizeVertical * 2),
        MoreSlidesButton(context),
        verticalSpace(SizeConfig.blockSizeVertical * 1),

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
      ],
    );
  }

  Container _slickSlide(List<SlideResponse> slideResponseList) {
    return Container(
        // height: SizeConfig.blockSizeVertical * 20,
        // width: SizeConfig.screenWidth,
        child: SlideDeck(
            // presenterView: true,
            theme: SlideThemeData.light(
                backgroundBuilder: (context) {
                  return Image.asset(AppImages.PPT_BG3);
                },
                textTheme: SlideTextThemeData.light(
                    body: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontSize: 55.0,
                        fontWeight: FontWeight.w600,
                        fontVariations: [dartui.FontVariation('wght', 400)]))),
            slides: List.generate(
              slideResponseList.length,
              (index) {
                List<String> _bullets =
                    slideResponseList[index].slideDescription.split(".");
                return BulletsSlide(
                  title: slideResponseList[index].slideTitle,
                  bulletByBullet: true,
                  bullets: _bullets,
                  transition: _defaultTransition,
                );
              },
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

  Widget MoreSlidesButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // controller.showExtraSlides.toggle();
        controller.generateExtraSlides();
        print("Next Button Clicked");
      },
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 70,
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
              colors: [Colors.indigo, Colors.indigoAccent.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2),
          child: Center(
            child: Text(
              // controller.outlineTitleFetched.value?
              // "Recreate"
              // :
              "Regenerate with 2 Extra slides",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 12.sp,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget outField(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          controller.outlineTitleFetched.value
              ? Column(
                  children: [
                    Text(
                      "Outlines of the topic",
                      style: TextStyle(
                          fontSize: 74.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Container(
                      // height: SizeConfig.screenHeight*0.32,
                      // color: Colors.yellow,
                      height: 290,

                      child: ListView.builder(
                          itemCount: controller.slideResponseList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading: const Icon(Icons.arrow_forward),
                                title: Text(
                                  "${controller.slideResponseList[index].slideTitle}",
                                  style: TextStyle(
                                      fontSize: 54.sp,
                                      // SizeConfig.blockSizeHorizontal * 1.2,

                                      // SizeConfig.blockSizeHorizontal * 4,

                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
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
                            color: Colors.indigoAccent),
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
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget outlineTitle() {
    return Container();
  }

  Widget createButton(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!controller.isWaitingForTime.value ||
              kDebugMode ||
              RevenueCatService().currentEntitlement.value ==
                  Entitlement.paid) {
            // if (!controller.isWaitingForTime.value) {
            controller.validate_user_input("Six");
          } else {
            controller.showWatchRewardPrompt();
          }
        },
        child: HeartBeat(
          child: AnimatedContainer(
              width: controller.create_box_width.value,
              height: controller.create_box_height.value,
              // color: AppColors.Bright_Pink_color,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow, // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 10, // Blur radius
                      offset: Offset(0, 5), // Offset in x and y direction
                    ),
                  ],
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
                  // border: Border.all(color: AppColors.icon_color),
                  // color: AppColors.neonBorder,
                  gradient: LinearGradient(
                      colors: [Colors.indigoAccent, Colors.indigo],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Obx(
                () => controller.showInside.value
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          controller.isWaitingForTime.value &&
                                  RevenueCatService()
                                          .currentEntitlement
                                          .value ==
                                      Entitlement.free
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
                                      fontSize: 54.sp, color: Colors.white),
                                ),
                        ],
                      )
                    : Container(),
              )),
        ));
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
                borderSide: BorderSide.none),

            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
              // borderSide: BorderSide.none
              borderSide: BorderSide(
                color: Colors.indigo, // Border color when focused
                // width: 3.0, // Border width when focused
              ),
            ),
          ),
          onChanged: (value) {
            print(value);
            controller.userInput.value = value;
          },
        ),
      ),
    );
  }
}

class EditSlideContent extends StatelessWidget {
  EditSlideContent({
    super.key,
    required this.controller,
    this.size = const dartui.Size(1920, 1080),
  });

  final dartui.Size size;
  final SlideMakerController controller;
  RxInt currentSelectedIndex = 0.obs;
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: size.aspectRatio,
      child: Stack(
        children: [
          Container(
            child: Image.asset(AppImages.PPT_BG1),
          ),
          Column(
            children: [
              Obx(() => Container(
                    padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                    child: EditableText(
                        controller: TextEditingController(
                            text: controller
                                .editableSlideResponseList[
                                    currentSelectedIndex.value]
                                .slideTitle),
                        focusNode: titleFocusNode,
                        onChanged: (value) {
                          controller
                              .editableSlideResponseList[
                                  currentSelectedIndex.value]
                              .slideTitle = value;
                        },
                        style: TextStyle(
                            color:
                                const dartui.Color.fromARGB(255, 194, 59, 59),
                            fontSize: 20),
                        cursorColor: Colors.black,
                        backgroundCursorColor: Colors.red),
                  )),
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 3),
                    child: EditableText(
                        controller: TextEditingController(
                            text: controller
                                .editableSlideResponseList[
                                    currentSelectedIndex.value]
                                .slideDescription),
                        maxLines: 5,
                        focusNode: descriptionFocusNode,
                        onChanged: (value) {
                          controller
                              .editableSlideResponseList[
                                  currentSelectedIndex.value]
                              .slideDescription = value;
                        },
                        style: TextStyle(
                            color: dartui.Color.fromARGB(255, 29, 21, 21),
                            fontSize: 12),
                        cursorColor: Colors.black,
                        backgroundCursorColor: Colors.red),
                  )),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 3,
                  vertical: SizeConfig.blockSizeVertical),
              width: SizeConfig.blockSizeHorizontal * 40,
              child: DeckControls(
                visible: true,
                onPrevious: () {
                  if (currentSelectedIndex.value > 0) {
                    currentSelectedIndex.value--;
                    descriptionFocusNode.requestFocus();
                  }
                },
                onNext: () {
                  if (currentSelectedIndex.value <
                      controller.editableSlideResponseList.length - 1) {
                    currentSelectedIndex.value++;
                    descriptionFocusNode.requestFocus();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SingleSlideContent extends StatelessWidget {
  SingleSlideContent({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    this.size = const dartui.Size(1920, 1080),
  });

  final dartui.Size size;

  // RxInt currentSelectedIndex = 0.obs;

  String title, description, image;
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: size.aspectRatio,
      child: Stack(
        children: [
          Container(
            child: Image.asset(AppImages.PPT_BG1),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                child: Text(
                  title,
                  style: TextStyle(
                      color: const dartui.Color.fromARGB(255, 194, 59, 59),
                      fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3),
                child: Text(
                  description,
                  style: TextStyle(
                      color: dartui.Color.fromARGB(255, 29, 21, 21),
                      fontSize: 12),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SlideImageContainer extends StatefulWidget {
  const SlideImageContainer({
    Key? key, // Corrected
    required this.controller,
    required this.imagePrompt,
  }) : super(key: key); // Corrected

  final SlideMakerController controller;
  final String imagePrompt;

  @override
  State<SlideImageContainer> createState() => _SlideImageContainerState();
}

class _SlideImageContainerState extends State<SlideImageContainer> {
  // Future<Uint8List?>? imageFuture;
  Future<String?>? imageUrl;
  SlideMakerController slideMakerController = Get.find();
  // image.

  @override
  void initState() {
    super.initState();
    // imageFuture = widget.controller.makeArtRequest(widget.imagePrompt);
    imageUrl = widget.controller.generateImage(widget.imagePrompt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth *
            0.3, // Assuming SizeConfig is defined and screenWidth is accessible
        // width: 150, // Assuming SizeConfig is defined and screenWidth is accessible
        height: SizeConfig.screenHeight *
            0.2, // Assuming SizeConfig is defined and screenWidth is accessible
        // height: 150, // Assuming SizeConfig is defined and screenWidth is accessible
        child: FutureBuilder<String?>(
          // future: widget.controller.makeArtRequest(widget.imagePrompt),
          future: imageUrl,

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is running, show a loading indicator or placeholder.
              // return CircularProgressIndicator();
              return Lottie.asset(
                'assets/lottie/fBBmyrlUDl.json',
              );
            } else if (snapshot.hasError) {
              // If the future encounters an error, display an error message.
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final imageBytes = snapshot.data!;
              slideMakerController.imageslist.add(imageBytes);
              //  imagesList.add(imageBytes);

              // If the future completes successfully and provides imageBytes, display the image.
              return ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "${snapshot.data!}",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 6,
                          vertical: SizeConfig.blockSizeVertical * 6),
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                  // Image.memory(
                  //   snapshot.data!,
                  //   fit: BoxFit.cover,
                  // ),
                  );
            } else {
              // If no data is available yet, you can show a placeholder or an empty container.
              return Container();
            }
          },
        ));
  }
}
