import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide6 extends StatefulWidget {
  SectionedSlide6(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<SectionedSlide6> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide6> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.mySlide.slideTitle,
                  style: TextStyle(
                      fontSize: widget.size.width * 0.050,
                      color: Color(widget.slidePallet.bigTitleTColor)),
                ),
                SizedBox(height: 20),
                for (int i = 0; i < widget.mySlide.slideSections.length; i += 1)
                  _buildNumberedItem(
                    title: widget.mySlide.slideSections[i].sectionHeader ?? "",
                    description:
                        widget.mySlide.slideSections[i].sectionContent ?? "",
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

  Widget _buildNumberedItem(
      {required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number inside the black container
        Container(
          height: widget.size.height * 0.1,
          width: widget.size.width * 0.04,
          decoration: BoxDecoration(
            color: Color(widget.slidePallet.bigTitleTColor),
            borderRadius: BorderRadius.circular(widget.size.height * 0.03),
          ),
        ),
        horizontalSpace(widget.size.width * 0.04),

        // Title and description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: widget.size.height * 0.05,
                      color: Color(widget.slidePallet.bigTitleTColor),
                      fontWeight: FontWeight.bold)),
              verticalSpace(widget.size.height * 0.02),
              Text(description,
                  style: TextStyle(
                      fontSize: widget.size.height * 0.04,
                      color: Color(widget.slidePallet.bigTitleTColor))),
            ],
          ),
        ),
      ],
    );
  }
}
