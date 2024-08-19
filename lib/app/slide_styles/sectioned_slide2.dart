import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide2 extends StatefulWidget {
  SectionedSlide2(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<SectionedSlide2> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide2> {
  int bgIndex = 0;
  initState() {
    setState(() {
      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length);
      print("BG Index: $bgIndex");
      print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });
    print("initState Called");
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
            child: Image.asset(
              widget.slidePallet.imageList[bgIndex],
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: widget.size.width,
            height: widget.size.height,
            padding: EdgeInsets.symmetric(
                horizontal: widget.size.width * 0.02,
                vertical: widget.size.height * 0.04),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(widget.size.height * 0.0),
                Container(
                  width: widget.size.width,
                  // height: widget.size.height * 0.2,
                  child: Text(
                    widget.mySlide.slideTitle,
                    // overflow: TextOverflow.ellipsis,
                    style: widget.slidePallet.bigTitleTStyle
                        .copyWith(fontSize: widget.size.width * 0.050),
                  ),
                ),
                verticalSpace(widget.size.height * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.mySlide.slideSections.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mySlide.slideSections[0].sectionHeader ??
                                    '',
                                style: widget.mySlide.slideSections[0]
                                            .sectionHeader !=
                                        null
                                    ? widget.slidePallet.bigTitleTStyle
                                        .copyWith(
                                            fontSize: widget.size.width * 0.035)
                                    : widget.slidePallet.bigTitleTStyle,
                              ),
                              verticalSpace(widget.size.height * 0.01),
                              Text(
                                widget.mySlide.slideSections[0]
                                        .sectionContent ??
                                    '',
                                style: widget.mySlide.slideSections[0]
                                            .sectionContent !=
                                        null
                                    ? widget.slidePallet.bigTitleTStyle
                                        .copyWith(
                                            fontSize: widget.size.width * 0.018)
                                    : widget.slidePallet.bigTitleTStyle,
                              ),
                            ],
                          )
                        : Container(),
                    verticalSpace(widget.size.height * 0.03),
                    widget.mySlide.slideSections.length >= 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mySlide.slideSections[1].sectionHeader ??
                                    '',
                                style: widget.mySlide.slideSections[1]
                                            .sectionHeader !=
                                        null
                                    ? widget.slidePallet.bigTitleTStyle
                                        .copyWith(
                                            fontSize: widget.size.width * 0.035)
                                    : widget.slidePallet.bigTitleTStyle,
                              ),
                              verticalSpace(widget.size.height * 0.01),
                              Text(
                                widget.mySlide.slideSections[1]
                                        .sectionContent ??
                                    '',
                                style: widget.mySlide.slideSections[1]
                                            .sectionContent !=
                                        null
                                    ? widget.slidePallet.bigTitleTStyle
                                        .copyWith(
                                            fontSize: widget.size.width * 0.018)
                                    : widget.slidePallet.bigTitleTStyle,
                              ),
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
                      color: widget.slidePallet.bigTitleTStyle.color ??
                          Colors.white),
                )
              : Container()
        ],
      ),
    );
  }
}
