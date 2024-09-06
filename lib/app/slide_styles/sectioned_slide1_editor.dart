import 'dart:math';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide1Editor extends StatefulWidget {
  SectionedSlide1Editor(
      {super.key,
      required this.mySlide,
      required this.slidePallet,
      required this.size,
      required this.index,
      required this.isReadOnly});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;
  int index;
  bool isReadOnly;

  @override
  State<SectionedSlide1Editor> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide1Editor> {
  final PresentationEditCtl controller = Get.find();

  int bgIndex = 0;
  // late TextEditingController _slideTitle;
  // late List<TextEditingController> _sectionHeaders;
  // late List<TextEditingController> _sectionContents;
  // late List<String> _sectionHeaderValues;
  // late List<String> _sectionContentValues;
  Rx<double> _sectionFontSize = 0.0.obs;
  Rx<double> _slideTitleFontSize = 0.0.obs;
  
  @override
  // ignore: must_call_super
  initState() {
    setState(() {
  double _defaultSlideTitleFontSize = widget.size.width *  0.050;
  _slideTitleFontSize.value = _defaultSlideTitleFontSize;

    // _slideTitle = TextEditingController(text : widget.mySlide.slideTitle);
    
    //   // Initialize  with the default values from slideSections
    // _sectionHeaders = widget.mySlide.slideSections.map((section) {
    //   return TextEditingController(text: section.sectionHeader ?? '');
    // }).toList();

    // _sectionContents = widget.mySlide.slideSections.map((section) {
    //   return TextEditingController(text: section.sectionContent ?? '');
    // }).toList();
      
    //   _slideTitle.addListener((){
    //     setState((){
    //       slideTitleValue = _slideTitle.text;
    //       controller.myEditedPresentation.value.slides[widget.index].slideTitle = slideTitleValue;
    //     });
    //   });
      
    //   _sectionHeaderValues = _sectionHeaders.map((controller) {
    //   return controller.text;
    // }).toList();

    // _sectionContentValues = _sectionContents.map((controller) {
    //   return controller.text;
    // }).toList();
      
      
      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length - 1);
      print("BG Index: $bgIndex");
      print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });
    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    controller.initializeSlidesTextController();
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
                vertical: widget.size.height * 0.02),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Column(
              children: [
                verticalSpace(widget.size.height * 0.00),
                Container(
                  width: widget.size.width,
                  // height: widget.size.height * 0.2,
                  child: IgnorePointer(
                    ignoring: widget.isReadOnly,
                    child: EditableText(
                    cursorColor:  Colors.black,
                    backgroundCursorColor: Colors.white,
                    focusNode: FocusNode(),
                    // decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           contentPadding: EdgeInsets.zero,
                    //         ),
                            maxLines: null,
                            readOnly: widget.isReadOnly,
                    controller : controller.slideTitles[widget.index],
                    onChanged: (value){
          controller.myEditedPresentation.value.slides[widget.index].slideTitle = value;
                    },
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: _slideTitleFontSize.value,
                        color: Color(widget.slidePallet.bigTitleTColor)),
                    // style: widget.slidePallet.bigTitleTStyle
                    //     .copyWith(fontSize: widget.size.width * 0.050),
                        )
                  ),
                ),
                verticalSpace(widget.size.height * 0.03),
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
                      color: Color(widget.slidePallet.bigTitleTColor)),
                )
              : Container()
        ],
      ),
    );
  }

  Container _slideSection(int i) {
    double sectionFontSize = widget.size.width * 0.014;
    _sectionFontSize.value = sectionFontSize;
    if (widget.mySlide.slideSections[i].sectionContent != null) {
      String text = widget.mySlide.slideSections[i].sectionContent ?? "";

      if (text.length <= 140) {
        sectionFontSize = widget.size.width * 0.018;
    _sectionFontSize.value = sectionFontSize;
      } else if (text.length <= 180) {
        sectionFontSize = widget.size.width * 0.016;
    _sectionFontSize.value = sectionFontSize;
      } else if (text.length <= 220) {
        sectionFontSize = widget.size.width * 0.0145;
    _sectionFontSize.value = sectionFontSize;
      }
      developer.log("Content Length ${text.length}");
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
              ignoring: widget.isReadOnly,
            child: EditableText(
                    cursorColor:  Colors.black,
                    backgroundCursorColor: Colors.white,
                    focusNode: FocusNode(),
            // decoration: InputDecoration(
            //                   border: InputBorder.none,
            //                contentPadding: EdgeInsets.zero, 
            //                 ),
                            maxLines: null,
                            readOnly: widget.isReadOnly,
            controller: controller.slideSectionHeaders[widget.index][i] ,
             onChanged: (value) {
              // _sectionHeaderValues[i] = value;  // Update the corresponding variable
              controller.myEditedPresentation.value.slides[widget.index].slideSections[i].sectionHeader = value;
              print("$value");
      //         _sectionHeaderValues.forEach((value){
      //         print("SectionHeaders :$value ");
      // });

            },
            style: widget.mySlide.slideSections[i].sectionHeader != null
                ? TextStyle(
                    fontSize: _sectionFontSize.value ,
                    color: Color(widget.slidePallet.bigTitleTColor))
                : TextStyle(),
               )
          ),
          verticalSpace(widget.size.height * 0.01),
          IgnorePointer(
            ignoring: widget.isReadOnly,
            child: EditableText(
                    cursorColor:  Colors.black,
                    backgroundCursorColor: Colors.white,
                    focusNode: FocusNode(),
            // decoration: InputDecoration(
            //                   border: InputBorder.none,
            //                   contentPadding: EdgeInsets.zero,
            //                 ),
                            maxLines: null,
                            readOnly: widget.isReadOnly,
            controller: controller.slideSectionContents[widget.index][i],
            onChanged: (value) {
              // _sectionContentValues[i] = value;  // Update the corresponding variable
              controller.myEditedPresentation.value.slides[widget.index].slideSections[i].sectionContent = value;
              print("$value");
              
            },
            style: widget.mySlide.slideSections[i].sectionHeader != null
                ? TextStyle(
                    fontSize: _sectionFontSize.value,
                    color: Color(widget.slidePallet.bigTitleTColor))
                : TextStyle(),
            // style: widget.mySlide.slideSections[i].sectionContent != null
            //     ? widget.slidePallet.bigTitleTStyle
            //         .copyWith(fontSize: sectionFontSize)
            //     : widget.slidePallet.bigTitleTStyle,
                )
          ),
        ],
      ),
    );
  }
}
