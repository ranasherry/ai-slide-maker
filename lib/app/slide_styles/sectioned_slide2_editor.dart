import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SectionedSlide2Editor extends StatefulWidget {
  SectionedSlide2Editor(
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
  State<SectionedSlide2Editor> createState() => __SectionedSlide1State();
}

class __SectionedSlide1State extends State<SectionedSlide2Editor> {
  final PresentationEditCtl controller = Get.find();

  // late TextEditingController _slideTitle,_sectionHeader0,_sectionContent0,_sectionHeader1,_sectionContent1;
   

  // String slideTitleValue = "",
  //  sectionHeader0Value = "",
  //   sectionContent0Value = "",
  //    sectionHeader1Value = "",
  //     sectionContent1Value = "";

  int bgIndex = 0;
  @override
  void initState() {
    super.initState();
// if(widget.isReadOnly){

// }else{

// }
    setState(() {
    //    _slideTitle = TextEditingController(text : widget.mySlide.slideTitle);
    //    _sectionHeader0 = TextEditingController(text :widget.mySlide.slideSections[0].sectionHeader ?? '' );
    // _sectionContent0 = TextEditingController(text :  widget.mySlide.slideSections[0].sectionContent ?? '');
    //  _sectionHeader1 = TextEditingController(text : widget.mySlide.slideSections[1].sectionHeader ?? '');
    //   _sectionContent1 = TextEditingController(text : widget.mySlide.slideSections[1].sectionContent ?? '');
      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length);
      print("BG Index: $bgIndex");
      print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });
    // ever(controller.currentFontSize, (_) {
    //     developer.log("check 1 Title Font value:${controller.slideTitlesFontValue.value[widget.index].value}");
    //     developer.log("check 1.1 Current Font value:${controller.currentFontSize.value}");
    //   setState(() {}); // Update the UI when the value changes
    // });


    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    // controller.initializeSlidesTextController();
    // controller.initializeSlidesFontList();
    controller.slideTitlesFontValue.value[widget.index].value = widget.size.width * 0.040;
    controller.slideSectionHeadersFontValue.value[widget.index][0].value = widget.size.width * 0.035;
    controller.slideSectionContentsFontValue.value[widget.index][0].value = widget.size.width * 0.018;
    controller.slideSectionHeadersFontValue.value[widget.index][1].value = widget.size.width * 0.035;
    controller.slideSectionContentsFontValue.value[widget.index][1].value = widget.size.width * 0.018;

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
                verticalSpace(widget.size.height * 0.0),
                Container(
                  width: widget.size.width,
                  // height: widget.size.height * 0.2,
                  child: IgnorePointer(
                    ignoring: widget.isReadOnly,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextField(
                         onTap: (){
                          controller.setValuesAsNull();
                          controller.isTitle.value = true;
                          controller.firstIndexOfFont.value = widget.index;
                      controller.currentFontSize.value = controller.slideTitlesFontValue.value[widget.index].value;
                    
                    },
                      cursorColor:  Colors.black,
                      // backgroundCursorColor: Colors.white,
                      focusNode: FocusNode(),
                      // decoration: InputDecoration(
                      //           border: InputBorder.none
                      //         ),
                              maxLines: null,
                              controller : controller.slideTitles[widget.index],
                              
                              readOnly: widget.isReadOnly,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(0),
                                isDense: true,
                                
                              ),
                              onChanged: (value){
                                // slideTitleValue = value;
                                controller.myEditedPresentation.value.slides[widget.index].slideTitle = value ;
                                print(value);
                              },
                      
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          // fontSize: widget.size.width * 0.040,
                          fontSize: controller.slideTitlesFontValue.value[widget.index].value,
                          color: Color(widget.slidePallet.bigTitleTColor)),
                      // style: widget.slidePallet.bigTitleTStyle
                      //     .copyWith(fontSize: widget.size.width * 0.050),
                                        ),
                    ),
                    ),
                ),
                // verticalSpace(widget.size.height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.mySlide.slideSections.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IgnorePointer(
                    ignoring: widget.isReadOnly,
                                child: TextField(
                                  onTap: (){
                                    controller.setValuesAsNull();
                                    controller.isSectionHeader.value = true;
                                    controller.isSectionHeader.value = true;
                                    controller.firstIndexOfFont.value = widget.index;
                                  controller.currentFontSize.value = controller.slideSectionHeadersFontValue.value[widget.index][0].value;
                                },
                                  cursorColor:  Colors.black,
                                  // backgroundCursorColor: Colors.white,
                                  focusNode: FocusNode(),
                                  //     decoration: InputDecoration(
                                  //   border: InputBorder.none
                                  // ),
                                  maxLines: null,
                                  readOnly: widget.isReadOnly,
                                  controller : controller.slideSectionHeaders[widget.index][0],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    
                                  ),
                                  onChanged: (value){
                                    // sectionHeader0Value = value;
                                    controller.myEditedPresentation.value.slides[widget.index].slideSections[0].sectionHeader = value ;
                                    print(value);
                                  },
                                style: widget.mySlide.slideSections[0]
                                            .sectionHeader !=
                                        null
                                    ? TextStyle(
                                        fontSize: controller.slideSectionHeadersFontValue.value[widget.index][0].value,
                                        // fontSize: widget.size.width * 0.035,
                                        color: Color(
                                            widget.slidePallet.bigTitleTColor))
                                    : TextStyle(),
                                // style: widget.mySlide.slideSections[0]
                                //             .sectionHeader !=
                                //         null
                                //     ? widget.slidePallet.bigTitleTStyle
                                //         .copyWith(
                                //             fontSize: widget.size.width * 0.035)
                                //     : widget.slidePallet.bigTitleTStyle,
                                   ),
                                
                              ),
                              // verticalSpace(widget.size.height * 0.01),
                              IgnorePointer(
                    ignoring: widget.isReadOnly,
                                child: TextField(
                                   onTap: (){
                                    controller.setValuesAsNull();
                                    controller.isSectionContent.value = true;
                                    controller.firstIndexOfFont.value = widget.index;
                                    controller.secondIndexOfFont.value = 0;
                                  controller.currentFontSize.value = controller.slideSectionContentsFontValue.value[widget.index][0].value;
                                },
                                  cursorColor:  Colors.black,
                                  // backgroundCursorColor: Colors.white,
                                  focusNode: FocusNode(),
                                          //     decoration: InputDecoration(
                                          //   border: InputBorder.none
                                          // ),
                                          maxLines: null,
                                          readOnly: widget.isReadOnly,
                                          controller : controller.slideSectionContents[widget.index][0],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(0),
                                            isDense: true,
                                            
                                          ),
                                          onChanged: (value){
                                            // sectionContent0Value = value;
                                            print(value);
                                            controller.myEditedPresentation.value.slides[widget.index].slideSections[0].sectionContent = value;
                                          },   
                                style: widget.mySlide.slideSections[0]
                                            .sectionHeader !=
                                        null
                                    ? TextStyle(
                                        fontSize: controller.slideSectionContentsFontValue.value[widget.index][0].value,
                                        // fontSize: widget.size.width * 0.018,
                                        color: Color(
                                            widget.slidePallet.bigTitleTColor))
                                    : TextStyle(),
                                // style: widget.mySlide.slideSections[0]
                                //             .sectionContent !=
                                //         null
                                //     ? widget.slidePallet.bigTitleTStyle
                                //         .copyWith(
                                //             fontSize: widget.size.width * 0.018)
                                //     : widget.slidePallet.bigTitleTStyle,
                                                              ),
                                ),
                            ],
                          )
                        : Container(),
                    verticalSpace(widget.size.height * 0.02),
                    widget.mySlide.slideSections.length >= 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IgnorePointer(
                                  ignoring: widget.isReadOnly,
                                child: TextField(
                                  onTap: (){
                                    controller.setValuesAsNull();
                                    controller.isSectionHeader.value = true;
                                    controller.firstIndexOfFont.value = widget.index;
                                    controller.secondIndexOfFont.value = 1;
                                  controller.currentFontSize.value =  controller.slideSectionHeadersFontValue.value[widget.index][1].value;
                                },
                                    cursorColor:  Colors.black,
                                    // backgroundCursorColor: Colors.white,
                                    focusNode: FocusNode(),
                                            //     decoration: InputDecoration(
                                            //   border: InputBorder.none
                                            // ),
                                            maxLines: null,
                                            readOnly: widget.isReadOnly,
                                            controller : controller.slideSectionHeaders[widget.index][1],
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(0),
                                              isDense: true,
                                              
                                            ),
                                            onChanged: (value){
                                              // sectionHeader1Value = value;
                                              controller.myEditedPresentation.value.slides[widget.index].slideSections[1].sectionHeader = value ;
                                              print(value);
                                            },
                                // style: widget.mySlide.slideSections[1]
                                //             .sectionHeader !=
                                //         null
                                //     ? widget.slidePallet.bigTitleTStyle
                                //         .copyWith(
                                //             fontSize: widget.size.width * 0.035)
                                //     : widget.slidePallet.bigTitleTStyle,
                                style: widget.mySlide.slideSections[1]
                                            .sectionHeader !=
                                        null
                                    ? TextStyle(
                                        fontSize: controller.slideSectionHeadersFontValue.value[widget.index][1].value,
                                        // fontSize: widget.size.width * 0.035,
                                        color: Color(
                                            widget.slidePallet.bigTitleTColor))
                                    : TextStyle(),
                                    ),
                                
                              ),
                              // verticalSpace(widget.size.height * 0.01),
                              IgnorePointer(
                                ignoring: widget.isReadOnly,
                                child: TextField(
                                  onTap: (){
                                    controller.setValuesAsNull();
                                    controller.isSectionContent.value = true;
                                    controller.firstIndexOfFont.value = widget.index;
                                    controller.secondIndexOfFont.value = 1;
                                  controller.currentFontSize.value = controller.slideSectionContentsFontValue.value[widget.index][1].value;
                                },
                                  cursorColor:  Colors.black,
                                  // backgroundCursorColor: Colors.white,
                                  focusNode: FocusNode(),
                                  //     decoration: InputDecoration(
                                  //   border: InputBorder.none
                                  // ),
                                  maxLines: null,
                                  readOnly: widget.isReadOnly,
                                  controller : controller.slideSectionContents[widget.index][1],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(0),
                                    isDense: true,
                                    
                                  ),
                                  onChanged: (value){
                                    // sectionContent1Value = value;
                                    print(value);
                                    controller.myEditedPresentation.value.slides[widget.index].slideSections[1].sectionContent = value ;
                                  },
                                style: widget.mySlide.slideSections[1]
                                            .sectionHeader !=
                                        null
                                    ? TextStyle(
                                        fontSize: controller.slideSectionContentsFontValue.value[widget.index][1].value,
                                        color: Color(
                                            widget.slidePallet.bigTitleTColor))
                                    : TextStyle(),
                                // style: widget.mySlide.slideSections[1]
                                //             .sectionContent !=
                                //         null
                                //     ? widget.slidePallet.bigTitleTStyle
                                //         .copyWith(
                                //             fontSize: widget.size.width * 0.018)
                                //     : widget.slidePallet.bigTitleTStyle,
                                    ),
                                
                              ),
                            ],
                          )
                        : Container()
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
}
