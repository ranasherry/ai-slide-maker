import 'dart:math';
import 'dart:developer' as developer;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/services/remoteconfig_services.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/clip_shapes/hexagon_clipper.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class TitleSlide1Editor extends StatefulWidget {
  TitleSlide1Editor(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size,
      required this.index,
      required this.isReadOnly});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;
  int index;
  bool isReadOnly;

  @override
  State<TitleSlide1Editor> createState() => __TitleSlide1State();
}

class __TitleSlide1State extends State<TitleSlide1Editor> {
  final PresentationEditCtl controller = Get.find();
  int bgIndex = 0;
  late TextEditingController _slideTitle; 
  late TextEditingController _sectionContent0; 
  String slideTitleValue = "";
  String sectionContent0Value = "";
  double titleFontSize = 34;
  Rx<double> _titleFontSize = 0.0.obs;
  Rx<double> _sectionContentFontSize = 0.0.obs;

  @override
  // ignore: must_call_super
  initState() {
    setState(() {
      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length);
      titleFontSize = widget.mySlide.slideSections[0].memoryImage != null ||
              widget.mySlide.slideSections[0].imageReference != null
          ? widget.size.width * 0.05
          : widget.size.width * 0.06;

      _titleFontSize.value = titleFontSize;
      _sectionContentFontSize.value = widget.size.width * 0.02;

          _slideTitle = TextEditingController(text : widget.mySlide.slideTitle);
          _sectionContent0 = TextEditingController(text : widget.mySlide.slideSections[0].sectionContent! );

        // _slideTitle.addListener(() {
        //   setState(() {
        //     slideTitleValue = _slideTitle.text;
        //     controller.myEditedPresentation.value.slides[widget.index].slideTitle = slideTitleValue;
        //     print("$slideTitleValue");
        //   });
        // });
        //  _sectionContent0.addListener(() {
        //   setState(() {
        //     sectionContent0Value = _sectionContent0.text;
        //     controller.myEditedPresentation.value.slides[widget.index].slideSections[0].sectionContent = sectionContent0Value;
        //   });
        // });
      print("Title Font Size: $titleFontSize");
      print("BG Index: $bgIndex");
      print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });
    // print(
    //     "initState Called: Image Bytes: ${widget.mySlide.slideSections[0].memoryImage}");
    print(
        "initState Called: Image reference: ${widget.mySlide.slideSections[0].imageReference}");
  }

  @override
  Widget build(BuildContext context) {
    controller.initializeSlidesTextController();
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        children: [
          Container(
            width: widget.size.width,
            height: widget.size.height,
            child: Image.asset(widget.slidePallet.imageList[bgIndex],
                fit: BoxFit.fill),
          ),
          Container(
            width: widget.size.width,
            height: widget.size.height,
            padding: EdgeInsets.symmetric(
                horizontal: widget.size.width * 0.02,
                vertical: widget.size.width * 0.04),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: widget.mySlide.slideSections[0].memoryImage != null ||
                          widget.mySlide.slideSections[0].imageReference != null
                      ? widget.size.width * 0.5
                      : widget.size.width * 0.9,
                  child: Column(
                    children: [
                      verticalSpace(widget.size.height * 0.00),
                      IgnorePointer(
                        ignoring: widget.isReadOnly,
                        child: EditableText(
                    cursorColor:  Colors.black,
                    backgroundCursorColor: Colors.white,
                    focusNode: FocusNode(),
                        // decoration: InputDecoration(
                        //       border: InputBorder.none
                        //     ),
                            maxLines: null,
                            readOnly: widget.isReadOnly,
                        controller:  controller.slideTitles[widget.index],
                        onChanged: (value){
                        controller.myEditedPresentation.value.slides[widget.index].slideTitle = value;
                        },
                        style: TextStyle(
                            fontSize: _titleFontSize.value,
                            color: Color(widget.slidePallet.bigTitleTColor)),
                        // style: widget.slidePallet.bigTitleTStyle
                        //     .copyWith(fontSize: titleFontSize),
                            )
                      ),
                      verticalSpace(widget.size.width * 0.01),
                      IgnorePointer(
                        ignoring: widget.isReadOnly,
                        child: EditableText(
                    cursorColor:  Colors.black,
                    backgroundCursorColor: Colors.white,
                    focusNode: FocusNode(),

                        // decoration: InputDecoration(
                        //       border: InputBorder.none
                        //     ),
                            maxLines: null,
                            readOnly: widget.isReadOnly,
                        controller : controller.slideSectionContents[widget.index][0],
                        onChanged: (value){
                          controller.myEditedPresentation.value.slides[widget.index].slideSections[0].sectionContent = value;
                        },
                        style: TextStyle(
                            fontSize: widget.size.width * 0.02,
                            color: Color(widget.slidePallet.bigTitleTColor)),
                        // style: widget.slidePallet.bigTitleTStyle
                        //     .copyWith(fontSize: widget.size.width * 0.03),
                              )
                      ),
                    ],
                  ),
                ),
                widget.mySlide.slideSections[0].memoryImage != null ||
                        widget.mySlide.slideSections[0].imageReference != null
                    ? Container(
                        width: widget.size.width * 0.42,
                        height: widget.size.height,
                        child: Center(child: _ImageWidget()))
                    : Container(),
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

  // Widget _ImageWidget() {
  //   return ClipPath(
  //     clipper: HexagonClipper(),
  //     child: Image.memory(
  //       widget.mySlide.slideSections[0].memoryImage!,
  //       width: widget.size.width * 0.3,
  //       height: widget.size.width * 0.3,
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }

  Widget _ImageWidget() {
    if (widget.mySlide.slideSections[0].imageReference != null) {
      return ClipPath(
        clipper: HexagonClipper(),
        child: CachedNetworkImage(
          imageUrl: "${widget.mySlide.slideSections[0].imageReference!}",
          // imageUrl: "http://aqibsiddiqui.com/images/technology5.jpg",
          width: widget.size.width * 0.3,
          height: widget.size.width * 0.3,
          fit: BoxFit.fill,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            developer.log("Error Cached Network: $error");
            return Icon(Icons.error);
          },
        ),
      );
    } else if (widget.mySlide.slideSections[0].memoryImage != null) {
      return ClipPath(
        clipper: HexagonClipper(),
        child: Image.memory(
          widget.mySlide.slideSections[0].memoryImage!,
          width: widget.size.width * 0.3,
          height: widget.size.width * 0.3,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Container(); // Handle the case where no image is available
    }
  }
}
