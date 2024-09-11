import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/views/presentation_edit_view.dart';
import 'package:slide_maker/app/modules/home/my_drawar.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_open_ctl.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_editing_methods.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_helping_methods.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class PresentationOpenView extends GetView<PresentationOpenCtl> {
  PresentationOpenView({super.key});
  PresentationEditCtl presEditCtl = Get.find();
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
// presEditCtl.initializeSlidesFontList();
// presEditCtl.initializeSlidesTextController();
    return Scaffold(
      // drawer: MyDrawer(),
      // key: _scaffoldKey,
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical * 7,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            color: AppColors.textfieldcolor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                topRight: Radius.circular(SizeConfig.blockSizeHorizontal * 3))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 1),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // bottom_navi_bar_items(Icons.copy, "Dupicate", () {}),
              bottom_navi_bar_items(Icons.share, "Share", () {
                controller.createPresentation();
              }),
              bottom_navi_bar_items(Icons.edit, "Edit", () {
                Get.toNamed(Routes.PresentationEditView, arguments: [controller.myPresentation.value]);
              }),
              // bottom_navi_bar_items(Icons.delete, "Delete", () {
              //   controller.deleteSlide(controller.currentSelectedIndex.value);
              // }),
              // bottom_navi_bar_items(
              //     Icons.published_with_changes_outlined, "Change Template", () {
              //   controller.changePallet();
              // }),
            ],
          ),
        ),
      ),

      // backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 6,
                vertical: SizeConfig.blockSizeVertical * 0),
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            // color: Colors.blue,
            // height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // _scaffoldKey.currentState!.openDrawer();
                    Get.back();
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 5,
                    width: SizeConfig.blockSizeHorizontal * 10,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ),
                Spacer(),
                Obx(() => Container(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 5),
                      child: Text(
                        controller.presentationTitle.value,
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5),
                      ),
                    )),
                Spacer()
              ],
            ),
          ),
          Container(
              width: SizeConfig.screenWidth,
              // padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.03),
              decoration: BoxDecoration(
                  // color: AppColors.fragmantBGColor,
                  borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(SizeConfig.blockSizeHorizontal * 4),
                      topRight:
                          Radius.circular(SizeConfig.blockSizeHorizontal * 4))),
              child: Obx(() => !controller.myPresentation.value.slides.isEmpty
                  ? Column(
                      children: [
                        Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.45,
                          child: Center(
                            child: Container(
                              // width: SizeConfig.screenWidth * 0.92,
                              height: SizeConfig.screenWidth * 0.5,
                              child: Obx(() => ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: individualSlideEditorMethod(
                                      controller.currentSelectedIndex.value,
                                      controller.myPresentation,
                                      Size(SizeConfig.screenWidth * 0.9,
                                          SizeConfig.screenWidth * 0.5),
                                          true
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Obx(() => Container(
                              height: SizeConfig.blockSizeVertical * 33,
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2,
                                  bottom: SizeConfig.blockSizeVertical * 2),
                              decoration: BoxDecoration(
                                  color: AppColors.textfieldcolor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          SizeConfig.blockSizeHorizontal * 4),
                                      topLeft: Radius.circular(
                                          SizeConfig.blockSizeHorizontal * 4))),
                              child: GridView.builder(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.blockSizeHorizontal * 5,
                                      right:
                                          SizeConfig.blockSizeHorizontal * 5),
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
                                        (SizeConfig.blockSizeHorizontal * 85) /
                                            3, // Width of each grid item
                                        (SizeConfig.blockSizeHorizontal *
                                            45) // Height of each grid item
                                        );
                                    print("hello2");
                                    return GestureDetector(
                                      onTap: () {
                                        controller.currentSelectedIndex.value =
                                            index;
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.blockSizeHorizontal * 2),
                                        clipBehavior: Clip.hardEdge,
                                        child: SizedBox(
                                          width: size.width,
                                          height: size.height,
                                          child: Stack(
                                            children: [
                                              individualSlideEditorMethod(
                                                index,
                                                controller.myPresentation,
                                                size,
                                                true
                                              ),
                                              Obx(() => controller
                                                          .currentSelectedIndex
                                                          .value ==
                                                      index
                                                  ? Container(
                                                      width: size.width,
                                                      height: size.height,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.1)),
                                                      child: Center(
                                                        child:
                                                            Icon(Icons.check),
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
        ],
      ),
    );
  }

  Widget bottom_navi_bar_items(IconData icon, String text, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            size: SizeConfig.blockSizeHorizontal * 5,
            color: AppColors.mainColor,
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 16,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3,
                        color: AppColors.titles)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
