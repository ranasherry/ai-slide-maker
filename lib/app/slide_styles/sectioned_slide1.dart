import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      padding: EdgeInsets.symmetric(
          horizontal: widget.size.width * 0.02,
          vertical: widget.size.height * 0.04),
      decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
      child: Column(
        children: [
          verticalSpace(widget.size.height * 0.1),
          Text(
            widget.mySlide.slideTitle,
            style: widget.slidePallet.bigTitleTStyle
                .copyWith(fontSize: widget.size.width * 0.065),
          ),
          verticalSpace(widget.size.height * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < widget.mySlide.slideSections.length; i += 1)
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mySlide.slideSections[i].sectionHeader ?? '',
                        style: widget.mySlide.slideSections[i].sectionHeader !=
                                null
                            ? widget.slidePallet.bigTitleTStyle
                                .copyWith(fontSize: widget.size.width * 0.03)
                            : widget.slidePallet.bigTitleTStyle,
                      ),
                      verticalSpace(widget.size.height * 0.08),
                      Text(
                        widget.mySlide.slideSections[i].sectionContent ?? '',
                        style: widget.mySlide.slideSections[i].sectionContent !=
                                null
                            ? widget.slidePallet.bigTitleTStyle
                                .copyWith(fontSize: widget.size.width * 0.03)
                            : widget.slidePallet.bigTitleTStyle,
                      ),
                    ],
                  ),
                ),
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     children: [
              //       for (int i = 1;
              //           i < widget.mySlide.slideSections.length;
              //           i += 2)
              //         Column(
              //           children: [
              //             Text(
              //               widget.mySlide.slideSections[i].sectionHeader ?? '',
              //               style: widget.mySlide.slideSections[i]
              //                           .sectionHeader !=
              //                       null
              //                   ? widget.slidePallet.bigTitleTStyle.copyWith(
              //                       fontSize: widget.size.width * 0.03)
              //                   : widget.slidePallet.bigTitleTStyle,
              //             ),
              //             verticalSpace(widget.size.height * 0.08),
              //             Text(
              //               widget.mySlide.slideSections[i].sectionContent ??
              //                   '',
              //               style: widget.mySlide.slideSections[i]
              //                           .sectionContent !=
              //                       null
              //                   ? widget.slidePallet.bigTitleTStyle.copyWith(
              //                       fontSize: widget.size.width * 0.03)
              //                   : widget.slidePallet.bigTitleTStyle,
              //             ),
              //           ],
              //         ),
              //     ],
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
