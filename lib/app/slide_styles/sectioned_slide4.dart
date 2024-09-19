import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SectionedSlide4 extends StatefulWidget {
  SectionedSlide4(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<SectionedSlide4> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide4> {
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
                vertical: widget.size.height * 0.02),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mySlide.slideTitle,
                  style: TextStyle(
                      fontSize: widget.size.width * 0.060,
                      color: Color(widget.slidePallet.bigTitleTColor)),
                ),
                verticalSpace(widget.size.height * 0.07),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0;
                            i < widget.mySlide.slideSections.length;
                            i += 1)
                          timeline(
                            title:
                                widget.mySlide.slideSections[i].sectionHeader ??
                                    "",
                            description: widget
                                    .mySlide.slideSections[i].sectionContent ??
                                "",
                          ),
                      ],
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

  Widget timeline({required String title, required String description}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size.height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: widget.size.height * 0.25,
            width: widget.size.width * 0.1,
            child: TimelineTile(
              beforeLineStyle: LineStyle(
                color: Color(widget.slidePallet.bigTitleTColor),
              ),
              indicatorStyle: IndicatorStyle(
                  color: Color(widget.slidePallet.bigTitleTColor)),
              // isFirst: true,
            ),
          ),
          SizedBox(
            width: widget.size.width * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: widget.size.height * 0.05,
                      color: Color(widget.slidePallet.bigTitleTColor))),
              Container(
                width: widget.size.width * 0.7,
                child: Text(description,
                    style: TextStyle(
                        fontSize: widget.size.height * 0.04,
                        color: Color(widget.slidePallet.sectionHeaderTColor))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
