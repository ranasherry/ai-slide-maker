// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/modules/presentaion_generator/controllers/presentaion_generator_controller.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide1.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class SlidesFragment extends GetView<PresentaionGeneratorController> {
  const SlidesFragment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print("hello1 ${controller.myPresentation.value!.slides.length}");

    return Scaffold(
      // bottomNavigationBar: ,

      body: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: AppColors.headerContainerGradient)),
        child: Stack(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.15),
              decoration: BoxDecoration(
                  color: AppColors.fragmantBGColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Obx(() => controller.myPresentation.value != null
                  // &&
                  //         controller.myPresentation.value!.slides.length > 0
                  ? Obx(() => !controller.myPresentation.value!.slides.isEmpty
                      ? ListView.builder(
                          itemCount:
                              controller.myPresentation.value!.slides.length,
                          itemBuilder: (context, index) {
                            print("hello2");
                            return _individualSlide(index);
                          })
                      : Container(
                          child: Text("Loading..."),
                        ))
                  : Container(
                      child: Text("Loading..."),
                    )),
            ),
            footerWidget()
          ],
        ),
      ),
    );
  }

  Widget _individualSlide(int index) {
    Size size = Size(SizeConfig.blockSizeHorizontal * 90,
        SizeConfig.blockSizeHorizontal * 45);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2,
          vertical: SizeConfig.blockSizeVertical),
      child: Builder(builder: (context) {
        if (index == 0) {
          return TitleSlide1(
            mySlide: controller.myPresentation.value!.slides[index],
            slidePallet: controller.dummySlidePallet,
            size: size,
          );
        } else if (index == 1) {
          return SectionedSlide2(
            mySlide: controller.myPresentation.value!.slides[index],
            slidePallet: controller.dummySlidePallet,
            size: size,
          );
        } else {
          return SectionedSlide1(
            mySlide: controller.myPresentation.value!.slides[index],
            slidePallet: controller.dummySlidePallet,
            size: size,
          );
        }
      }),
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
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                      vertical: SizeConfig.blockSizeVertical),
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockSizeVertical * 6.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .buttonBGColor, // Button background color
                          foregroundColor: Colors.white),
                      onPressed: () {
                        // controller.RequestPresentationPlan();
                      },
                      child: Text("Save & Share")))
            ],
          ),
        ),
      ),
    );
  }
}
