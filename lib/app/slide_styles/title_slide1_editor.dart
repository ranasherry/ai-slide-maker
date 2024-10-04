import 'dart:math';
import 'dart:developer' as developer;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
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
      required this.isEditViewOpen});

  MySlide mySlide;
  SlidePallet slidePallet;
  Size size;
  int index;
  bool isEditViewOpen;

  @override
  State<TitleSlide1Editor> createState() => __TitleSlide1State();
}

class __TitleSlide1State extends State<TitleSlide1Editor> {
  final PresentationEditCtl controller = Get.find();
  int bgIndex = 0;
  String slideTitleValue = "";
  String sectionContent0Value = "";
  RxDouble titleFontSize = 0.0.obs;
  RxDouble contentFontSize = 0.0.obs;
  int i = 0;
  var rebuild = false;
  late Worker fontSizeWorker;
  late Worker fontWeightWorker;
  late Worker fontColorWorker;
  late Worker switchViewStateWorker;
  late Worker currentTextWorker;
  late Worker resetPropertiesWorker;
  late Worker isSelectedCheckWorker;

  Future<void> initializeSlideFontSize() async{
    controller.slideTitlesTextProperties[widget.index].fontSize = widget.mySlide.slideSections[0].memoryImage != null ||
        widget.mySlide.slideSections[0].imageReference != null ? 0.05 : 0.06;
      controller.slideSectionContentsTextProperties[widget.index][0].fontSize = 0.02;
      
    // controller.slideSectionContentsTextProperties[widget.index][0].fontColor  = Color(widget.slidePallet.bigTitleTColor);
    
    // controller.slideTitlesTextProperties[widget.index].fontColor  = Color(widget.slidePallet.bigTitleTColor);

  }
  
  @override
  // ignore: must_call_super
 void initState() {
  super.initState();
    setState(() {
    developer.log("init state run");
      initializeSlideFontSize();
      developer.log("on line 105: 1");
      controller.currentPallet = widget.slidePallet;
      controller.initializeSlidePalletAndController();
      developer.log("on line 108 : 3");
      final random = Random();
      bgIndex = random.nextInt(widget.slidePallet.imageList.length);
    });

    fontSizeWorker = ever(controller.currentFontSize, (_){
      rebuild = true;
      setState((){});
    });
    fontWeightWorker = ever(controller.currentFontWeightDouble, (_){
      setState((){});
    });
    fontColorWorker = ever(controller.currentFontColor, (_){
      setState((){});
    });
     switchViewStateWorker = ever(controller.switchViewState, (_){
      setState((){
      developer.log("switch working");
      });
    });
    currentTextWorker = ever(controller.currentText, (_){
      setState((){});
    });
    isSelectedCheckWorker = ever(controller.isSelectedCheck, (_){
      developer.log("clicked on the text ${controller.isSelectedSlideTitle[widget.index]}");
      
      setState((){});
    });
    resetPropertiesWorker = ever(controller.resetProperties, (_){
      setState(()  {
        developer.log("resetProperties");
        initializeSlideFontSize();
      developer.log("on line 151: 1");
      controller.initializeSlidePalletAndController();
      developer.log("on line 153: 3");

      });
    });


  }


      @override
  void dispose() {
    // Dispose of the ever listeners when the widget is disposed
    fontSizeWorker.dispose();
    fontWeightWorker.dispose();
    fontColorWorker.dispose();
    currentTextWorker.dispose();
    resetPropertiesWorker.dispose();
    switchViewStateWorker.dispose();
    isSelectedCheckWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.isEditViewOpen.value = widget.isEditViewOpen || controller.ignorePointer.value;
    titleFontSize.value = widget.mySlide.slideSections[0].memoryImage != null ||
        widget.mySlide.slideSections[0].imageReference != null
    ? widget.size.width * (controller.switchViewState.value ?  widget.slidePallet.slideTitlesTextProperties![widget.index].fontSize!: controller.slideTitlesTextProperties[widget.index].fontSize!)
    : widget.size.width * controller.slideTitlesTextProperties[widget.index].fontSize!;
    contentFontSize.value = widget.size.width * (controller.switchViewState.value ? widget.slidePallet.slideSectionContentsTextProperties![widget.index][0].fontSize!: controller.slideSectionContentsTextProperties[widget.index][0].fontSize!);

  developer.log("This is index in title ${widget.index}");
   developer.log(" This is the title color in title: ${controller.slideTitlesTextProperties[widget.index].fontColor!}");
   developer.log(" This is the title Size in title: ${controller.slideTitlesTextProperties[widget.index].fontSize!}");
   developer.log(" This is the title Weight in title: ${controller.slideTitlesTextProperties[widget.index].fontWeight!}");


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
                     
                        controller.textForTitleWithGestureDetector(controller.slideTitles, widget.index, controller.slideTitlesTextProperties, controller.myEditedPresentation, titleFontSize, widget.slidePallet),
                        
                      
                      verticalSpace(widget.size.width * 0.01),
                      controller.textForSlideSectionContentWithGestureDetector(controller.slideSectionContents, widget.index, 0, controller.slideSectionContentsTextProperties, controller.myEditedPresentation, contentFontSize, widget.slidePallet),
                      
                      
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

