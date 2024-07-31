import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/presentaion_generator/controllers/presentaion_generator_controller.dart';
import 'package:slide_maker/app/utills/app_style.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SlidesOutlinesFrag extends GetView<PresentaionGeneratorController> {
  const SlidesOutlinesFrag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: footerWidget(),
        body: SingleChildScrollView(
          child: Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 6),
                    topRight:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 6))),
            child: Column(
              children: [
                verticalSpace(SizeConfig.blockSizeVertical * 2),
                // Obx(() => Column(
                //       children: List.generate(controller.slides.length, (index) {
                //         return outline_tiles(controller.slides[index], index);
                //       }),
                //     )),
                Obx(() => ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        controller.reorderSlides(oldIndex, newIndex);
                      },
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(controller.plannedOutlines.length,
                          (index) {
                        return outline_tiles(
                            controller.plannedOutlines[index], index);
                      }),
                    )),

                GestureDetector(
                  onTap: () {
                    controller.addSlide();
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    height: SizeConfig.blockSizeVertical * 7.5,
                    width: SizeConfig.blockSizeHorizontal * 90,
                    decoration: BoxDecoration(
                        color: AppColors.textfieldcolor,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 10)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.grey.shade400,
                          ),
                          horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                          Text(
                            "Add Slide",
                            style: AppStyle.subHeadingText,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Container outline_tiles(String title, int index) {
    return Container(
      key: ValueKey(index),
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 6,
      ),
      height: SizeConfig.blockSizeVertical * 8,
      width: SizeConfig.blockSizeHorizontal * 90,
      decoration: BoxDecoration(
          color: AppColors.textfieldcolor,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 10)),
      child: TextFormField(
        onChanged: (value) {
          controller.plannedOutlines[index] = value;
        },
        controller: TextEditingController(text: title),
        cursorColor: AppColors.mainColor,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal * 3.5,
            color: AppColors.titles),
        maxLines: 3,
        decoration: InputDecoration(
          icon: Container(
            height: SizeConfig.blockSizeVertical * 4,
            width: SizeConfig.blockSizeHorizontal * 10,
            decoration: BoxDecoration(
                color: AppColors.background, shape: BoxShape.circle),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 4,
                    color: AppColors.titles),
              ),
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  controller.removeSlide(index);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              ),
              horizontalSpace(SizeConfig.blockSizeHorizontal * 4),
              ReorderableDragStartListener(
                index: index,
                child: Container(
                  // width: SizeConfig.blockSizeHorizontal * 5,
                  child: Icon(Icons.more_vert),
                ),
              )
            ],
          ),
          hintText: 'Enter Name',
          hintStyle: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.grey.shade400)),
          filled: true,
          fillColor: AppColors.textfieldcolor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.blockSizeHorizontal * 10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.blockSizeHorizontal * 10)),
          ),
        ),
      ),
    );
  }

  Widget footerWidget() {
    return Card(
      // elevation: 5.0, // Set the elevation to the desired value
      margin: EdgeInsets.zero, // Remove default margins if needed
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight * 0.17,
        decoration: BoxDecoration(
          color: AppColors.footerContainerColor,
          border: Border(
            top: BorderSide(
              color: const Color.fromARGB(
                  255, 207, 207, 207), // Set the color to grey
              width: 1.0, // Set the width of the border
            ),
          ),
        ),
        child: Container(
          height: SizeConfig.blockSizeVertical * 18,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            color: AppColors.footerContainerColor,
            // border: Border.fromBorderSide(
            //     BorderSide(color: Colors.grey.shade300, width: 2)

            //     )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      controller.switchToSelectStyle();
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 7,
                      width: SizeConfig.blockSizeHorizontal * 85,
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 8)),
                      child: Center(
                        child: Text("Next", style: AppStyle.button),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: SizeConfig.blockSizeVertical * 4,
              //   width: SizeConfig.blockSizeHorizontal * 40,
              //   decoration: BoxDecoration(
              //       color: AppColors.textfieldcolor,
              //       borderRadius: BorderRadius.circular(
              //           SizeConfig.blockSizeHorizontal * 8)),
              //   child: Center(
              //     child: Text(
              //       "1 free attempts left",
              //       style: AppStyle.subHeadingText,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
