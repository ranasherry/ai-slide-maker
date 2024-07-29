import 'package:flutter/material.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
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
          Text(
            widget.mySlide.slideSections[0].sectionContent!,
            style: widget.slidePallet.bigTitleTStyle
                .copyWith(fontSize: widget.size.width * 0.03),
          ),
        ],
      ),
    );
  }
}
