import 'dart:math';
import 'dart:developer' as developer;
import 'package:cached_network_image/cached_network_image.dart';
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

class SectionedSlide2Editor extends StatefulWidget {
  SectionedSlide2Editor(
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
  State<SectionedSlide2Editor> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide2Editor> {
  final PresentationEditCtl controller = Get.find();
  late Worker fontSizeWorker;
  late Worker fontWeightWorker;
  late Worker fontColorWorker;
  RxDouble titleFontSize = 0.0.obs;
  List<RxDouble> contentFontSize = [0.0.obs, 0.0.obs];
  List<RxDouble> headerFontSize = [0.0.obs, 0.0.obs];
  late Worker slideTitleWorker;
  late Worker resetPropertiesWorker;
  late Worker switchViewStateWorker;
  int i = 0;

  int bgIndex = 0;
  Future<void> initializeSlideFontSize() async {
    controller.slideTitlesTextProperties[widget.index].fontSize = 0.040;
    controller.slideSectionHeadersTextProperties[widget.index][0].fontSize =
        0.035;
    controller.slideSectionContentsTextProperties[widget.index][0].fontSize =
        0.018;
    controller.slideSectionHeadersTextProperties[widget.index][1].fontSize =
        0.035;
    controller.slideSectionContentsTextProperties[widget.index][1].fontSize =
        0.018;
  }

  @override
  void initState() {
    super.initState();
// if(widget.isEditViewOpen){

// }else{

// }
    setState(() {
      initializeSlideFontSize();

      //    _slideTitle = TextEditingController(text : widget.mySlide.slideTitle);
      //    _sectionHeader0 = TextEditingController(text :widget.mySlide.slideSections[0].sectionHeader ?? '' );
      // _sectionContent0 = TextEditingController(text :  widget.mySlide.slideSections[0].sectionContent ?? '');
      //  _sectionHeader1 = TextEditingController(text : widget.mySlide.slideSections[1].sectionHeader ?? '');
      //   _sectionContent1 = TextEditingController(text : widget.mySlide.slideSections[1].sectionContent ?? '');

      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length);
      controller.currentPallet = widget.slidePallet;
      controller.initializeSlidePalletAndController();
      // gestureDetectorOnInit();

      print("BG Index: $bgIndex");
      print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });
    // ever(controller.currentFontSize, (_) {
    //     developer.log("check 1 Title Font value:${controller.slideTitlesTextProperties[widget.index].fontSize}");
    //     developer.log("check 1.1 Current Font value:${controller.currentFontSize.fontSize}");
    //   setState(() {}); // Update the UI when the value changes
    // });

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
    slideTitleWorker = ever(controller.currentText, (_) {
      setState(() {});
    });
    switchViewStateWorker = ever(controller.switchViewState, (_) {
      setState(() {
        developer.log("switch working");
      });
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
    slideTitleWorker.dispose();
    resetPropertiesWorker.dispose();
    switchViewStateWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.isEditViewOpen.value = widget.isEditViewOpen;
    // controller.initializeSlidesTextController();
    // controller.initializeSlidesFontList();
    titleFontSize.value = widget.size.width *
        (controller.switchViewState.value
            ? widget
                .slidePallet.slideTitlesTextProperties![widget.index].fontSize!
            : controller.slideTitlesTextProperties[widget.index].fontSize!);
    headerFontSize[0].value = widget.size.width *
        (controller.switchViewState.value
            ? widget.slidePallet
                .slideSectionHeadersTextProperties![widget.index][0].fontSize!
            : controller
                .slideSectionHeadersTextProperties[widget.index][0].fontSize!);

    contentFontSize[0].value = widget.size.width *
        (controller.switchViewState.value
            ? widget.slidePallet
                .slideSectionContentsTextProperties![widget.index][0].fontSize!
            : controller
                .slideSectionContentsTextProperties[widget.index][0].fontSize!);

    headerFontSize[1].value = widget.size.width *
        (controller.switchViewState.value
            ? widget.slidePallet
                .slideSectionHeadersTextProperties![widget.index][1].fontSize!
            : controller
                .slideSectionHeadersTextProperties[widget.index][1].fontSize!);

    contentFontSize[1].value = widget.size.width *
        (controller.switchViewState.value
            ? widget.slidePallet
                .slideSectionContentsTextProperties![widget.index][1].fontSize!
            : controller
                .slideSectionContentsTextProperties[widget.index][1].fontSize!);

    developer.log("This is index in slide 2 ${widget.index}");
    developer.log(
        " This is the title color in slide 2: ${controller.slideTitlesTextProperties[widget.index].fontColor!}");
    developer.log(
        " This is the title Size slide 2: ${controller.slideTitlesTextProperties[widget.index].fontSize!}");
    developer.log(
        " This is the title Weight slide 2: ${controller.slideTitlesTextProperties[widget.index].fontWeight!}");

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
              // Image.asset(
              //   widget.slidePallet.imageList[bgIndex],
              //   fit: BoxFit.fill,
              // ),
              ),
          Container(
            width: widget.size.width,
            height: widget.size.height,
            padding: EdgeInsets.symmetric(
                horizontal: widget.size.width * 0.02,
                vertical: widget.size.height * 0.02),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(widget.size.height * 0.0),
                Container(
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
                // verticalSpace(widget.size.height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.mySlide.slideSections.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller
                                  .textForSlideSectionHeaderWithGestureDetector(
                                      controller.slideSectionHeaders,
                                      widget.index,
                                      0,
                                      controller
                                          .slideSectionHeadersTextProperties,
                                      controller.myEditedPresentation,
                                      headerFontSize[0],
                                      widget.slidePallet),
                              // verticalSpace(widget.size.height * 0.01),
                              controller
                                  .textForSlideSectionContentWithGestureDetector(
                                      controller.slideSectionContents,
                                      widget.index,
                                      0,
                                      controller
                                          .slideSectionContentsTextProperties,
                                      controller.myEditedPresentation,
                                      contentFontSize[0],
                                      widget.slidePallet),
                            ],
                          )
                        : Container(),
                    verticalSpace(widget.size.height * 0.02),
                    widget.mySlide.slideSections.length >= 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller
                                  .textForSlideSectionHeaderWithGestureDetector(
                                      controller.slideSectionHeaders,
                                      widget.index,
                                      1,
                                      controller
                                          .slideSectionHeadersTextProperties,
                                      controller.myEditedPresentation,
                                      headerFontSize[1],
                                      widget.slidePallet),
                              // verticalSpace(widget.size.height * 0.01),
                              controller
                                  .textForSlideSectionContentWithGestureDetector(
                                      controller.slideSectionContents,
                                      widget.index,
                                      1,
                                      controller
                                          .slideSectionContentsTextProperties,
                                      controller.myEditedPresentation,
                                      contentFontSize[1],
                                      widget.slidePallet),
                            ],
                          )
                        : Container()
                  ],
                ),
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
}
