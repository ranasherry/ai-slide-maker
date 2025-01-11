import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide5 extends StatefulWidget {
  SectionedSlide5(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<SectionedSlide5> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide5> {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.mySlide.slideTitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: widget.size.width * 0.050,
                      color: Color(widget.slidePallet.bigTitleTColor)),
                ),
                SizedBox(height: widget.size.height * 0.1),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0;
                            i < widget.mySlide.slideSections.length;
                            i += 1)
                          Expanded(
                            flex: 1,
                            child: grid_item(
                              title: widget
                                      .mySlide.slideSections[i].sectionHeader ??
                                  "",
                              description: widget.mySlide.slideSections[i]
                                      .sectionContent ??
                                  "",
                            ),
                          ),
                      ],
                    ),
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

  Row grid_item({required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_box_outline_blank_rounded,
            size: widget.size.height * 0.07,
            color: Color(widget.slidePallet.bigTitleTColor)),
        SizedBox(
          width: widget.size.width * 0.02,
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: widget.size.width * 0.4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: widget.size.height * 0.05,
                    color: Color(
                      widget.slidePallet.bigTitleTColor,
                    ),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: widget.size.height * 0.01),
              Text(
                description,
                style: TextStyle(
                    fontSize: widget.size.height * 0.04,
                    color: Color(widget.slidePallet.sectionHeaderTColor)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
