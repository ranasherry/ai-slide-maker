import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide1 extends StatefulWidget {
  SectionedSlide1(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<SectionedSlide1> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide1> {
  int bgIndex = 0;

  @override
  // ignore: must_call_super
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
            child: Column(
              children: [
                verticalSpace(widget.size.height * 0.00),
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
                      color: widget.slidePallet.bigTitleTStyle.color ??
                          Colors.white),
                )
              : Container()
        ],
      ),
    );
  }

  Container _slideSection(int i) {
    double sectionFontSize = widget.size.width * 0.014;
    if (widget.mySlide.slideSections[i].sectionContent != null) {
      String text = widget.mySlide.slideSections[i].sectionContent ?? "";

      if (text.length <= 140) {
        sectionFontSize = widget.size.width * 0.018;
      } else if (text.length <= 180) {
        sectionFontSize = widget.size.width * 0.016;
      } else if (text.length <= 220) {
        sectionFontSize = widget.size.width * 0.0145;
      }
      developer.log("Content Length ${text.length}");
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mySlide.slideSections[i].sectionHeader ?? '',
            style: widget.mySlide.slideSections[i].sectionHeader != null
                ? widget.slidePallet.bigTitleTStyle
                    .copyWith(fontSize: sectionFontSize * 2)
                : widget.slidePallet.bigTitleTStyle,
          ),
          verticalSpace(widget.size.height * 0.04),
          Text(
            widget.mySlide.slideSections[i].sectionContent ?? '',
            style: widget.mySlide.slideSections[i].sectionContent != null
                ? widget.slidePallet.bigTitleTStyle
                    .copyWith(fontSize: sectionFontSize)
                : widget.slidePallet.bigTitleTStyle,
          ),
        ],
      ),
    );
  }
}
