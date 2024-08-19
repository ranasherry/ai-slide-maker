import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/remoteconfig_services.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/clip_shapes/hexagon_clipper.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class TitleSlide1 extends StatefulWidget {
  TitleSlide1(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<TitleSlide1> createState() => __TitleSlide1State();
}

class __TitleSlide1State extends State<TitleSlide1> {
  int bgIndex = 0;

  double titleFontSize = 34;

  @override
  // ignore: must_call_super
  initState() {
    setState(() {
      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length);
      titleFontSize = widget.mySlide.slideSections[0].memoryImage != null
          ? widget.size.height * 0.10
          : widget.size.height * 0.15;

      print("Title Font Size: $titleFontSize");
      print("BG Index: $bgIndex");
      print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });
    // print(
    //     "initState Called: Image Bytes: ${widget.mySlide.slideSections[0].memoryImage}");
  }

  @override
  Widget build(BuildContext context) {
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
                vertical: widget.size.height * 0.04),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: widget.mySlide.slideSections[0].memoryImage != null
                      ? widget.size.width * 0.5
                      : widget.size.width * 0.9,
                  child: Column(
                    children: [
                      verticalSpace(widget.size.height * 0.1),
                      Text(
                        widget.mySlide.slideTitle,
                        style: widget.slidePallet.bigTitleTStyle
                            .copyWith(fontSize: titleFontSize),
                      ),
                      verticalSpace(widget.size.height * 0.05),
                      Text(
                        widget.mySlide.slideSections[0].sectionContent!,
                        style: widget.slidePallet.bigTitleTStyle
                            .copyWith(fontSize: widget.size.width * 0.03),
                      ),
                    ],
                  ),
                ),
                widget.mySlide.slideSections[0].memoryImage != null
                    ? Container(
                        width: widget.size.width * 0.45,
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
                      color: widget.slidePallet.bigTitleTStyle.color ??
                          Colors.white),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _ImageWidget() {
    return ClipPath(
      clipper: HexagonClipper(),
      child: Image.memory(
        widget.mySlide.slideSections[0].memoryImage!,
        width: widget.size.width * 0.3,
        height: widget.size.width * 0.3,
        fit: BoxFit.fill,
      ),
    );
  }
}
