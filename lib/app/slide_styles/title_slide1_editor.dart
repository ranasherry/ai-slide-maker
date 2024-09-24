import 'dart:math';
import 'dart:developer' as developer;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/data/text_properties.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/services/remoteconfig_services.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/slide_styles/water_mark.dart';
import 'package:slide_maker/app/utills/clip_shapes/hexagon_clipper.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class TitleSlide1Editor extends StatefulWidget {
  TitleSlide1Editor(
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
  State<TitleSlide1Editor> createState() => __TitleSlide1State();
}

class __TitleSlide1State extends State<TitleSlide1Editor> {
  final PresentationEditCtl controller = Get.find();
  int bgIndex = 0;
  String slideTitleValue = "";
  String sectionContent0Value = "";
  Rx<double> titleFontSize = 0.0.obs;
  Rx<double> contentFontSize = 0.0.obs;
  int i = 0;
  // final FocusNode _focusNode = FocusNode();
  var rebuild = false;
  late Worker fontSizeWorker;
  late Worker currentTextWorker;
  late Worker resetFontWorker;

    
  @override
  // ignore: must_call_super
 void initState() {
  super.initState();
    setState(() {

    //   controller.slideTitlesFontValue[widget.index].value = widget.mySlide.slideSections[0].memoryImage != null ||
    //     widget.mySlide.slideSections[0].imageReference != null
    // ? widget.size.width * 0.05
    // : widget.size.width * 0.06;
    // controller.slideSectionContentsFontValue[widget.index][0].value = widget.size.width * 0.02;
    developer.log("init state run");
      controller.slideTitlesFontValue[widget.index].value = widget.mySlide.slideSections[0].memoryImage != null ||
        widget.mySlide.slideSections[0].imageReference != null ? 0.05 : 0.06;
      controller.slideSectionContentsFontValue[widget.index][0].value = 0.02;

 if(widget.slidePallet.slideTitlesFontValue == null || widget.slidePallet.slideTitlesFontValue!.isEmpty){
        developer.log("inisde if title");
      widget.slidePallet.slideTitlesFontValue = controller.slideTitlesFontValue.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();
    }
    else{
        developer.log("inisde else if title");
      if(widget.slidePallet.slideTitlesFontValue![widget.index].fontSize!  != 0.0){
        controller.slideTitlesFontValue[widget.index].value = widget.slidePallet.slideTitlesFontValue![widget.index].fontSize!;
      }
    }
    if(widget.slidePallet.slideSectionContentsFontValue == null || widget.slidePallet.slideSectionContentsFontValue!.isEmpty){
     widget.slidePallet.slideSectionContentsFontValue =  controller.slideSectionContentsFontValue.map((rxList){return rxList.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();}).toList();
      }
      else{
        i=0;
        while(i < controller.slideSectionContentsFontValue[widget.index].length){
          if(widget.slidePallet.slideSectionContentsFontValue![widget.index][i].fontSize!  != 0.0){
          controller.slideSectionContentsFontValue[widget.index][i].value = widget.slidePallet.slideSectionContentsFontValue![widget.index][i].fontSize!;
          }
          // widget.slidePallet.slideSectionContentsFontValue![widget.index][i] == 0.0 ? widget.slidePallet.slideSectionContentsFontValue =  controller.slideSectionContentsFontValue.map((rxList){return rxList.map((rxDouble){return rxDouble.value;}).toList();}).toList(): controller.slideSectionContentsFontValue[widget.index][i].value = widget.slidePallet.slideSectionContentsFontValue![widget.index][i];
          i++;
        }
      }

      if(widget.slidePallet.slideSectionHeadersFontValue == null || widget.slidePallet.slideSectionHeadersFontValue!.isEmpty){
     widget.slidePallet.slideSectionHeadersFontValue =  controller.slideSectionHeadersFontValue.map((rxList){return rxList.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();}).toList();
      }
      else{
        i=0;
        while(i < controller.slideSectionHeadersFontValue[widget.index].length){
          if(widget.slidePallet.slideSectionHeadersFontValue![widget.index][i].fontSize!  != 0.0){
          controller.slideSectionHeadersFontValue[widget.index][i].value = widget.slidePallet.slideSectionHeadersFontValue![widget.index][i].fontSize!;
          }
          // widget.slidePallet.slideSectionHeadersFontValue![widget.index][i] == 0.0 ? widget.slidePallet.slideSectionHeadersFontValue =  controller.slideSectionHeadersFontValue.map((rxList){return rxList.map((rxDouble){return rxDouble.value;}).toList();}).toList(): controller.slideSectionHeadersFontValue[widget.index][i].value = widget.slidePallet.slideSectionHeadersFontValue![widget.index][i];
          i++;
        }
      }
      controller.currentPallet=widget.slidePallet;

      final random = Random();
      // controller.titleFontSize.value.value = widget.slidePallet.slideTitlesFontValue![widget.index];
      // controller.contentFontSize.value.value = widget.slidePallet.slideSectionContentsFontValue![widget.index][0];
      bgIndex = random.nextInt(widget.slidePallet.imageList.length);
      // print('This is current font size value ${controller.currentFontSize}');
      // print("Title Font Size: $controller.titleFontSize.value.value");
      // print("Title Font Size: ${widget.slidePallet.slideTitlesFontValue![widget.index]}");
      // print("BG Index: $bgIndex");
      // print("BG Image: ${widget.slidePallet.imageList[bgIndex]}");
    });

//       ever(controller.currentFontSize, (_) {
//         // developer.log("check 1 Title Font Index:${widget.index}");
//         // developer.log("check 1 Title Font value:${controller.slideTitlesFontValue[widget.index].value}");
//         developer.log("check 1.1 Current Font value:${controller.currentFontSize.value}");
//         // developer.log("test : ${controller.test.value}");
//   widget.slidePallet=controller.currentPallet;
//   // controller.titleFontSize.value.value=controller.currentFontSize.value;

//         // developer.log("Slide Pallet Font Size : ${controller.currentPallet.titleFontSize.value}");

// // controller.titleFontSize.value.value = widget.slidePallet.slideTitlesFontValue![widget.index];

//         // developer.log("controller.titleFontSize.value.value: ${titleFontSize.value}");

//       setState(() {}); // Update the UI when the value changes
//     });
    fontSizeWorker = ever(controller.currentFontSize, (_){
      rebuild = true;
      setState((){});
    });
    currentTextWorker = ever(controller.currentText, (_){
      setState((){});
    });
    resetFontWorker = ever(controller.resetFont, (_){
      setState((){
        developer.log("resetFont");
          controller.slideTitlesFontValue[widget.index].value = widget.mySlide.slideSections[0].memoryImage != null ||
        widget.mySlide.slideSections[0].imageReference != null ? 0.05 : 0.06;
      controller.slideSectionContentsFontValue[widget.index][0].value = 0.02;

 if(widget.slidePallet.slideTitlesFontValue == null || widget.slidePallet.slideTitlesFontValue!.isEmpty){
        developer.log("inisde if title reset font");

      widget.slidePallet.slideTitlesFontValue = controller.slideTitlesFontValue.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();
    }
    else{
      if(widget.slidePallet.slideTitlesFontValue![widget.index].fontSize! != 0.0){
        developer.log("inisde else if title reset font");
        controller.slideTitlesFontValue[widget.index].value = widget.slidePallet.slideTitlesFontValue![widget.index].fontSize! ;
      }
    }
    if(widget.slidePallet.slideSectionContentsFontValue == null || widget.slidePallet.slideSectionContentsFontValue!.isEmpty){
     widget.slidePallet.slideSectionContentsFontValue =  controller.slideSectionContentsFontValue.map((rxList){return rxList.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();}).toList();
      }
      else{
        i=0;
        while(i < controller.slideSectionContentsFontValue[widget.index].length){
          if(widget.slidePallet.slideSectionContentsFontValue![widget.index][i].fontSize!  != 0.0){
          controller.slideSectionContentsFontValue[widget.index][i].value = widget.slidePallet.slideSectionContentsFontValue![widget.index][i].fontSize! ;
          }
          // widget.slidePallet.slideSectionContentsFontValue![widget.index][i] == 0.0 ? widget.slidePallet.slideSectionContentsFontValue =  controller.slideSectionContentsFontValue.map((rxList){return rxList.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();}).toList(): controller.slideSectionContentsFontValue[widget.index][i].value = widget.slidePallet.slideSectionContentsFontValue![widget.index][i];
          i++;
        }
      }

      if(widget.slidePallet.slideSectionHeadersFontValue == null || widget.slidePallet.slideSectionHeadersFontValue!.isEmpty){
     widget.slidePallet.slideSectionHeadersFontValue =  controller.slideSectionHeadersFontValue.map((rxList){return rxList.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();}).toList();
      }
      else{
        i=0;
        while(i < controller.slideSectionHeadersFontValue[widget.index].length){
          if(widget.slidePallet.slideSectionHeadersFontValue![widget.index][i].fontSize!  != 0.0){
          controller.slideSectionHeadersFontValue[widget.index][i].value = widget.slidePallet.slideSectionHeadersFontValue![widget.index][i].fontSize! ;
          }
          // widget.slidePallet.slideSectionHeadersFontValue![widget.index][i] == 0.0 ? widget.slidePallet.slideSectionHeadersFontValue =  controller.slideSectionHeadersFontValue.map((rxList){return rxList.map((rxDouble){return TextProperties(fontSize : rxDouble.value);}).toList();}).toList(): controller.slideSectionHeadersFontValue[widget.index][i].value = widget.slidePallet.slideSectionHeadersFontValue![widget.index][i];
          i++;
        }
      }
      });
    });




    // print(
    //     "initState Called: Image Bytes: ${widget.mySlide.slideSections[0].memoryImage}");
  
        // "initState Called: Image reference: ${widget.mySlide.slideSections[0].imageReference}");
  }


