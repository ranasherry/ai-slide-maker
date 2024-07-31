import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/modules/presentaion_generator/controllers/presentaion_generator_controller.dart';
import 'package:slide_maker/app/utills/app_style.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SlideStylesFrag extends GetView<PresentaionGeneratorController> {
  const SlideStylesFrag({super.key});

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
                  topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 6),
                  topRight:
                      Radius.circular(SizeConfig.blockSizeHorizontal * 6))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Container(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 7),
                child: Text(
                  "Recommended",
                  style: AppStyle.headingText,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 7),
                width: SizeConfig.blockSizeHorizontal * 80,
                child: Text("Styles that best match the selected templates",
                    style: AppStyle.subHeadingText),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 50,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap:
                        true, // This is important to make ListView work inside another ListView

                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 4,
                            left: SizeConfig.blockSizeHorizontal * 4,
                            bottom: SizeConfig.blockSizeVertical * 30),
                        width: SizeConfig.blockSizeHorizontal * 65,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                AppImages.slide_background,
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 4,
                            left: SizeConfig.blockSizeHorizontal * 4,
                            bottom: SizeConfig.blockSizeVertical * 30),
                        width: SizeConfig.blockSizeHorizontal * 65,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                AppImages.slide_background,
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 4,
                            left: SizeConfig.blockSizeHorizontal * 4,
                            bottom: SizeConfig.blockSizeVertical * 30),
                        width: SizeConfig.blockSizeHorizontal * 65,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                AppImages.slide_background,
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3,
                          ),
                        ),
                      )
                    ]),
              )
            ],
          ),
        )));
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
                      controller.startGeneratingSlide();
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 7,
                      width: SizeConfig.blockSizeHorizontal * 85,
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 8)),
                      child: Center(
                        child: Text("Generate Slides", style: AppStyle.button),
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
