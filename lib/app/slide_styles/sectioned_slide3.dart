import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide3 extends StatefulWidget {
  SectionedSlide3(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<SectionedSlide3> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide3> {
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
              children: [
                Center(
                  child: Container(
                    // height: widget.size.height,
                    width: widget.size.width,

                    // decoration: BoxDecoration(
                    //     color: Color(0xFF3D3D3D),
                    //     borderRadius: BorderRadius.circular(
                    //         SizeConfig.blockSizeHorizontal * 2)),
                    child: Padding(
                      padding: EdgeInsets.all(widget.size.width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.mySlide.slideTitle,
                            style: TextStyle(
                                fontSize: widget.size.width * 0.050,
                                color:
                                    Color(widget.slidePallet.bigTitleTColor)),
                            // style: GoogleFonts.merriweather(
                            //   color: Color(widget.slidePallet
                            //       .bigTitleTColor), // Light peach text color
                            //   fontSize: widget.size.height * 0.050,
                            //   fontWeight: FontWeight.bold,
                            // ),
                          ),
                          verticalSpace(widget.size.height * 0.1),
                          for (int i = 0;
                              i < widget.mySlide.slideSections.length;
                              i += 1)
                            _buildBulletPoint(
                              title: widget
                                      .mySlide.slideSections[i].sectionHeader ??
                                  "",
                              description: widget.mySlide.slideSections[i]
                                      .sectionContent ??
                                  "",
                            ),
                          // _buildBulletPoint(
                          //   title: "Transfer learning",
                          //   description:
                          //       "Leveraging pre-trained models for new tasks.",
                          // ),
                          // _buildBulletPoint(
                          //   title: "Explainable AI",
                          //   description:
                          //       "Models designed to provide reasoning behind their decisions.",
                          // ),
                        ],
                      ),
                    ),
                  ),
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

  Widget _buildBulletPoint(
      {required String title, required String description}) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.size.height * 0.07),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: widget.size.height * 0.04,
            color: Color(widget.slidePallet.bigTitleTColor),
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "$title: ",
                      style: TextStyle(
                          fontSize: widget.size.height * 0.04,
                          color: Color(widget.slidePallet.bigTitleTColor))),
                  TextSpan(
                      text: description,
                      style: TextStyle(
                          fontSize: widget.size.height * 0.03,
                          color:
                              Color(widget.slidePallet.sectionDescTextColor))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
