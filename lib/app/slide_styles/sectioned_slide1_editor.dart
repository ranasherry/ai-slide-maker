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
  double titleFontValue = 0.0;
  late Worker fontSizeWorker;
  late Worker slideTitleWorker;
  int i = 0;
  // late TextEditingController _slideTitle;
  // late List<TextEditingController> _sectionHeaders;
  // late List<TextEditingController> _sectionContents;
  // late List<String> _sectionHeaderValues;
  // late List<String> _sectionContentValues;
  // Rx<double> _sectionFontSize = 0.0.obs;
  // Rx<double> _slideTitleFontSize = 0.0.obs;
  
  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    super.setState(() {
    controller.slideTitlesFontValue[widget.index].value = 0.050;
 if(widget.slidePallet.slideTitlesFontValue == null || widget.slidePallet.slideTitlesFontValue!.isEmpty){
      widget.slidePallet.slideTitlesFontValue = controller.slideTitlesFontValue.map((rxDouble){return rxDouble.value;}).toList();
    }
    else{
      if(widget.slidePallet.slideTitlesFontValue![widget.index] != 0.0){
        controller.slideTitlesFontValue[widget.index].value = widget.slidePallet.slideTitlesFontValue![widget.index];
      }
    }
      
    if(widget.slidePallet.slideSectionContentsFontValue == null || widget.slidePallet.slideSectionContentsFontValue!.isEmpty){
     widget.slidePallet.slideSectionContentsFontValue =  controller.slideSectionContentsFontValue.map((rxList){return rxList.map((rxDouble){return rxDouble.value;}).toList();}).toList();
      }
      else{
        i=0;
        while(i < controller.slideSectionContentsFontValue[widget.index].length){
          if(widget.slidePallet.slideSectionContentsFontValue![widget.index][i] != 0.0){
          controller.slideSectionContentsFontValue[widget.index][i].value = widget.slidePallet.slideSectionContentsFontValue![widget.index][i];
          }
          // widget.slidePallet.slideSectionContentsFontValue![widget.index][i] == 0.0 ? widget.slidePallet.slideSectionContentsFontValue =  controller.slideSectionContentsFontValue.map((rxList){return rxList.map((rxDouble){return rxDouble.value;}).toList();}).toList(): controller.slideSectionContentsFontValue[widget.index][i].value = widget.slidePallet.slideSectionContentsFontValue![widget.index][i];
          i++;
        }
      }

      if(widget.slidePallet.slideSectionHeadersFontValue == null || widget.slidePallet.slideSectionHeadersFontValue!.isEmpty){
     widget.slidePallet.slideSectionHeadersFontValue =  controller.slideSectionHeadersFontValue.map((rxList){return rxList.map((rxDouble){return rxDouble.value;}).toList();}).toList();
      }
      else{
        i=0;
        while(i < controller.slideSectionHeadersFontValue[widget.index].length){
          if(widget.slidePallet.slideSectionHeadersFontValue![widget.index][i] != 0.0){
          controller.slideSectionHeadersFontValue[widget.index][i].value = widget.slidePallet.slideSectionHeadersFontValue![widget.index][i];
          }
          // widget.slidePallet.slideSectionHeadersFontValue![widget.index][i] == 0.0 ? widget.slidePallet.slideSectionHeadersFontValue =  controller.slideSectionHeadersFontValue.map((rxList){return rxList.map((rxDouble){return rxDouble.value;}).toList();}).toList(): controller.slideSectionHeadersFontValue[widget.index][i].value = widget.slidePallet.slideSectionHeadersFontValue![widget.index][i];
          i++;
        }
      }
      controller.currentPallet=widget.slidePallet;
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

   
    // ever(controller.currentFontSize, (_) {
    //     developer.log("check 1 Title Font value:${controller.slideTitlesFontValue.value[widget.index].value}");
    //     developer.log("check 1.1 Current Font value:${controller.currentFontSize.value}");
    //   setState(() {}); // Update the UI when the value changes
    // });
    print("initState Called");
  fontSizeWorker = ever(controller.currentFontSize, (_){
      setState((){});
    });
    slideTitleWorker = ever(controller.currentText, (_){
      setState((){});
    });


  }
  @override
      @override
  void dispose() {
    // Dispose of the ever listeners when the widget is disposed
    fontSizeWorker.dispose();
    slideTitleWorker.dispose();

    super.dispose();
  }
  Widget build(BuildContext context) {
    // controller.initializeSlidesTextController();
    // controller.initializeSlidesFontList();
   titleFontValue = widget.size.width *  controller.slideTitlesFontValue[widget.index].value;

    
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
                     child: GestureDetector(
                        onTap: (){
                        controller.setValuesAsNull();
                        controller.toggleVisibilityTextEditor(true);
                        controller.isTitle.value = true;
                        controller.firstIndexOfFont.value = widget.index;
                        controller.currentText.value = controller.slideTitles[widget.index].text;
                      controller.currentFontSize.value = controller.slideTitlesFontValue[widget.index].value;
                    },
                       child: Text(
                          controller.slideTitles[widget.index].text, 
                        style: TextStyle(
                          fontSize:  titleFontValue,
                            // fontSize: contentFontSize,
                            color: Color(widget.slidePallet.bigTitleTColor)),
                            ),
                     ),
                    // child: TextField(
                    //    onTap: (){
                    //     // controller.setValuesAsNull();
                    //     // controller.isTitle.value = true;
                    //     // controller.firstIndexOfFont.value = widget.index;
                    //   controller.currentFontSize.value = controller.slideTitlesFontValue.value[widget.index].value;
                    // },
                    // cursorColor:  Colors.black,
                    // // backgroundCursorColor: Colors.white,
                    // focusNode: FocusNode(),
                    // // decoration: InputDecoration(
                    // //           border: InputBorder.none,
                    // //           contentPadding: EdgeInsets.zero,
                    // //         ),
                    //         maxLines: null,
                    //         readOnly: widget.isReadOnly,
                    // controller : controller.slideTitles[widget.index],
                    // decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           contentPadding: EdgeInsets.zero,
                    //           isDense: true
                    //         ),
                    // onChanged: (value){
                    //           controller.myEditedPresentation.value.slides[widget.index].slideTitle = value;
                    // },
                    // // overflow: TextOverflow.ellipsis,
                    // style: TextStyle(
                    //     fontSize:  controller.slideTitlesFontValue.value[widget.index].value,
                    //     color: Color(widget.slidePallet.bigTitleTColor)),
                    // // style: widget.slidePallet.bigTitleTStyle
                    // //     .copyWith(fontSize: widget.size.width * 0.050),
                    //     ),
                    
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
    late double sectionContentFontSize;
    late double sectionHeaderFontSize;
    if(controller.slideSectionContentsFontValue[widget.index][i].value == 0){
 controller.slideSectionContentsFontValue[widget.index][i].value = 0.014;
    sectionContentFontSize = widget.size.width * controller.slideSectionContentsFontValue[widget.index][i].value;
    // _sectionFontSize.value = sectionFontSize;
    // controller.slideSectionContentsFontValue[widget.index][i].value = sectionContentFontSize;
    //    if (widget.mySlide.slideSections[i].sectionContent != null) {
      String text = widget.mySlide.slideSections[i].sectionContent ?? "";
      if (text.length <= 140) {
    controller.slideSectionContentsFontValue[widget.index][i].value = 0.018;
        sectionContentFontSize = widget.size.width * controller.slideSectionContentsFontValue[widget.index][i].value;
    // controller.slideSectionContentsFontValue[widget.index][i].value = sectionFontSize;
    //    // _sectionFontSize.value = sectionFontSize;
      } else if (text.length <= 180) {
    controller.slideSectionContentsFontValue[widget.index][i].value = 0.016;
        sectionContentFontSize = widget.size.width * controller.slideSectionContentsFontValue[widget.index][i].value;
    // controller.slideSectionContentsFontValue[widget.index][i].value = sectionFontSize;
    //    // _sectionFontSize.value = sectionFontSize;
      } else if (text.length <= 220) {
    controller.slideSectionContentsFontValue[widget.index][i].value = 0.0145;
        sectionContentFontSize = widget.size.width * controller.slideSectionContentsFontValue[widget.index][i].value;
    // controller.slideSectionContentsFontValue[widget.index][i].value = sectionFontSize;
    //    // _sectionFontSize.value = sectionFontSize;
      }
    }
    else{
      sectionContentFontSize = widget.size.width * controller.slideSectionContentsFontValue[widget.index][i].value;
    }

    if(controller.slideSectionHeadersFontValue[widget.index][i].value == 0){
    controller.slideSectionHeadersFontValue[widget.index][i].value = 0.014;
    sectionHeaderFontSize = widget.size.width * controller.slideSectionHeadersFontValue[widget.index][i].value;
    // _sectionFontSize.value = sectionFontSize;
    // controller.slideSectionHeadersFontValue[widget.index][i].value = sectionHeaderFontSize;
    if (widget.mySlide.slideSections[i].sectionHeader != null) {
      String text = widget.mySlide.slideSections[i].sectionHeader ?? "";
      if (text.length <= 140) {
    controller.slideSectionHeadersFontValue[widget.index][i].value = 0.018;
    // controller.slideSectionHeadersFontValue[widget.index][i].value = sectionFontSize;
    // _sectionFontSize.value = sectionFontSize;
      } else if (text.length <= 180) {
    controller.slideSectionHeadersFontValue[widget.index][i].value = 0.016;
    // controller.slideSectionHeadersFontValue[widget.index][i].value = sectionFontSize;
    // _sectionFontSize.value = sectionFontSize;
      } else if (text.length <= 220) {
    controller.slideSectionHeadersFontValue[widget.index][i].value = 0.0145;
    // controller.slideSectionHeadersFontValue[widget.index][i].value = sectionFontSize;
    // _sectionFontSize.value = sectionFontSize;
      }
      developer.log("Content Length ${text.length}");
    }
    }
    else{
    sectionHeaderFontSize = widget.size.width * controller.slideSectionHeadersFontValue[widget.index][i].value;
    }
    
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IgnorePointer(
              ignoring: widget.isReadOnly,
              child: GestureDetector(
                 onTap: (){
              controller.setValuesAsNull();
              controller.toggleVisibilityTextEditor(true);
              controller.isSectionHeader.value = true;
              controller.firstIndexOfFont.value = widget.index;
              controller.secondIndexOfFont.value = i;
              controller.currentText.value = controller.slideSectionHeaders[widget.index][i].text;
              controller.currentFontSize.value = controller.slideSectionHeadersFontValue[widget.index][i].value;
            },
                child: Text(
                  controller.slideSectionHeaders[widget.index][i].text, 
                style: TextStyle(
                  fontSize: sectionHeaderFontSize ,
                    // fontSize: contentFontSize,
                    color: Color(widget.slidePallet.bigTitleTColor)),
                            ),
              ),
            // child: TextField(
            //   onTap: (){
            //   // controller.setValuesAsNull();
            //   // controller.isSectionHeader.value = true;
            //   // controller.firstIndexOfFont.value = widget.index;
            //   // controller.secondIndexOfFont.value = i;
            //   controller.currentFontSize.value = controller.slideSectionHeadersFontValue.value[widget.index][i].value;
            // },
            //         cursorColor:  Colors.black,
            //         // backgroundCursorColor: Colors.white,
            //         focusNode: FocusNode(),
            //         // decoration: InputDecoration(
            //         //                   border: InputBorder.none,
            //         //                contentPadding: EdgeInsets.zero, 
            //         //                 ),
            //         maxLines: null,
            //         readOnly: widget.isReadOnly,
            // controller: controller.slideSectionHeaders[widget.index][i],
            // decoration: InputDecoration(
            //                   border: InputBorder.none,
            //                   contentPadding: EdgeInsets.zero,
            //                   isDense: true
            //                 ),
            //  onChanged: (value) {
            //   // _sectionHeaderValues[i] = value;  // Update the corresponding variable
            //   controller.myEditedPresentation.value.slides[widget.index].slideSections[i].sectionHeader = value;
            //   print("$value");
            //       //         _sectionHeaderValues.forEach((value){
            //       //         print("SectionHeaders :$value ");
            //       // });
            // },
            // style: widget.mySlide.slideSections[i].sectionHeader != null
            //     ? TextStyle(
            //         fontSize: controller.slideSectionHeadersFontValue.value[widget.index][i].value ,
            //         color: Color(widget.slidePallet.bigTitleTColor))
            //     : TextStyle(),
            //    ),
            
          ),
          verticalSpace(widget.size.height * 0.01),
          IgnorePointer(
            ignoring: widget.isReadOnly,
            child: GestureDetector(
              onTap: (){
              controller.setValuesAsNull();
              controller.toggleVisibilityTextEditor(true);
              controller.isSectionContent.value = true;
              controller.firstIndexOfFont.value = widget.index;
              controller.secondIndexOfFont.value = i;
              controller.currentText.value = controller.slideSectionContents[widget.index][i].text;
              controller.currentFontSize.value = controller.slideSectionContentsFontValue[widget.index][i].value;
            },
              child: Text(
                  controller.slideSectionContents[widget.index][i].text, 
                style: TextStyle(
                  fontSize: sectionContentFontSize,
                    // fontSize: contentFontSize,
                    color: Color(widget.slidePallet.bigTitleTColor)),
                ),
            ),
            // child:  TextField(
            //   onTap: (){
            //   //   controller.setValuesAsNull();
            //   //   controller.isSectionContent.value = true;
            //   //   controller.firstIndexOfFont.value = widget.index;
            //   //   controller.secondIndexOfFont.value = i;
            //   controller.currentFontSize.value = controller.slideSectionContentsFontValue.value[widget.index][i].value;
            // },
            // cursorColor:  Colors.black,
            // // backgroundCursorColor: Colors.white,
            // focusNode: FocusNode(),
            // // decoration: InputDecoration(
            // //                   border: InputBorder.none,
            // //                   contentPadding: EdgeInsets.zero,
            // //                 ),
            // maxLines: null,
            // readOnly: widget.isReadOnly,
            // controller: controller.slideSectionContents[widget.index][i],
            // decoration: InputDecoration(
            //                   border: InputBorder.none,
            //                   contentPadding: EdgeInsets.zero,
            //                   isDense: true
            //                 ),
            // onChanged: (value) {
            //   // _sectionContentValues[i] = value;  // Update the corresponding variable
            //   controller.myEditedPresentation.value.slides[widget.index].slideSections[i].sectionContent = value;
            //   print("$value");
              
            // },
            // style: widget.mySlide.slideSections[i].sectionHeader != null
            //     ? TextStyle(
            //         fontSize: controller.slideSectionContentsFontValue.value[widget.index][i].value,
            //         color: Color(widget.slidePallet.bigTitleTColor))
            //     : TextStyle(),
            // // style: widget.mySlide.slideSections[i].sectionContent != null
            // //     ? widget.slidePallet.bigTitleTStyle
            // //         .copyWith(fontSize: sectionFontSize)
            // //     : widget.slidePallet.bigTitleTStyle,
            //     ),
            
          ),
        ],
      ),
    );
  }
}
