import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_home_controller.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_editing_methods.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class PresentationEditIndividualSlideView extends GetView<PresentationEditCtl> {
  PresentationEditIndividualSlideView({super.key});
  PresentationHomeController homeCtl = Get.find();
  
  final FocusNode _focusNode = FocusNode();
  double bottomNavbarHeight = SizeConfig.blockSizeVertical * 13.5;
    final WidgetStateProperty<Icon?> switchIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.edit, color: Colors.black);
      }
        return const Icon(Icons.remove_red_eye_outlined);
    },
  );
  final WidgetStateProperty<Color?> switchThumbColor = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Color.fromARGB(255, 255, 255, 255);
    }
    return AppColors.mainColor;
  });
   final WidgetStateProperty<Color?> switchTrackColor = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
        return AppColors.mainColor;

    }
      return const Color.fromARGB(255, 255, 255, 255);
  });

  // selectTitleOnInit();
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
        backgroundColor: AppColors.white_color,
        resizeToAvoidBottomInset: true,
        bottomSheet: Obx(() => Visibility(
              visible: controller.isBottomNavbarEditorVisible.value ||
                  controller.isBottomNavbarTextEditorVisible.value ||
                  controller.isBottomNavbarTextFieldVisible.value ||
                  controller.isFontSizeProviderVisible.value,
              child: Container(
                color: Colors.transparent,
                width: SizeConfig.screenWidth,
                height: bottomNavbarHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => Visibility(
                          visible:
                              controller.isBottomNavbarTextEditorVisible.value,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              width: SizeConfig.screenWidth,
                              height: bottomNavbarHeight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  // border: Border(
                                  //   top: BorderSide(width: 0.2, color: Colors.black),
                                  // ),
                                  border: Border(
                                    left: BorderSide(
                                        width: 3,
                                        color: Color.fromARGB(255, 199, 53, 0)),
                                    top: BorderSide(
                                        width: 3,
                                        color: Color.fromARGB(255, 199, 53, 0)),
                                    right: BorderSide(
                                        width: 3,
                                        color: Color.fromARGB(255, 199, 53, 0)),
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.mainColor,
                                        Color.fromARGB(255, 190, 51, 0)
                                      ])),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 3,
                                  // left: SizeConfig.blockSizeHorizontal * 1
                                ),
                                child: Visibility(
                                  // visible: controller.isBottomNavbarTextEditorVisible.value,
                                  child: ListView(
                                      padding: EdgeInsets.only(
                                        // right: SizeConfig.blockSizeHorizontal * 1,
                                        // left: SizeConfig.blockSizeHorizontal * 1,
                                        // bottom : SizeConfig.blockSizeHorizontal * 7,
                                        // top : SizeConfig.blockSizeHorizontal * 1,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Container(
                                          // color: Colors.pinkAccent,
                                          width : SizeConfig.screenWidth,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              bottom_navi_buttons(
                                                  FaIcon(
                                                    FontAwesomeIcons.font,
                                                    color: AppColors.mainColor,
                                                    size: SizeConfig.blockSizeHorizontal * 6,
                                                  ), "Text", () async{
                                                await controller.toggleVisibilityTextProperties(false, false, false, true);
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                          
                                                controller
                                                    .toggleVisibilityTextEditor(
                                                        false);
                                                FocusScope.of(context)
                                                    .requestFocus(_focusNode);
                                              }),
                                              bottom_navi_buttons(
                                                  FaIcon(
                                                      FontAwesomeIcons.textWidth,
                                                      color: AppColors.mainColor,
                                                      size: SizeConfig.blockSizeHorizontal * 6,
                                                    ),
                                                  "Size", () async{
                                                developer.log("pressed");
                                                await controller.toggleVisibilityTextProperties(true, false, false, false);
                                          
                                              }),
                                              bottom_navi_buttons(
                                                  FaIcon(
                                                    FontAwesomeIcons.bold,
                                                    color: AppColors.mainColor,
                                                    size: SizeConfig.blockSizeHorizontal * 6,
                                                  ),
                                                  "Bold", () async{
                                                  await controller.toggleVisibilityTextProperties(false, true, false, false);
                                          
                                                developer.log("pressed");
                                                
                                              }),
                                              bottom_navi_buttons(
                                                  FaIcon(
                                                    FontAwesomeIcons.palette,
                                                    color: AppColors.mainColor,
                                                    size: SizeConfig.blockSizeHorizontal * 6,
                                                  ),
                                                  "Color", () async{
                                                  await controller.toggleVisibilityTextProperties(false, false, true, false);
                                          
                                                developer.log("pressed");
                                                
                                              }),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        )),
                    Visibility(
                        visible:
                            controller.isBottomNavbarTextFieldVisible.value,
                        child: Container(
                          height: bottomNavbarHeight,
                          decoration: BoxDecoration(
                            color: AppColors.edit_view_bg,
                            border: Border(top: BorderSide(
                              color: AppColors.mainColor ,
                             width: 3)),
                             borderRadius: BorderRadius.circular(15)
                             ),

                          // decoration: BoxDecoration(
                          //     // border: Border.all(width: 0.5),
                          //     gradient: LinearGradient(
                          //         begin: Alignment.topCenter,
                          //         end: Alignment.bottomCenter,
                          //         colors: [
                          //       AppColors.mainColor,
                          //       Color.fromARGB(255, 190, 51, 0)
                          //     ])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth * 0.75,
                                // color: AppColors.mainColor,
                                margin: EdgeInsets.only(
                                  // bottom: SizeConfig.blockSizeVertical * 2,
                                  left: SizeConfig.blockSizeHorizontal * 1,
                                ),
                                decoration: BoxDecoration(
                                  // border: Border(top: BorderSide(width: 1 , color: AppColors.mainColor))
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    controller.currentEditedText.value = value;
                                    // controller.setSlidesText(value);
                                  },
                                  // onTap: (){
                                  //   controller.currentEditedText.value = controller.currentText.value;
                                  // },
                                  onTapOutside: (value) {
                                    //  controller.toggleVisibilityBottomNavbarTextField(false);
                                  },
                                  controller: TextEditingController(
                                      text: controller.currentText.value),
                                  focusNode: _focusNode,
                                  maxLines: 4,
                                  style: TextStyle(color: Colors.black),

                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                             
                                 ElevatedButton(
                                    onPressed: () {
                                      controller
                                          .toggleVisibilityBottomNavbarTextField(
                                              false);
                                      controller
                                          .toggleVisibilityTextEditor(true);
                                      developer.log(
                                          "${controller.currentText.value}");
                                      controller.setSlidesText(
                                          controller.currentEditedText.value);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Color(
                                              0xFFF34709)), // Custom background color
                                              elevation: WidgetStatePropertyAll(5.0),
                                              shadowColor: WidgetStatePropertyAll(Colors.black)
                                    ),
                                    child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 7,
                                        child: Icon(
                                          Icons.done,
                                          // size: 2.0,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        )),
                                  )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )),
        body: WillPopScope(
          onWillPop: () async {
            // controller.toggleVisibilityBottomNavbarEditor(false);
            // hide editing options before get.back
            {
              await controller.backButtonAction();
              Get.back();
              return true; // Allow pop after method execution
            }
            // controller.initializeSlidesFontList();
            // controller.initializeSlidesTextController();
            // Get.back();
          },
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
                child: Stack(
                  children: [
                Container(
                padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 6.5,
                    bottom: SizeConfig.blockSizeVertical * 5),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.black))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        // Initializing again to reset the values
                        developer.log("pressed back button");
                        await controller.backButtonAction();
                        Get.back();
                      },
                      child: Container(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.text_color,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Presentation Editor",
                        style: TextStyle(
                            fontSize:
                                SizeConfig.blockSizeHorizontal * 5,
                            color: AppColors.text_color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        EasyLoading.show(status :"Saving..");
                        await controller.saveSlides(
                            controller.currentSelectedIndex.value);
                        await homeCtl.updatePresentation(
                            controller.myEditedPresentation.value,
                            controller.myEditedPresentation.value
                                .presentationId);
                        await homeCtl.updateSlidePallet(
                            controller.currentPallet,
                            int.parse(controller.myEditedPresentation
                                .value.styleId.value));
                        await EasyLoading.dismiss();
                        await EasyLoading.show(status : "Saved", indicator: IntrinsicWidth());
                        await EasyLoading.dismiss();
                        Get.offNamedUntil(
                            Routes.PRESENTATION_HOME,
                            (route) =>
                                route.settings.name == Routes.NAVVIEW ||
                                route.settings.name ==
                                    Routes.HOMEVIEW1);
                      },
                      child: Container(
                          child: Icon(
                        Icons.save_sharp,
                        color: Colors.white,
                        size: SizeConfig.blockSizeHorizontal * 7.5,
                      )),
                    )
                  ],
                ),
                              ),
                              //header end
                              // body content
                              Container(
                padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 13.2
                    ),
                    // margin: EdgeInsets.only(
                    // top: SizeConfig.blockSizeVertical * 13.2
                    // ),
                child: GestureDetector(
                  onTap: () {
                          // controller.toggleVisibilityBottomNavbarEditor(false);
                          controller.hideEditingOptions();
                        },
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight -
                        SizeConfig.blockSizeVertical * 13.2,
                    decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 143, 78, 60),
                        color: AppColors.edit_view_bg,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        )),
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              
                      children: [
                        Padding(
                           padding: EdgeInsets.only(
                              top:
                                  SizeConfig.blockSizeHorizontal * 11,
                              left: SizeConfig.blockSizeVertical * 17,
                              // right:SizeConfig.blockSizeVertical * 15
                                  ),
                          child: Container(
                            width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight * 0.05,
                            child: Text("Toggle States"  , style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4, fontWeight: FontWeight.bold))
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top:
                                  SizeConfig.blockSizeHorizontal * 22,
                              // left: SizeConfig.blockSizeVertical * 15,
                              // right:
                              //     SizeConfig.blockSizeVertical * 15
                              ),
                          child: Container(
                            width: SizeConfig.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Text("Orignal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: SizeConfig.blockSizeHorizontal * 4.5))
                                ),
                                Container(
                                  // color: Colors.red,
                                      // width: SizeConfig.screenWidth,
                                      height: SizeConfig.screenHeight * 0.05,
                                      padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Transform.scale(
                                    scaleX: 1.7,
                                    scaleY: 1.6,
                                      
                                      child: Obx(()=>Switch(
                                        value : controller.switchViewState.value,
                                        thumbIcon: switchIcon,
                                        thumbColor: switchThumbColor,
                                        trackColor: switchTrackColor,
                                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                                        onChanged: (bool value){
                                          if(value == true){
                                            controller.hideEditingOptions();
                                            controller.ignorePointer.value =  true;
                    
                                          }
                                          if(value == false){
                                            controller.setPreviouslySelectedBeforeToggleState();
                                            controller.ignorePointer.value = false;
                                          }
                                          developer.log("Before change ${controller.switchViewState.value}");
                                          controller.switchViewState.value = value;
                                          developer.log("After change ${controller.switchViewState.value}");
                                  
                                        }
                                      ))),
                                ),
                                Container(
                                  child: Text("Edited", style: TextStyle(fontWeight: FontWeight.bold, fontSize: SizeConfig.blockSizeHorizontal * 4.5))
                                  )
                              ],
                            ),
                          )
                        ),
                        Container(
                            child: Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.blockSizeVertical *
                                    20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: individualSlideEditorMethod(
                                  controller
                                      .currentSelectedIndex.value,
                                  controller.myPresentation,
                                  Size(SizeConfig.screenWidth * 0.95,
                                      SizeConfig.screenWidth * 0.55),
                                  true,
                                  controller.slidePallet),
                            ),
                          ),
                        )),
                        Obx(() => Visibility(
                            visible: controller
                                .isFontSizeProviderVisible.value,
                            child: fontSizeProvider())),
                            Obx(() => Visibility(
                            visible: controller
                                .isFontWeightProviderVisible.value,
                            child: fontWeightProvider())),
                            Obx(() => Visibility(
                            visible: controller
                                .isFontColorProviderVisible.value,
                            child: fontColorProvider())),
                      ],
                    ),
                  ),
                ),
                              )
                            ])),
          ),
        ));
  }

  Padding bottom_navi_buttons(icon, text, Function definedFunction) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 4,
        // vertical: SizeConfig.blockSizeVertical * 3
      ),
      child: GestureDetector(
        onTap: () {
          definedFunction();
        },
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(11),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(50),
            shape : BoxShape.circle,
            color: Colors.white,
            ),
              child: icon,
            ),
            Container(
                child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  color: AppColors.white_color),
            )),
          ],
        ),
      ),
    );
  }

  fontSizeProvider() {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 130,
        bottom: SizeConfig.blockSizeHorizontal * 33,
      ),
      child: Container(
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              ),
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeHorizontal * 25,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  ),
                child: Column(
                  children: [
                    Center(
                        child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 1),
                      height: SizeConfig.screenHeight * 0.055,
                      child: Text(
                        "Font Size",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: SizeConfig.blockSizeHorizontal * 5),
                      ),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Min" , style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4.5, fontWeight: FontWeight.bold))
                          ),
  
                        Obx(()=>Slider(
                          value: controller.currentFontSize.value,
                          max: controller.setMaxFontSize(),
                          min: controller.setMinFontSize(),
                          onChanged: (value) {
                            controller.setFontValue(value);
                            
                          },
                          activeColor: AppColors.mainColor,
                          inactiveColor: Color.fromARGB(255, 204, 134, 109),

                        )),
                        Container(child: Text("Max" , style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4.5, fontWeight: FontWeight.bold)))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
    fontWeightProvider() {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 130,
        bottom: SizeConfig.blockSizeHorizontal * 33,
      ),
      child: Container(
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              ),
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeHorizontal * 25,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  ),
                child: Column(
                  children: [
                    Center(
                        child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 1),
                      height: SizeConfig.screenHeight * 0.055,
                      child: Text(
                        "Bold",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: SizeConfig.blockSizeHorizontal * 5),
                      ),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Min" , style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4.5, fontWeight: FontWeight.bold))
                          ),
  
                        Obx(()=>Slider(
                          value: controller.currentFontWeightDouble.value,
                           max: 6,
                          min: 1,
                          divisions : 5,
                          onChanged: (value) {
                            controller.setFontWeight(value);
                            developer.log("font weight value ${value}");
                          },
                          activeColor: AppColors.mainColor,
                          inactiveColor: Color.fromARGB(255, 204, 134, 109),

                        )),
                        Container(child: Text("Max" , style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4.5, fontWeight: FontWeight.bold)))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
   fontColorProvider() {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 105,
        // bottom: SizeConfig.blockSizeHorizontal * 63,
      ),
      child: Container(
        width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.35,
        decoration: BoxDecoration(
              ),
        child: SizedBox.shrink(
          child: Obx(()=>ColorPicker(
            pickerColor: controller.currentFontColor.value,
             onColorChanged: controller.setFontColor,
             pickerAreaHeightPercent: SizeConfig.screenHeight * 0.0005,
              enableAlpha: true,
               showLabel: false,
               pickerAreaBorderRadius: BorderRadius.all(Radius.circular(15)),
               displayThumbColor: true,
               )),
        ),
      ),
    );
   }
}