      @override
  void dispose() {
    // Dispose of the ever listeners when the widget is disposed
    fontSizeWorker.dispose();
    currentTextWorker.dispose();
    resetFontWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    titleFontSize.value = widget.mySlide.slideSections[0].memoryImage != null ||
        widget.mySlide.slideSections[0].imageReference != null
    ? widget.size.width * controller.slideTitlesFontValue[widget.index].value
    : widget.size.width * controller.slideTitlesFontValue[widget.index].value;
    contentFontSize.value = widget.size.width * controller.slideSectionContentsFontValue[widget.index][0].value;


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
                vertical: widget.size.width * 0.04),
            decoration: BoxDecoration(color: widget.slidePallet.fadeColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: widget.mySlide.slideSections[0].memoryImage != null ||
                          widget.mySlide.slideSections[0].imageReference != null
                      ? widget.size.width * 0.5
                      : widget.size.width * 0.9,
                  child: Column(
                    children: [
                      verticalSpace(widget.size.height * 0.00),
                      IgnorePointer(
                        ignoring: widget.isReadOnly,
                        child: GestureDetector(
                          onTap: (){
                            controller.toggleVisibilityTextEditor(true);
                            controller.setValuesAsNull();
                            controller.isTitle.value = true;
                            controller.firstIndexOfFont.value = widget.index;
                          controller.currentFontSize.value =  controller.slideTitlesFontValue[widget.index].value;
                          controller.currentText.value = controller.slideTitles[widget.index].text;
                          controller.currentEditedText.value = controller.slideTitles[widget.index].text;
                          developer.log('pressed title slide 1 title ${controller.slideTitlesFontValue[widget.index].value } size');
                           developer.log("${controller.slideTitlesFontValue[widget.index].value } size of title");
                          },
                          child: Obx(()=>Text(
                            controller.slideTitles[widget.index].text,
                            style: TextStyle(
                              // fontSize: controller.slideTitlesFontValue[widget.index].value,
                              fontSize: titleFontSize.value,  // use multiplier like widget.size.width * 0.5,  save o.5 inside variable then multiply withe size.width
                              color: Color(widget.slidePallet.bigTitleTColor)),
                              // textAlign: TextAlign.left,
                              )),
                        ),
                        
                        // child: TextField(
                        //   onTap: (){
                        //     controller.setValuesAsNull();
                        //     controller.isTitle.value = true;
                        //     controller.firstIndexOfFont.value = widget.index;
                        //   controller.currentFontSize.value =  widget.slidePallet.titleFontSize.value;
                        //   developer.log('pressed title slide 1 title ${controller.slideTitlesFontValue[widget.index].value } size');
                        //    developer.log("${controller.slideTitlesFontValue[widget.index].value } size of title");

                        // },
                        //                     cursorColor:  Colors.black,
                        //                     // backgroundCursorColor: Colors.white,
                        //                     // focusNode: _focusNode,
                        // // decoration: InputDecoration(
                        // //       border: InputBorder.none
                        // //     ),
                        //     maxLines: null,
                        //     readOnly: widget.isReadOnly,
                        // controller:  controller.slideTitles[widget.index],
                        // decoration: InputDecoration(
                        //   border: InputBorder.none,
                        //   contentPadding: EdgeInsets.zero,
                        //   isDense: true
                        // ),
                        // onChanged: (value){
                        // controller.myEditedPresentation.value.slides[widget.index].slideTitle = value;
                        // },
                        // style: TextStyle(
                        //     // fontSize: controller.slideTitlesFontValue[widget.index].value ,
                        //     fontSize: titleFontSize.value,
                        //     color: Color(widget.slidePallet.bigTitleTColor)),
                        // // style: widget.slidePallet.bigTitleTStyle
                        // //     .copyWith(fontSize: titleFontSize.value),
                        //     ),
                        
                      ),
                      verticalSpace(widget.size.width * 0.01),
                      IgnorePointer(
                        ignoring: widget.isReadOnly,
                        child: GestureDetector(
                          onTap: (){
                            controller.toggleVisibilityTextEditor(true);
                            controller.setValuesAsNull();
                            controller.isSectionContent.value = true;
                            controller.firstIndexOfFont.value = widget.index;
                            controller.secondIndexOfFont.value = 0;
                            controller.currentText.value = controller.slideSectionContents[widget.index][0].text;
                            controller.currentFontSize.value = controller.slideSectionContentsFontValue[widget.index][0].value ;
                            controller.currentEditedText.value = controller.slideSectionContents[widget.index][0].text;
                            developer.log('pressed title slide 1 Contents, ${controller.slideSectionContentsFontValue[widget.index][0].value } size');
                            developer.log("${controller.slideTitlesFontValue[widget.index].value } size of title");
                          },
                          child: Obx(()=>Text(
                            controller.slideSectionContents[widget.index][0].text, 
                          style: TextStyle(
                              fontSize: contentFontSize.value,
                              color: Color(widget.slidePallet.bigTitleTColor)),
                          )),
                        ),
                        // TextField(
                        //   onTap: (){
                        //     controller.setValuesAsNull();
                        //     controller.isSectionContent.value = true;
                        //     controller.firstIndexOfFont.value = widget.index;
                        //     controller.secondIndexOfFont.value = 0;

                        //   controller.currentFontSize.value = controller.slideSectionContentsFontValue[widget.index][0].value ;
                        //   developer.log('pressed title slide 1 Contents, ${controller.slideSectionContentsFontValue[widget.index][0].value } size');
                        //    developer.log("${controller.slideTitlesFontValue[widget.index].value } size of title");

                        // },
                        // cursorColor:  Colors.black,
                        // // backgroundCursorColor: Colors.white,
                        // focusNode: FocusNode(),
                        
                        // // decoration: InputDecoration(
                        // //       border: InputBorder.none
                        // //     ),
                        //     maxLines: null,
                        //     readOnly: widget.isReadOnly,
                        //     decoration: InputDecoration(
                        //       border: InputBorder.none,
                        //       contentPadding: EdgeInsets.zero,
                        //       isDense: true
                        //     ),
                        // controller : controller.slideSectionContents[widget.index][0],
                        // onChanged: (value){
                        //   controller.myEditedPresentation.value.slides[widget.index].slideSections[0].sectionContent = value;
                        // },
                        // style: TextStyle(
                        //     fontSize: controller.slideSectionContentsFontValue[widget.index][0].value,
                        //     color: Color(widget.slidePallet.bigTitleTColor)),
                        // // style: widget.slidePallet.bigTitleTStyle
                        // //     .copyWith(fontSize: widget.size.width * 0.03),
                        //       ),
                        
                      ),
                    ],
                  ),
                ),
                widget.mySlide.slideSections[0].memoryImage != null ||
                        widget.mySlide.slideSections[0].imageReference != null
                    ? Container(
                        width: widget.size.width * 0.42,
                        height: widget.size.height,
                        child: Center(child: _ImageWidget()))
                    : Container(),
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

  // Widget _ImageWidget() {
  //   return ClipPath(
  //     clipper: HexagonClipper(),
  //     child: Image.memory(
  //       widget.mySlide.slideSections[0].memoryImage!,
  //       width: widget.size.width * 0.3,
  //       height: widget.size.width * 0.3,
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }

  Widget _ImageWidget() {
    if (widget.mySlide.slideSections[0].imageReference != null) {
      return ClipPath(
        clipper: HexagonClipper(),
        child: CachedNetworkImage(
          imageUrl: "${widget.mySlide.slideSections[0].imageReference!}",
          // imageUrl: "http://aqibsiddiqui.com/images/technology5.jpg",
          width: widget.size.width * 0.3,
          height: widget.size.width * 0.3,
          fit: BoxFit.fill,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            developer.log("Error Cached Network: $error");
            return Icon(Icons.error);
          },
        ),
      );
    } else if (widget.mySlide.slideSections[0].memoryImage != null) {
      return ClipPath(
        clipper: HexagonClipper(),
        child: Image.memory(
          widget.mySlide.slideSections[0].memoryImage!,
          width: widget.size.width * 0.3,
          height: widget.size.width * 0.3,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Container(); // Handle the case where no image is available
    }
  }
}
