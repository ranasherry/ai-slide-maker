import 'dart:math';
import 'dart:developer' as developer;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/data/text_properties.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide1Editor extends StatefulWidget {
  SectionedSlide1Editor(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size,
      required this.index,
      required this.isEditViewOpen});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;
  int index;
  bool isEditViewOpen;

  @override
  State<SectionedSlide1Editor> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide1Editor> {
  final PresentationEditCtl controller = Get.find();

  int bgIndex = 0;
  RxDouble titleFontSize = 0.0.obs;
  late Worker fontSizeWorker;
  late Worker fontWeightWorker;
  late Worker fontColorWorker;
  late Worker currentTextWorker;
  int i = 0;
  late Worker resetPropertiesWorker;
  late Worker switchViewStateWorker;
  late Worker isSelectedCheckWorker;

  Future<void> initializeSlideFontSize() async {
    controller.slideTitlesTextProperties[widget.index].fontSize = 0.050;
    // controller.slideTitlesTextProperties[widget.index].fontColor = Color(widget.slidePallet.bigTitleTColor);

    for (i = 0;
        i < controller.slideSectionContentsTextProperties[widget.index].length;
        i++) {
      if (controller
              .slideSectionContentsTextProperties[widget.index][i].fontSize ==
          0) {
        controller.slideSectionContentsTextProperties[widget.index][i]
            .fontSize = 0.014;
//  controller.slideSectionContentsTextProperties[widget.index][i].fontColor = Color(widget.slidePallet.bigTitleTColor);

        if (widget.mySlide.slideSections[i].sectionContent != null) {
          String text = widget.mySlide.slideSections[i].sectionContent ?? "";
          if (text.length <= 140) {
            controller.slideSectionContentsTextProperties[widget.index][i]
                .fontSize = 0.018;
          } else if (text.length <= 180) {
            controller.slideSectionContentsTextProperties[widget.index][i]
                .fontSize = 0.016;
          } else if (text.length <= 220) {
            controller.slideSectionContentsTextProperties[widget.index][i]
                .fontSize = 0.0145;
          }
        }
      }

      if (controller
              .slideSectionHeadersTextProperties[widget.index][i].fontSize ==
          0) {
        controller.slideSectionHeadersTextProperties[widget.index][i].fontSize =
            0.014;
        // controller.slideSectionHeadersTextProperties[widget.index][i].fontColor = Color(widget.slidePallet.bigTitleTColor);

        if (widget.mySlide.slideSections[i].sectionHeader != null) {
          String text = widget.mySlide.slideSections[i].sectionHeader ?? "";
          if (text.length <= 140) {
            controller.slideSectionHeadersTextProperties[widget.index][i]
                .fontSize = 0.018;
          } else if (text.length <= 180) {
            controller.slideSectionHeadersTextProperties[widget.index][i]
                .fontSize = 0.016;
          } else if (text.length <= 220) {
            controller.slideSectionHeadersTextProperties[widget.index][i]
                .fontSize = 0.0145;
          }
          developer.log("Content Length ${text.length}");
        }
      }
    }
    developer.log("Completed initializing the header and content Font size");
  }

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    // gestureDetectorOnInit();
    setState(() {
      initializeSlideFontSize();
      controller.currentPallet = widget.slidePallet;
      controller.initializeSlidePalletAndController();

      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length - 1);
      print("BG Index: $bgIndex");
      print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });

    print("initState Called");
    fontSizeWorker = ever(controller.currentFontSize, (_) {
      setState(() {});
    });
    fontWeightWorker = ever(controller.currentFontWeightDouble, (_) {
      setState(() {});
    });
    fontColorWorker = ever(controller.currentFontColor, (_) {
      setState(() {});
    });
    switchViewStateWorker = ever(controller.switchViewState, (_) {
      developer.log(
          "widget font size slide titles : ${widget.slidePallet.slideTitlesTextProperties![widget.index].fontSize!}");
      setState(() {});
    });
    currentTextWorker = ever(controller.currentText, (_) {
      setState(() {});
    });
    isSelectedCheckWorker = ever(controller.isSelectedCheck, (_) {
      developer.log(
          "clicked on the text ${controller.isSelectedSlideTitle[widget.index]}");

      setState(() {});
    });
    resetPropertiesWorker = ever(controller.resetProperties, (_) {
      setState(() {
        developer.log("resetProperties");
        initializeSlideFontSize();
        controller.initializeSlidePalletAndController();
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the ever listeners when the widget is disposed
    fontSizeWorker.dispose();
    fontWeightWorker.dispose();
    fontColorWorker.dispose();
    currentTextWorker.dispose();
    resetPropertiesWorker.dispose();
    switchViewStateWorker.dispose();
    isSelectedCheckWorker.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    controller.isEditViewOpen.value = widget.isEditViewOpen;
    titleFontSize.value = widget.size.width *
        (controller.switchViewState.value
            ? widget
                .slidePallet.slideTitlesTextProperties![widget.index].fontSize!
            : controller.slideTitlesTextProperties[widget.index].fontSize!);
    developer.log("This is index in slide 1 ${widget.index}");
    developer.log(
        " This is the title color in slide 1: ${controller.slideTitlesTextProperties[widget.index].fontColor!}");
    developer.log(
        " This is the title Size slide 1: ${controller.slideTitlesTextProperties[widget.index].fontSize!}");
    developer.log(
        " This is the title Weight slide 1: ${controller.slideTitlesTextProperties[widget.index].fontWeight!}");

    return Container(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        children: [
          Container(
              width: widget.size.width,
              height: widget.size.height,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "${widget.slidePallet.imageList[bgIndex]}",
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                      vertical: SizeConfig.blockSizeVertical * 6),
                  child: Container(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
              //  Image.asset(widget.slidePallet.imageList[bgIndex],
              //     fit: BoxFit.fill),
              ),
          Container(
            width: widget.size.width,
            height: widget.size.height,
            padding: EdgeInsets.symmetric(
                horizontal: widget.size.width * 0.02,
                vertical: widget.size.height * 0.02),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Column(
              children: [
                verticalSpace(widget.size.height * 0.00),
                Container(
                  alignment: Alignment.bottomLeft,
                  // width: widget.size.width,
                  // height: widget.size.height * 0.2,
                  child: controller.textForTitleWithGestureDetector(
                      controller.slideTitles,
                      widget.index,
                      controller.slideTitlesTextProperties,
                      controller.myEditedPresentation,
                      titleFontSize,
                      widget.slidePallet),
                ),
                verticalSpace(widget.size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i < widget.mySlide.slideSections.length;
                        i += 1)
                      Expanded(
                        flex: 1,
                        child: _slideSection(i),
                      ),
                  ],
                )
              ],
            ),
          ),
          RevenueCatService().currentEntitlement.value == Entitlement.free
              ? Container(
                  width: widget.size.width * 1,
                  height: widget.size.height * 1,
                  child: WaterMark(
                      fontSize: widget.size.width * 0.025,
                      size: widget.size,
                      color: Color(widget.slidePallet.bigTitleTColor)),
                )
              : Container()
        ],
      ),
    );
  }

  Container _slideSection(int i) {
    late RxDouble sectionContentFontSize = 0.0.obs;
    late RxDouble sectionHeaderFontSize = 0.0.obs;
    sectionHeaderFontSize.value = widget.size.width *
        (controller.switchViewState.value
            ? widget.slidePallet
                .slideSectionHeadersTextProperties![widget.index][i].fontSize!
            : controller
                .slideSectionHeadersTextProperties[widget.index][i].fontSize!);
    sectionContentFontSize.value = widget.size.width *
        (controller.switchViewState.value
            ? widget.slidePallet
                .slideSectionContentsTextProperties![widget.index][i].fontSize!
            : controller
                .slideSectionContentsTextProperties[widget.index][i].fontSize!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.008),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.textForSlideSectionHeaderWithGestureDetector(
              controller.slideSectionHeaders,
              widget.index,
              i,
              controller.slideSectionHeadersTextProperties,
              controller.myEditedPresentation,
              sectionHeaderFontSize,
              widget.slidePallet),
          verticalSpace(widget.size.height * 0.01),
          controller.textForSlideSectionContentWithGestureDetector(
              controller.slideSectionContents,
              widget.index,
              i,
              controller.slideSectionContentsTextProperties,
              controller.myEditedPresentation,
              sectionContentFontSize,
              widget.slidePallet),
        ],
      ),
    );
  }
}
