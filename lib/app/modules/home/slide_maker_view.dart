import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:applovin_max/applovin_max.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:get/get.dart';
import 'package:im_animations/im_animations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:lottie/lottie.dart';

import 'package:slide_maker/app/data/slideResponce.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/provider/meta_ads_provider.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/big_fact_slides.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/flutter_deck_app.dart';
import 'package:slide_maker/packages/slick_slides/slick_slides.dart';
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

  // // // Banner Ad Implementation start // // //

  //  ? commented by jamal start

  // late BannerAd myBanner;
  // RxBool isBannerLoaded = false.obs;

  // initBanner() {
  //   BannerAdListener listener = BannerAdListener(
  //     // Called when an ad is successfully received.
  //     onAdLoaded: (Ad ad) {
  //       print('Ad loaded.');
  //       isBannerLoaded.value = true;
  //     },
  //     // Called when an ad request failed.
  //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //       // Dispose the ad here to free resources.
  //       ad.dispose();
  //       print('Ad failed to load: $error');
  //     },
  //     // Called when an ad opens an overlay that covers the screen.
  //     onAdOpened: (Ad ad) {
  //       print('Ad opened.');
  //     },
  //     // Called when an ad removes an overlay that covers the screen.
  //     onAdClosed: (Ad ad) {
  //       print('Ad closed.');
  //     },
  //     // Called when an impression occurs on the ad.
  //     onAdImpression: (Ad ad) {
  //       print('Ad impression.');
  //     },
  //   );

  //   myBanner = BannerAd(
  //     adUnitId: AppStrings.ADMOB_BANNER,
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: listener,
  //   );
  //   myBanner.load();
  // }

  //  ? commented by jamal end

  /// Banner Ad Implementation End ///
  @override
  Widget build(BuildContext context) {
    // initBanner(); //  ? commented by jamal end
    // SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFE7EBFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFE7EBFA),
        title: Text(
          'Slide Maker',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        // ? Commented by jamal start
        // leading: Obx(
        //   () => controller.showSlides.value
        //       ? GestureDetector(
        //           onTap: () {
        //             if (kReleaseMode) {
        //               if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
        //                 MetaAdsProvider.instance.showInterstitialAd();
        //               } else {
        //                 AppLovinProvider.instance.showInterstitial(() {});
        //               }
        //             }
        //             // AdMobAdsProvider.instance.showInterstitialAd(() {});
        //             controller.onBackPressed();
        //           },
        //           child: Icon(
        //             Icons.arrow_back_ios_new,
        //             color: Colors.black,
        //           ),
        //         )
        //       : GestureDetector(
        //           onTap: () {
        //             controller.scaffoldKey.currentState!.openDrawer();
        //           },
        //           child: Icon(
        //             Icons.menu,
        //             color: Colors.transparent, //changes by jamal
        //           )),
        // ),
        // ? Commented by jamal end

        actions: [
          Obx(() =>

              // RevenueCatService().currentEntitlement.value == Entitlement.paid?
              //     Container()
              //     :

              Row(
                children: [
                  // Obx(() => Card(
                  //     color: AppColors.foreground_color2,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text("Next ${controller.timerValue.value}"),
                  //     ))),
                  GestureDetector(
                    onTap: () {
                      controller.convertToPPT();
                      controller.Toster("Opening...", AppColors.Green_color);
                    },
                    child: controller.showSlides.value
                        ? Platform.isAndroid
                            ? Card(
                                color: AppColors.foreground_color2,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Share",
                                    style: StyleSheet.Intro_Sub_heading_black,
                                  ),
                                ),
                              )
                            : Container()
                        : Container(),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.toNamed(Routes.GemsView);
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Image.asset(
                  //         AppImages.gems,
                  //         scale: 30,
                  //       ),
                  //       Text(" ${controller.gems.value}"),
                  //       SizedBox(
                  //         width: SizeConfig.screenWidth * 0.03,
                  //       )
                  //     ],
                  //   ),
                  // ),
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
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            elevation: 4,
                                            shadowColor:
                                                Theme.of(context).cardColor,
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
                        verticalSpace(SizeConfig.blockSizeVertical * 1),
                        controller.showSlides.value
                            ? slideShow()
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                padding: EdgeInsets.all(
                                    SizeConfig.blockSizeHorizontal * 3),
                                color: Color(0xFF0049C8),
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
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors
                                            .grey.shade300, // Shadow color
                                        spreadRadius: 2, // Spread radius
                                        blurRadius: 10, // Blur radius
                                        offset: Offset(0,
                                            5), // Offset in x and y direction
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.indigo),
                                  ),
                                  child: controller.showInside.value
                                      ? Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              outField(),
                                              Divider(),
                                              inputField(),
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
                            createButton(),
                            controller.outlineTitleFetched.value
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.screenWidth * 0.15,
                                      ),
                                      NextButton(),
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
                          color: Colors.grey.shade300, // Shadow color
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
                          color: Colors.blue.shade700),
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

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  // color: Colors.amber,
                  child: Center(
                    child: MaxAdView(
                        adUnitId: AppStrings.MAX_BANNER_ID,
                        adFormat: AdFormat.banner,
                        listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                          print(
                              'Banner widget ad loaded from ' + ad.networkName);
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

  Widget slideShow() {
    // print("isShowExtraSlide: ${controller.showExtraSlides.value}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //     height: SizeConfig.blockSizeVertical * 40,
        //     child: FlutterDeckExample(
        //       slideResponseList: controller.slideResponseList,
        //       NoOfSlides: controller.slideResponseList.length,
        //       // showExtra: controller.showExtraSlides.value,
        //     )

        //     ),

        _slickSlide(controller.slideResponseList),
        verticalSpace(SizeConfig.blockSizeVertical * 1.5),
        MoreSlidesButton(),
        verticalSpace(SizeConfig.blockSizeVertical * 1),

        MaxAdView(
            adUnitId: AppStrings.MAX_Mrec_ID,
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
      ],
    );

    // Container(
    //   // padding: EdgeInsets.only(top: 60, bottom: 60),
    //   height: SizeConfig.screenHeight * 0.75,
    //   child: Obx(() => ListView.builder(
    //       // padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
    //       // itemCount: controller.outlineTitles.length,
    //       itemCount: controller.slideResponseList.length,
    //       cacheExtent: 99999,
    //       // addAutomaticKeepAlives: true, // the number of items in the list
    //       itemBuilder: (context, index) {
    //         return Stack(
    //           children: [
    //             singleSlide(index),
    //             Align(
    //               alignment: Alignment.topRight,
    //               child: Card(
    //                 color: AppColors.Green_color,
    //                 child: Padding(
    //                   padding: EdgeInsets.all(5.0),
    //                   child: Text(
    //                     "Slide ${index + 1}",
    //                     style: StyleSheet.Intro_Sub_heading,
    //                   ),
    //                 ),
    //               ),
    //             )
    //           ],
    //         );
    //         // ListTile(
    //         //   title: Text('Item ${index + 1}'), // the title of each item
    //         // );
    //       })),
    // );
    // // singleSlide();
  }

  Container _slickSlide(List<SlideResponse> slideResponseList) {
    return Container(
        // height: SizeConfig.blockSizeVertical * 20,
        // width: SizeConfig.screenWidth,
        child: SlideDeck(
            // presenterView: true,
            theme: SlideThemeData.light(
                backgroundBuilder: (context) {
                  return Image.asset(AppImages.PPT_BG2);
                },
                textTheme: SlideTextThemeData.light(
                    body: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontSize: 55.0,
                        fontWeight: FontWeight.w600,
                        fontVariations: [FontVariation('wght', 400)]))),
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

  // BigFactSlide singleSlide(index) {
  //   String title = controller.slideResponseList[index].slideTitle;
  //   String dis = controller.slideResponseList[index].slideDescription;
  //   String imagePrompt = "Create an image of $title";
  //   return BigFactSlide(
  //     customData1: 'Value 1',
  //     customData2: 'Value 2',
  //   );
  // }

  // Widget singleSlide(index) {
  //   String title = controller.slideResponseList[index].slideTitle;
  //   String dis = controller.slideResponseList[index].slideDescription;
  //   String imagePrompt = "Create an image of $title";
  //   return Padding(
  //     padding: EdgeInsets.all(8.0),
  //     child: Card(
  //       color: AppColors.buttonColor,
  //       shape: RoundedRectangleBorder(
  //         borderRadius:
  //             BorderRadius.circular(10.0), // adjust the value as you like
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.all(8.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.all(10.0),
  //               child: Container(
  //                 // width: 200,
  //                 // height: 250,
  //                 width: SizeConfig.screenWidth * 0.5,
  //                 height: SizeConfig.screenHeight * 0.3,
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         // "The Future of AI and evolving AI",
  //                         "${controller.slideResponseList[index].slideTitle}",
  //                         style: StyleSheet.Subscription_heading,
  //                       ),
  //                       Divider(),
  //                       Text(
  //                           // "Artificial Intelligence (AI) is a rapidly advancing field of computer science that empowers machines to mimic human intelligence, enabling them to learn from data, reason, make decisions, and solve complex problems. AI is transforming industries, from healthcare to finance, by automating tasks, improving efficiency, and driving innovation.",
  //                           "${controller.slideResponseList[index].slideDescription}",
  //                           style: StyleSheet.Intro_Sub_heading),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Column(
  //               // mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 // Card(
  //                 //   shape: RoundedRectangleBorder(
  //                 //     borderRadius: BorderRadius.circular(10.0),
  //                 //   ),
  //                 //   elevation: 10.0,
  //                 //   child: Image.asset(
  //                 //     AppImages.presentation,
  //                 //     scale: 4,
  //                 //   ),
  //                 // )
  //                 // SizedBox(height: SizeConfig.screenHeight *0.1,),
  //                 // ? commented by jamal start
  //                 // Card(
  //                 //   shape: RoundedRectangleBorder(
  //                 //     borderRadius: BorderRadius.circular(
  //                 //         10.0), // adjust the value as you like
  //                 //   ),
  //                 //   elevation: 10.0, // adjust the value as you like
  //                 //   child: SlideImageContainer(
  //                 //       controller: controller, imagePrompt: imagePrompt),
  //                 // ),
  //                 // ? commented by jamal end

  //                 Obx(
  //                   () => Card(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10.0)),
  //                       elevation: 10.0,
  //                       child: Container(
  //                           width: SizeConfig.screenWidth * 0.3,
  //                           child:
  //                               Image.network(controller.slideImageList[index]))
  //                       // child: Image.network("https://stackoverflow.com/questions/73336313/exception-invalid-image-data"))
  //                       ),
  //                 ),
  //               ],
  //             )

  //             // )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget NextButton() {
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
              color: Colors.grey.shade300, // Shadow color
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
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget MoreSlidesButton() {
    return GestureDetector(
      onTap: () {
        // controller.showExtraSlides.toggle();
        controller.generateExtraSlides();
        print("Next Button Clicked");
        // if (kReleaseMode) {
        //   if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
        //     MetaAdsProvider.instance.showInterstitialAd();
        //   } else {
        //     AppLovinProvider.instance.showInterstitial(() {});
        //   }
        // }

        // controller.increaseOutputHeight();
        // AdMobAdsProvider.instance.showInterstitialAd(() {});
      },
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 70,
        // height: 100,
        // color: AppColors.Bright_Pink_color,
        // duration: Duration(milliseconds: 500),
        // curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300, // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 10, // Blur radius
              offset: Offset(0, 5), // Offset in x and y direction
            ),
          ],
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 2, 199, 183),
            Color.fromARGB(255, 1, 146, 122)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
          // border: Border.all(color: AppColors.icon_color),
          color: AppColors.Green_color,
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
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget outField() {
    return SingleChildScrollView(
      child: Column(
        children: [
          controller.outlineTitleFetched.value
              ? Column(
                  children: [
                    Text(
                      "Outlines of the topic",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Container(
                      // height: SizeConfig.screenHeight*0.32,
                      height: 290,
                      child: ListView.builder(
                          itemCount: controller.slideResponseList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading: const Icon(Icons.arrow_forward),
                                // trailing: const Text(
                                //   "GFG",
                                //   style: TextStyle(color: Colors.green, fontSize: 15),
                                // ),
                                title: Text(
                                  "${controller.slideResponseList[index].slideTitle}",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      color: Colors.black),
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
                        Image.asset(
                          AppImages.drawer,
                          color: Colors.indigo,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Create presentation about",
                          style: TextStyle(
                              // fontSize: SizeConfig.blockSizeHorizontal * 3,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
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
        ],
      ),
    );
  }

  Widget outlineTitle() {
    return Container();
  }

  Widget createButton() {
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
          if (!controller.isWaitingForTime.value || kDebugMode) {
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
                      color: Colors.grey.shade300, // Shadow color
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
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
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
              )),
        ));
  }

  Widget inputField() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300, // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 10, // Blur radius
                offset: Offset(0, 5), // Offset in x and y direction
              ),
            ],
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5)),
        child: TextField(
          controller: controller.inputTextCTL,
          cursorColor: Colors.black,
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 4,
              color: Colors.black),
          decoration: InputDecoration(
            // hintText: text,

            // "Product Name",
            labelStyle: TextStyle(color: AppColors.black_color),
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
                color: Colors.indigo, // Border color when focused
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
        )
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10.0), // Same as the Card's borderRadius for rounded corners
        //   child: Image.network(
        //     "https://cdn.britannica.com/47/246247-050-F1021DE9/AI-text-to-image-photo-robot-with-computer.jpg",
        //     fit: BoxFit.cover, // You can adjust this to control how the image fits within the container
        //   ),
        // ),
        );
  }
}
