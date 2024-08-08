import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:slide_maker/app/modules/book_writer/controllers/book_generated_ctl.dart';
import 'package:slide_maker/app/modules/home/slide_assistant.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/book_writer_controller.dart';

class BookGeneratedView extends GetView<BookGeneratedCTL> {
  const BookGeneratedView({Key? key}) : super(key: key);
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
                controller.sharePDF(context);
              },
              tooltip: 'Share PDF',
              backgroundColor: AppColors.mainColor,
              child: Icon(Icons.share),
            )
          : Container()),
      appBar: AppBar(
        title: Text(
          "AI Book Writer",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
            child: Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Obx(() => controller.bookPages.length == 0
          ? _LoadingWidget()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx(() => PageView(
                            controller: PageController(
                                viewportFraction:
                                    0.90), // Optional for custom scrolling behavior
                            children: List.generate(
                                controller.isBookGenerated.value
                                    ? controller.bookPages.length + 2
                                    : controller.bookPages.length + 3, (index) {
                              return Container(
                                // color: Colors.yellow,  // Uncomment for debugging purposes
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          // Text(
                                          //   "Chap ${index + 1} ${controller.bookPages[index].ChapName}",
                                          // ),

                                          if (controller.isBookGenerated.value)
                                            //? Book is Generated Completely
                                            if (index ==
                                                0) //? Title Page in Center
                                              buildMarkdown(context,
                                                  "${controller.TitleMarkDown.value} ")
                                            else if (index ==
                                                1) // Chapter Outlines
                                              buildMarkdown(context,
                                                  "${controller.OutlinesinMarkdown.value} ")
                                            else
                                              buildMarkdown(context,
                                                  "${controller.bookPages[index - 2].ChapData} ")
                                          else if (controller.bookPages.length +
                                                  2 ==
                                              index)
                                            //? Book is Not Generated Yet and its Remaining Loading Page

                                            _NextPageLoadingWidget()
                                          else
                                          //?Book is Being Generated and Other thes last page
                                          if (index ==
                                              0) //? Title Page in Center
                                            buildMarkdown(context,
                                                "${controller.TitleMarkDown.value} ")
                                          else if (index ==
                                              1) //? Chapter Outlines
                                            buildMarkdown(context,
                                                "${controller.OutlinesinMarkdown.value} ")
                                          else
                                            // Container()
                                            buildMarkdown(context,
                                                "${controller.bookPages[index - 2].ChapData} ")
                                          // buildMarkdown(context,
                                          //     "${controller.bookPages[index].ChapData} "),
                                          // Text(
                                          //   "${controller.bookPages[index].ChapData} ",
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                      //  ListView.builder(
                      //     itemCount: controller.bookPages.length,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         // color: Colors.yellow,
                      //         width: SizeConfig.screenWidth * .90,
                      //         height: SizeConfig.screenHeight * 0.90,
                      //         child: Card(
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: SingleChildScrollView(
                      //               child: Column(
                      //                 children: [
                      //                   Text(
                      //                       "Chap ${index + 1} ${controller.bookPages[index].ChapName}"),
                      //                   Text(
                      //                       "${controller.bookPages[index].ChapData} "),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     })

                      ),
                )
              ],
            )),
    );
  }

  Container buildMarkdown(BuildContext context, String data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    final codeWrapper =
        (child, text, language) => CodeWrapperWidget(child, text, language);

    // PreConfig(textStyle: );
    return Container(
      width: SizeConfig.screenWidth,
      // height: SizeConfig.blockSizeVertical * 50,
      child: MarkdownWidget(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        data: data,
        config: config.copy(configs: [
          isDark
              ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
              : PreConfig(
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary))
                  .copy(wrapper: codeWrapper)
        ]),
      ),
    );
  }

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
            Text("Please Wait loading Book Outlines"),
            verticalSpace(SizeConfig.blockSizeVertical * 3),
          ],
        ),
      ),
    );
  }

  Widget _NextPageLoadingWidget() {
    return Container(
      height: SizeConfig.blockSizeVertical * 80,
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
            Text("Please Wait loading The Chapter"),
            verticalSpace(SizeConfig.blockSizeVertical * 3),
          ],
        ),
      ),
    );
  }
}
