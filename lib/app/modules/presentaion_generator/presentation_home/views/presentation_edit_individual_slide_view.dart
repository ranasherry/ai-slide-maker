import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        bottomSheet: Obx(() => Visibility(
          visible: controller.isBottomNavbarEditorVisible.value || controller.isBottomNavbarTextEditorVisible.value || controller.isBottomNavbarTextFieldVisible.value || controller.isFontSizeProviderVisible.value,
          child: Container(
            color: AppColors.background,
                width: SizeConfig.screenWidth,
                height: bottomNavbarHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    
                    Visibility(
                      visible: controller.isBottomNavbarEditorVisible.value,
                      child: Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.blockSizeVertical * 10,
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 0.2, color: Colors.black),
                            ),
                            color: AppColors.bottomNavBar),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 3,
                              left: SizeConfig.blockSizeHorizontal * 3),
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    bottom_navi_buttons(
                                        Icons.text_fields_sharp, "Navbar", () {
                                      // FocusScope.of(context)
                                      //     .requestFocus(controller.focusNode);
                                    }),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: controller.isBottomNavbarTextFieldVisible.value,
                        child:Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                          color: AppColors.bottomNavBar,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: SizeConfig.screenWidth * 0.75,
                                color: Colors.transparent,
                                margin: EdgeInsets.only(
                                  // bottom: SizeConfig.blockSizeVertical * 2,
                                  left: SizeConfig.blockSizeHorizontal * 1,
                                  
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    controller.currentEditedText.value = value;
                                    // controller.setSlidesText(value);
                                  },
                                  // onTap: (){
                                  //   controller.currentEditedText.value = controller.currentText.value;
                                  // },
                                  onTapOutside: (value){
                                  //  controller.toggleVisibilityBottomNavbarTextField(false);                    
                                  },
                                  controller: TextEditingController(
                                      text: controller.currentText.value),
                                  focusNode: _focusNode,
                                  maxLines: 4,
                                  decoration: InputDecoration(border: InputBorder.none),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  developer.log("${controller.currentText.value}");
                                  controller.setSlidesText(controller.currentEditedText.value);
                                          // FocusScope.of(context).focus(_focusNode);
                                },
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   border: Border.all(width: 2),
                                  //   borderRadius: BorderRadius.circular(10) 
                                  // ),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      developer.log("${controller.currentText.value}");
                                  controller.setSlidesText(controller.currentEditedText.value);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Color(0xFFF34709)), // Custom background color
                                    ),
                                    child: Container(
                                      height: SizeConfig.blockSizeVertical * 7,
                                      child: Icon(Icons.done,
                                      // size: 2.0,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                     
                                    )
                                     ),  
                                         )
                                ),
                              )
                            ],
                          ),
                        )),
                        Visibility(
                          visible: controller.isFontSizeProviderVisible.value,
                          child: fontSizeProvider()
                          )
                  ],
                ),
              ),
        )),
        body:
         WillPopScope(
          onWillPop: () async {
              // controller.toggleVisibilityBottomNavbarEditor(false);
              // hide editing options before get.back
              {
              await controller.toggleVisibilityTextEditor(false);
              await controller.toggleVisibilityBottomNavbarTextField(false);
              await controller.toggleVisibilityFontSizeProvider(false);
              await controller.initializeSlidesTextController();
              await controller.toggleResetFont();
                Get.back();
              return true; // Allow pop after method execution
              }
              // controller.initializeSlidesFontList();
              // controller.initializeSlidesTextController();
              // Get.back();
            },
           child: Stack(
            children: [
             
              GestureDetector(
                  onTap: () {
                    // controller.toggleVisibilityBottomNavbarEditor(false);
              //       controller.toggleVisibilityTextEditor(false);
              //     controller.toggleVisibilityBottomNavbarTextField(false);
              // controller.toggleVisibilityFontSizeProvider(false);                    
                  },
                  child: SingleChildScrollView(
                    child: Container(
                        child: Stack(children: [
                          // header start
                          Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 6.5,
                                bottom: SizeConfig.blockSizeVertical * 4),
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                border: Border(
                                    bottom: BorderSide(width: 1, color: Colors.black))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () async{
                                    // Initializing again to reset the values
                                    await controller.toggleVisibilityTextEditor(false);
                                    await controller.toggleVisibilityBottomNavbarTextField(false);
                                    await controller.toggleVisibilityFontSizeProvider(false);                           
                                    await controller.initializeSlidesTextController();
                                    await controller.toggleResetFont();
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.text_color,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Presentation Editor",
                                    style: TextStyle(
                                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                                        color: AppColors.text_color,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                              onTap: () async {
                                await controller.saveSlides(
                                    controller.currentSelectedIndex.value);
                                await homeCtl.updatePresentation(
                                    controller.myEditedPresentation.value,
                                    controller.myEditedPresentation.value
                                        .presentationId);
                                await homeCtl.updateSlidePallet(controller.currentPallet, int.parse(controller.myEditedPresentation.value.styleId.value));
                                Get.offNamedUntil(
                                    Routes.PRESENTATION_HOME,
                                    (route) =>
                                        route.settings.name == Routes.NAVVIEW ||
                                        route.settings.name == Routes.HOMEVIEW1);
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
                          Column(
                            children: [
                              Container(
                                  width: SizeConfig.screenWidth,
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 13),
                                  padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.blockSizeVertical * 4,
                                    horizontal: SizeConfig.blockSizeHorizontal * 4
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      )),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 2.5 
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: individualSlideEditorMethod(
                                          controller.currentSelectedIndex.value,
                                          controller.myPresentation,
                                          Size(SizeConfig.screenWidth * 0.95,
                                              SizeConfig.screenWidth * 0.55),
                                          false,
                                          controller.slidePallet),
                                    ),
                                  )),
                                  Visibility(
                      // visible: controller.isBottomNavbarTextEditorVisible.value,
                      child: Padding(
                        padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal * 7),
                        child: Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.blockSizeVertical * 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                              // border: Border(
                              //   top: BorderSide(width: 0.2, color: Colors.black),
                              // ),
                              border: Border.all(width: 0.05, color: Colors.black),
                              color: AppColors.white_color),
                          child: Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 1,
                                // left: SizeConfig.blockSizeHorizontal * 1
                                ),
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 1,
                                vertical: SizeConfig.blockSizeHorizontal * 1,
                              ),
                                scrollDirection: Axis.vertical,
                                children: [
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment : MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          bottom_navi_buttons(
                                              Icons.text_format, "Text", () {
                                                controller.isBottomNavbarTextFieldVisible.value = true;
                                                controller.isFontSizeProviderVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                                FocusScope.of(context).requestFocus(_focusNode);
                                              }),
                                               bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                              bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                              bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                        ],
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            bottom_navi_buttons(
                                                Icons.text_format, "Text", () {
                                                  controller.isBottomNavbarTextFieldVisible.value = true;
                                                  controller.isFontSizeProviderVisible.value = false;
                                                  // controller.isBottomNavbarEditorVisible.value = true;
                                                                      
                                                  // controller.toggleVisibilityTextEditor(false);
                                                  FocusScope.of(context).requestFocus(_focusNode);
                                                }),
                                                 bottom_navi_buttons(
                                                Icons.text_fields_rounded, "Font", () {
                                                  developer.log("pressed");
                                                  controller.isFontSizeProviderVisible.value = true;
                                                  controller.isBottomNavbarTextFieldVisible.value = false;
                                                  // controller.isBottomNavbarEditorVisible.value = true;
                                                                      
                                                  // controller.toggleVisibilityTextEditor(false);
                                                }),
                                                bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                              bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            bottom_navi_buttons(
                                                Icons.text_format, "Text", () {
                                                  controller.isBottomNavbarTextFieldVisible.value = true;
                                                  controller.isFontSizeProviderVisible.value = false;
                                                  // controller.isBottomNavbarEditorVisible.value = true;
                                                                      
                                                  // controller.toggleVisibilityTextEditor(false);
                                                  FocusScope.of(context).requestFocus(_focusNode);
                                                }),
                                                 bottom_navi_buttons(
                                                Icons.text_fields_rounded, "Font", () {
                                                  developer.log("pressed");
                                                  controller.isFontSizeProviderVisible.value = true;
                                                  controller.isBottomNavbarTextFieldVisible.value = false;
                                                  // controller.isBottomNavbarEditorVisible.value = true;
                                                                      
                                                  // controller.toggleVisibilityTextEditor(false);
                                                }),
                                                bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                              bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            bottom_navi_buttons(
                                                Icons.text_format, "Text", () {
                                                  controller.isBottomNavbarTextFieldVisible.value = true;
                                                  controller.isFontSizeProviderVisible.value = false;
                                                  // controller.isBottomNavbarEditorVisible.value = true;
                                                                      
                                                  // controller.toggleVisibilityTextEditor(false);
                                                  FocusScope.of(context).requestFocus(_focusNode);
                                                }),
                                                 bottom_navi_buttons(
                                                Icons.text_fields_rounded, "Font", () {
                                                  developer.log("pressed");
                                                  controller.isFontSizeProviderVisible.value = true;
                                                  controller.isBottomNavbarTextFieldVisible.value = false;
                                                  // controller.isBottomNavbarEditorVisible.value = true;
                                                                      
                                                  // controller.toggleVisibilityTextEditor(false);
                                                }),
                                                bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                              bottom_navi_buttons(
                                              Icons.text_fields_rounded, "Font", () {
                                                developer.log("pressed");
                                                controller.isFontSizeProviderVisible.value = true;
                                                controller.isBottomNavbarTextFieldVisible.value = false;
                                                // controller.isBottomNavbarEditorVisible.value = true;
                                                                    
                                                // controller.toggleVisibilityTextEditor(false);
                                              }),
                                          ],
                                        ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                            ],
                          )
                        ])),
                  )),
            ],
                   ),
         ));
  }

  Padding bottom_navi_buttons(
      IconData icon, text, Function definedFunction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Obx(()=>IgnorePointer(
        ignoring: false,
        child: GestureDetector(
          onTap: () {
            definedFunction();
          },
          child: Container(
              child: Column(
            children: [
              Container(
                child: Icon(
                  icon,
                  color: controller.isBottomNavbarTextEditorVisible.value? Colors.black87 : Colors.black45,
                  size: SizeConfig.blockSizeHorizontal * 10,
                ),
              ),
              Container(
                  child: Text(
                text,
                style: controller.isBottomNavbarTextEditorVisible.value? TextStyle(fontWeight: FontWeight.w700):TextStyle(fontWeight: FontWeight.w700, color: Colors.black45) ,
              )),
            ],
          )),
        ),
      ),
    ));
  }
   Expanded fontSizeProvider() {
    return Expanded(
      child: Container(          
            decoration: BoxDecoration(
              color: AppColors.bottomNavBar,
              // borderRadius: BorderRadius.circular(30)
              border: Border.all(width: 0.5)
            ),
            // padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 6.5),
      
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                  GestureDetector(
                     onTap: (){
                      //  controller.currentFontSize.value += 0.005;
                      //  controller.test.value = true;
                      //  controller.setFontValue(true);
                      //  print("${controller.currentFontSize.value} This is current font value");
                       
                     },
                     child: ElevatedButton(
                      onPressed: (){
                        controller.currentFontSize.value += 0.005;
                       controller.test.value = true;
                       controller.setFontValue(true);
                       print("${controller.currentFontSize.value} This is current font value");
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFF34709))
                      ),
                       child: Container(
                        height: SizeConfig.blockSizeVertical * 6,
                        //  padding: EdgeInsets.all(5),
                        //  decoration: BoxDecoration(
                        //    border:Border.all(
                        //      color: Colors.black
                        //    ),
                        //    borderRadius: BorderRadius.circular(20)
                        //     ),
                            child: Icon(Icons.add),
                       ),
                     ),
                      ),
                      Container(
                       // child: Text(controller.slideTitlesFontValue.value[0].toString()),
                       child:Obx(()=> Text(controller.currentFontSize.value.toStringAsFixed(2),
                       style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeHorizontal * 6,
                       ),),
                      )
                      ),
                       GestureDetector(
                     onTap: (){
                      //  controller.currentFontSize.value -=  0.005;
                      //  controller.test.value= false;
                      //  controller.setFontValue(false);
      
                     },
                     child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFF34709))
                      ),
                      onPressed: (){
                         controller.currentFontSize.value -=  0.005;
                       controller.test.value= false;
                       controller.setFontValue(false);
                      },
                       child: Container(
                        height: SizeConfig.blockSizeVertical * 6,
                        //  padding: EdgeInsets.all(5),
                        //  decoration: BoxDecoration(
                        //    border:Border.all(
                        //      color: Colors.black
                        //    ),
                        //    borderRadius: BorderRadius.circular(20)
                        //     ),
                            child: Icon(Icons.remove),
                       ),
                     ),
                      ),
                 ],)
             ),
    );
  }
}
