import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:slide_maker/app/data/comment.dart';
import 'package:slide_maker/app/data/like.dart';
import 'package:slide_maker/app/modules/home/my_drawar.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_home_controller.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_editing_methods.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/modules/presentaion_generator/controllers/presentaion_generator_controller.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_helping_methods.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';

class PresentationEditView extends GetView<PresentationEditCtl> {
  PresentationEditView({Key? key}) : super(key: key);
  PresentationHomeController homeCtl = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      bottomNavigationBar: Container(
        // padding: EdgeInsets.only(
        //     top: SizeConfig.blockSizeVertical * 3,
        //     bottom: SizeConfig.blockSizeVertical * 3
        //   ),
        height: SizeConfig.blockSizeVertical * 8,
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  width: SizeConfig.blockSizeHorizontal * 0.5,
                  color: Colors.red),
              right: BorderSide(
                  width: SizeConfig.blockSizeHorizontal * 0.5,
                  color: Colors.red),
              left: BorderSide(
                  width: SizeConfig.blockSizeHorizontal * 0.5,
                  color: Colors.red),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            botton_navi_button("Save", () async {
              print("${controller.myEditedPresentation.value.presentationId}");
              await homeCtl.updatePresentation(
                  controller.myEditedPresentation.value,
                  controller.myEditedPresentation.value.presentationId);
              // Get.toNamed(Routes.PRESENTATION_HOME, arguments: ["Presentation Updated"]);
              // Get.offAndToNamed(Routes.PRESENTATION_HOME);
              Get.offNamedUntil(
                  Routes.PRESENTATION_HOME,
                  (route) =>
                      route.settings.name == Routes.NAVVIEW ||
                      route.settings.name == Routes.HOMEVIEW1);
              // Get.offNamedUntil(Routes.PRESENTATION_HOME, (route) => false);
              // ComFunction.GotoHomeScreen();
              print("Presentation Updated");
            }),
          ],
        ),
      ),
      body:
          // Padding(
          //   padding: EdgeInsets.only(
          // top: SizeConfig.blockSizeVertical * 6,
          // right: SizeConfig.blockSizeHorizontal * 2,
          // left: SizeConfig.blockSizeHorizontal * 2,
          //   ),
          // child:
          Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 6.5,
                  bottom: SizeConfig.blockSizeVertical * 3),
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 5,
                        right: SizeConfig.blockSizeHorizontal * 18),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
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
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          color: AppColors.text_color,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // body content
            Container(
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 12),
              decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Container(
                //   margin: EdgeInsets.symmetric(
                //   vertical: SizeConfig.blockSizeVertical * 4,
                //   horizontal: SizeConfig.blockSizeHorizontal * 6,
                // ),
                child: Container(
                    width: SizeConfig.screenWidth,
                    // padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.03),
                    decoration: BoxDecoration(
                        // color: AppColors.fra
                        // gmantBGColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 4),
                            topRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 4))),
                    child: Obx(() => !controller
                            .myPresentation.value.slides.isEmpty
                        ? Column(
                            children: [
                              Container(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight * 0.3,
                                child: Center(
                                  child: Container(
                                    // width: SizeConfig.screenWidth * 0.92,
                                    height: SizeConfig.screenWidth * 0.5,
                                    child: Obx(() => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: individualSlideEditorMethod(
                                              controller
                                                  .currentSelectedIndex.value,
                                              controller.myPresentation,
                                              Size(SizeConfig.screenWidth * 0.9,
                                                  SizeConfig.screenWidth * 0.5),
                                              false),
                                        )),
                                  ),
                                ),
                              ),
                              Obx(() => Container(
                                    height: SizeConfig.blockSizeVertical * 33,
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.blockSizeVertical * 2,
                                        bottom:
                                            SizeConfig.blockSizeVertical * 2),
                                    decoration: BoxDecoration(
                                        color: AppColors.textfieldcolor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                SizeConfig.blockSizeHorizontal *
                                                    4),
                                            topLeft: Radius.circular(
                                                SizeConfig.blockSizeHorizontal *
                                                    4))),
                                    child: GridView.builder(
                                        padding: EdgeInsets.only(
                                            left:
                                                SizeConfig.blockSizeHorizontal *
                                                    5,
                                            right:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              3, // Number of children in each row
                                          crossAxisSpacing:
                                              10.0, // Spacing between columns
                                          mainAxisSpacing:
                                              10.0, // Spacing between rows
                                          childAspectRatio: (SizeConfig
                                                      .blockSizeHorizontal *
                                                  85) /
                                              (SizeConfig.blockSizeHorizontal *
                                                  45), // Adjust based on the size you want for the items
                                        ),
                                        itemCount: controller
                                            .myPresentation.value.slides.length,
                                        itemBuilder: (context, index) {
                                          Size size = Size(
                                              (SizeConfig.blockSizeHorizontal *
                                                      85) /
                                                  3, // Width of each grid item
                                              (SizeConfig.blockSizeHorizontal *
                                                  45) // Height of each grid item
                                              );
                                          print("hello2");
                                          return GestureDetector(
                                            onTap: () {
                                              controller.currentSelectedIndex
                                                  .value = index;
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius
                                                  .circular(SizeConfig
                                                          .blockSizeHorizontal *
                                                      2),
                                              clipBehavior: Clip.hardEdge,
                                              child: SizedBox(
                                                width: size.width,
                                                height: size.height,
                                                child: Stack(
                                                  children: [
                                                    individualSlideEditorMethod(
                                                        index,
                                                        controller
                                                            .myPresentation,
                                                        size,
                                                        true),
                                                    Obx(() => controller
                                                                .currentSelectedIndex
                                                                .value ==
                                                            index
                                                        ? Container(
                                                            width: size.width,
                                                            height: size.height,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.1)),
                                                            child: Center(
                                                              child: Icon(
                                                                  Icons.check),
                                                            ),
                                                          )
                                                        : Container())
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )),
                            ],
                          )
                        : Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight * 0.5,
                            child: Center(child: CircularProgressIndicator()),
                          ))),
              ),
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton botton_navi_button(String buttonText, Function onPressed) {
    return ElevatedButton.icon(
      onPressed: () {
        onPressed();
      },
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
          fixedSize: Size(100, 50),
          backgroundColor: AppColors.buttonBGColor,
          foregroundColor: AppColors.text_color),
    );
  }
}
