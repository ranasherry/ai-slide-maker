import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide7 extends StatefulWidget {
  SectionedSlide7(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;

  @override
  State<SectionedSlide7> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide7> {
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
              children: [
                Center(
                  child: Container(
                    // height: widget.size.height,
                    width: widget.size.width,

                    // decoration: BoxDecoration(
                    //     color: Color(0xFF3D3D3D),
                    //     borderRadius: BorderRadius.circular(
                    //         SizeConfig.blockSizeHorizontal * 2)),
                    child: Column(
                      children: [
                        Text(
                          widget.mySlide.slideTitle,
                          style: TextStyle(
                              fontSize: widget.size.width * 0.050,
                              color: Color(widget.slidePallet.bigTitleTColor)),
                        ),
                        verticalSpace(widget.size.height * 0.01),
                        widget.mySlide.slideSections.length > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.mySlide.slideSections.length > 0)
                                    box_container(
                                      title: widget.mySlide.slideSections[0]
                                              .sectionHeader ??
                                          "",
                                      description: widget
                                              .mySlide
                                              .slideSections[0]
                                              .sectionContent ??
                                          "",
                                    ),
                                  if (widget.mySlide.slideSections.length > 1)
                                    box_container(
                                      title: widget.mySlide.slideSections[1]
                                              .sectionHeader ??
                                          "",
                                      description: widget
                                              .mySlide
                                              .slideSections[1]
                                              .sectionContent ??
                                          "",
                                    ),
                                ],
                              )
                            : Container(),

                        verticalSpace(widget.size.height * 0.02),

                        widget.mySlide.slideSections.length > 2
                            ? Container(
                                height: widget.size.height * 0.30,
                                width: widget.size.width * 0.9,
                                color: Colors.amber,
                                child: Column(
                                  children: [
                                    Text(
                                      widget.mySlide.slideSections[2]
                                              .sectionHeader ??
                                          "",
                                      style: TextStyle(
                                        fontSize: widget.size.height * 0.05,
                                        color: Color(
                                            widget.slidePallet.bigTitleTColor),
                                      ),
                                    ),
                                    verticalSpace(widget.size.height * 0.02),
                                    Text(
                                      widget.mySlide.slideSections[2]
                                              .sectionContent ??
                                          "",
                                      style: TextStyle(
                                        fontSize: widget.size.height * 0.04,
                                        color: Color(widget
                                            .slidePallet.sectionDescTextColor),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),

                        // widget.mySlide.slideSections.length > 0
                        //     ? Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           // for (int i = 0;
                        //           //     i < widget.mySlide.slideSections.length;
                        //           //     i += 1)
                        //           box_container(
                        //             title: widget.mySlide.slideSections[0]
                        //                     .sectionHeader ??
                        //                 "",
                        //             description: widget
                        //                     .mySlide
                        //                     .slideSections[0]
                        //                     .sectionContent ??
                        //                 "",
                        //           ),

                        //           box_container(
                        //             title: widget.mySlide.slideSections[1]
                        //                     .sectionHeader ??
                        //                 "",
                        //             description: widget
                        //                     .mySlide
                        //                     .slideSections[1]
                        //                     .sectionContent ??
                        //                 "",
                        //           ),
                        //         ],
                        //       )
                        //     : Container(),
                        // verticalSpace(widget.size.height * 0.05),
                        // widget.mySlide.slideSections.length > 2
                        //     ? Container(
                        //         height: widget.size.height * 0.30,
                        //         width: widget.size.width * 02,
                        //         // color: Colors.grey,
                        //         child: Container(
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                   widget.mySlide.slideSections[2]
                        //                           .sectionHeader ??
                        //                       "",
                        //                   style: TextStyle(
                        //                       fontSize:
                        //                           widget.size.height * 0.05,
                        //                       color: Color(widget.slidePallet
                        //                           .bigTitleTColor))),
                        //               verticalSpace(
                        //                   widget.size.height * 0.02),
                        //               Text(
                        //                   widget.mySlide.slideSections[2]
                        //                           .sectionContent ??
                        //                       "",
                        //                   style: TextStyle(
                        //                       fontSize:
                        //                           widget.size.height * 0.04,
                        //                       color: Color(widget.slidePallet
                        //                           .sectionDescTextColor)))
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     : Container()
                      ],
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

  Container box_container(
      {required String title, required String description}) {
    return Container(
      height: widget.size.height * 0.42,
      width: widget.size.width * 0.4,
      // color: Colors.grey,
      child: Column(
        children: [
          Text(
            "$title: ",
            style: TextStyle(
                fontSize: widget.size.height * 0.05,
                color: Color(widget.slidePallet.bigTitleTColor)),
          ),
          Text(description,
              style: TextStyle(
                  fontSize: widget.size.height * 0.04,
                  color: Color(widget.slidePallet.sectionDescTextColor)))
        ],
      ),
    );
  }
}
