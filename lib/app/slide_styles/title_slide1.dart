import 'dart:math';
import 'dart:developer' as developer;

import 'package:cached_network_image/cached_network_image.dart';
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
      titleFontSize = widget.mySlide.slideSections[0].memoryImage != null ||
              widget.mySlide.slideSections[0].imageReference != null
          ? widget.size.width * 0.05
          : widget.size.width * 0.06;

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
                      Text(
                        widget.mySlide.slideTitle,
                        style: TextStyle(
                            fontSize: titleFontSize,
                            color: Color(widget.slidePallet.bigTitleTColor)),
                        // style: widget.slidePallet.bigTitleTStyle
                        //     .copyWith(fontSize: titleFontSize),
                      ),
                      verticalSpace(widget.size.width * 0.01),
                      Text(
                        widget.mySlide.slideSections[0].sectionContent!,
                        style: TextStyle(
                            fontSize: widget.size.width * 0.02,
                            color: Color(widget.slidePallet.bigTitleTColor)),
                        // style: widget.slidePallet.bigTitleTStyle
                        //     .copyWith(fontSize: widget.size.width * 0.03),
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
