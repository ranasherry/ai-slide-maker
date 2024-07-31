import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/headers/header1.dart';
import 'package:slide_maker/app/utills/app_style.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/presentaion_generator_controller.dart';

class PresentaionGeneratorView extends GetView<PresentaionGeneratorController> {
  const PresentaionGeneratorView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('PresentaionGeneratorView'),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          headerWidget(),
          Obx(() => Expanded(
                child: IndexedStack(
                  index: controller.currentIndex.value,
                  children: controller.mainFragments,
                ),
              ))
        ],
      ),
    );
  }

  Align footerWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 5.0, // Set the elevation to the desired value
        margin: EdgeInsets.zero, // Remove default margins if needed
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.15,
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
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical * 18,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.grey.shade300, width: 2))),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // controller.switchToSlidesOutlines();
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 7,
                          width: SizeConfig.blockSizeHorizontal * 85,
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.blockSizeHorizontal * 8)),
                          child: Center(
                            child:
                                Text("Generate a plan", style: AppStyle.button),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: SizeConfig.blockSizeVertical * 11,
                    left: SizeConfig.blockSizeHorizontal * 30,
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 4,
                      width: SizeConfig.blockSizeHorizontal * 40,
                      decoration: BoxDecoration(
                          color: AppColors.textfieldcolor,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 8)),
                      child: Center(
                        child: Text(
                          "1 free attempts left",
                          style: AppStyle.subHeadingText,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container headerWidget() {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.35,
      decoration: BoxDecoration(
          // gradient: LinearGradient(colors: AppColors.headerContainerGradient
          // )
          image: DecorationImage(
              image: AssetImage(
                AppImages.slide_background,
              ),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 6,
                horizontal: SizeConfig.blockSizeHorizontal * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 6,
                    width: SizeConfig.blockSizeHorizontal * 20,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor, shape: BoxShape.circle),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 56,
                  child: Obx(() => LinearProgressBar(
                        maxSteps: controller.mainFragments.length,
                        progressType: LinearProgressBar.progressTypeLinear,
                        currentStep: controller.currentIndex.value + 1,
                        progressColor: AppColors.textfieldcolor,
                        backgroundColor: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 6),
                        minHeight: SizeConfig.blockSizeVertical * 1,
                      )),
                ),
                Container(
                  height: SizeConfig.blockSizeVertical * 6,
                  width: SizeConfig.blockSizeHorizontal * 20,
                  decoration: BoxDecoration(
                      color: AppColors.mainColor, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      "1/2",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() => IndexedStack(
                index: controller.currentIndex.value,
                children: [
                  Header1(),
                  Header1(),
                  Header1(),
                ],
              ))
        ],
      ),
    );
  }
}
