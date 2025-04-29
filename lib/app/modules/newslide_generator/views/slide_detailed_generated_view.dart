import 'dart:io';

import 'package:applovin_max/applovin_max.dart';

import 'package:flutter/material.dart';

import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'package:get/get.dart';

import 'package:slide_maker/app/modules/newslide_generator/controllers/slide_detailed_generated_ctl.dart';

import 'package:slide_maker/app/modules/newslide_generator/views/themes/theme1/t1_title1.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';

import 'package:slide_maker/app/utills/size_config.dart';

import 'themes/theme1/t1_style1.dart';

class SlideDetailedGeneratedView extends GetView<SlideDetailedGeneratedCTL> {
  const SlideDetailedGeneratedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
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
                  }))),
        ),
      ),
      floatingActionButton: Obx(() => controller.isBookGenerated.value
          ? FloatingActionButton(
              onPressed: () {
                // controller.sharePDF(context);
                controller.sharePPTX();
              },
              tooltip: 'Share PDF',
              focusColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Container()),
      appBar: AppBar(
        title: Obx(() => Text(
              controller.Title.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
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
      body: Obx(() => controller.bookPages.length == 0
          ? _LoadingWidget()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical,
                      horizontal: SizeConfig.blockSizeHorizontal * 5),
                  child: FAProgressBar(
                    maxValue: 7,
                    currentValue: controller.bookPages.length.toDouble() + 1,
                    displayText: '/7  slides Generated',
                    progressGradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.75),
                        Colors.green.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() => PageView(
                        controller: PageController(
                            viewportFraction:
                                .9), // Optional for custom scrolling behavior
                        children: List.generate(
                            controller.isBookGenerated.value
                                ? controller.bookPages.length +
                                    1 //will change to 1
                                : controller.bookPages.length + 1, (index) {
                          return _slideCardMethod(context, index);
                        }),
                      )),
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (controller.isFeedbackGiven.value &&
                                  controller.isPositiveFeedback.value) ||
                              !controller.isFeedbackGiven.value
                          ? IconButton(
                              onPressed: () {
                                if (!controller.isFeedbackGiven.value) {
                                  controller.GoodResponse();
                                }
                              },
                              icon: Icon(
                                controller.isFeedbackGiven.value &&
                                        controller.isPositiveFeedback.value
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_alt_outlined,
                                size: SizeConfig.blockSizeHorizontal * 5,
                              ),
                            )
                          : Container(),
                      (controller.isFeedbackGiven.value &&
                                  !controller.isPositiveFeedback.value) ||
                              !controller.isFeedbackGiven.value
                          ? IconButton(
                              onPressed: () {
                                if (!controller.isFeedbackGiven.value) {
                                  controller.reportMessage(Get.context!);
                                }
                              },
                              icon: Icon(
                                controller.isFeedbackGiven.value &&
                                        !controller.isPositiveFeedback.value
                                    ? Icons.thumb_down
                                    : Icons.thumb_down_alt_outlined,
                                size: SizeConfig.blockSizeHorizontal * 5,
                              ),
                            )
                          : Container()
                    ],
                  ),
                )
              ],
            )),
    );
  }

  Widget _slideCardMethod(BuildContext context, int index) {
    if (index == 0) {
      return T1_Title1(index: index, controller: controller);
    } else {
      return T1_Style1(index: index - 1, controller: controller);
    }
  }

  // Container buildMarkdown(BuildContext context, String data) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //   final config =
  //       isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
  //   final codeWrapper =
  //       (child, text, language) => CodeWrapperWidget(child, text, language);

  //   // PreConfig(textStyle: );
  //   return Container(
  //     width: SizeConfig.screenWidth,
  //     // height: SizeConfig.blockSizeVertical * 50,
  //     // decoration:
  //     //     BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
  //     child: MarkdownWidget(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       data: data,
  //       config: config.copy(configs: [
  //         isDark
  //             ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
  //             : PreConfig(
  //                     textStyle: TextStyle(
  //                         color: Theme.of(context).colorScheme.primary))
  //                 .copy(wrapper: codeWrapper)
  //       ]),
  //     ),
  //   );
  // }

  Widget _LoadingWidget() {
    return Container(
      // height: SizeConfig.blockSizeVertical * 100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: SizeConfig.blockSizeHorizontal * 20,
                height: SizeConfig.blockSizeHorizontal * 20,
                child: CircularProgressIndicator()),
            verticalSpace(SizeConfig.blockSizeVertical * 3),
            Text("Please Wait loading Slide"),
            verticalSpace(SizeConfig.blockSizeVertical * 3),
          ],
        ),
      ),
    );
  }
}
