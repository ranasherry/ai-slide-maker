import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
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
              widget.slidePallet.imageList[1],
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
                verticalSpace(widget.size.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.mySlide.slideTitle,
                      style: widget.slidePallet.bigTitleTStyle
                          .copyWith(fontSize: widget.size.width * 0.065),
                    ),
                  ],
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
        ],
      ),
    );
  }
}
