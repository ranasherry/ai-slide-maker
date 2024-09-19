// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import "dart:developer" as developer;
import 'package:get/get.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/views/presentation_edit_view.dart';
import 'package:slide_maker/app/modules/presentaion_generator/controllers/presentaion_generator_controller.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide1.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

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
            // gradient:
            //     LinearGradient(colors: AppColors.headerContainerGradient)
            ),
        child: Stack(
          children: [
            Container(
                width: SizeConfig.screenWidth,
                padding:
                    EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.15),
                decoration: BoxDecoration(
                    color: AppColors.fragmantBGColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Obx(() => !controller.myPresentation.value.slides.isEmpty
                    ? Obx(() => ListView.builder(
                        itemCount: controller.isSlidesGenerated.value
                            ? controller.myPresentation.value.slides.length
                            : controller.myPresentation.value.slides.length + 1,
                        itemBuilder: (context, index) {
                          print("hello2");
                          if (controller.isSlidesGenerated.value) {
                            return _individualSlide(index);
                          } else {
                            if (index <=
                                controller.myPresentation.value.slides.length) {
                              return _individualSlide(index);
                            } else {
                              Size size = Size(
                                  SizeConfig.blockSizeHorizontal * 90,
                                  SizeConfig.blockSizeHorizontal * 45);
                              Container(
                                width: size.width,
                                height: size.height,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(controller
                                            .selectedPallet
                                            .value
                                            .imageList[0]))),
                                child: CircularProgressIndicator(),
                              );
                            }
                          }
                        }))
                    : Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight * 0.5,
                        child: Center(child: CircularProgressIndicator()),
                      ))),

            footerWidget(),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Container(
            //     margin: EdgeInsets.symmetric(
            //         horizontal: SizeConfig.blockSizeHorizontal * 5),
            //     child: GestureDetector(
            //       onTap: () {
            //         int index =
            //             palletList.indexOf(controller.selectedPallet.value);
            //         index++;
            //         if (index < palletList.length) {
            //           controller.selectedPallet.value = palletList[index];
            //         } else {
            //           controller.selectedPallet.value = palletList[0];
            //         }
            //       },
            //       child: Container(
            //         child: Icon(Icons.arrow_forward_ios),
            //       ),
            //     ),
            //   ),
            // )
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
          return Obx(() => TitleSlide1(
                mySlide: controller.myPresentation.value.slides[index],
                slidePallet: controller.selectedPallet.value,
                size: size,
              ));
        } else {
          //? Sections
          if (index == 1) {
            return Obx(() => SectionedSlide2(
                  mySlide: controller.myPresentation.value.slides[index],
                  slidePallet: controller.selectedPallet.value,
                  size: size,
                ));
          } else {
            return Obx(() => SectionedSlide1(
                  mySlide: controller.myPresentation.value.slides[index],
                  slidePallet: controller.selectedPallet.value,
                  size: size,
                ));
          }
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                      vertical: SizeConfig.blockSizeVertical),
                  width: SizeConfig.screenWidth * 0.4,
                  height: SizeConfig.blockSizeVertical * 6.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .buttonBGColor, // Button background color
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        // controller.RequestPresentationPlan();
                        if (controller.isSlidesGenerated.value) {
                          // controller.createPresentation();
                          developer.log("Moving to home screen.");
                          await ComFunction.GotoHomeThenPresHome();
                          // Get.toNamed(Routes.PresentationOpenView, arguments: [controller.myPresentation.value, controller.selectedPallet.value]);
                          AppLovinProvider.instance.showInterstitial(() {});
                        } else {
                          EasyLoading.showToast(
                              "Please Wait for remaining slides to be Generated..",
                              duration: Durations.extralong2);
                        }
                      },
                      child: Text("Save"))),
                  //      Container(
                  // margin: EdgeInsets.symmetric(
                  //     horizontal: SizeConfig.blockSizeHorizontal * 6,
                  //     vertical: SizeConfig.blockSizeVertical),
                  // width: SizeConfig.screenWidth * 0.3,
                  // height: SizeConfig.blockSizeVertical * 6.5,
                  // child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: AppColors
                  //             .buttonBGColor, // Button background color
                  //         foregroundColor: Colors.white),
                  //     onPressed: () {
                  //       // controller.RequestPresentationPlan();
                  //       if (controller.isSlidesGenerated.value) {
                  //         Get.toNamed(Routes.PresentationEditView, arguments: [controller.myPresentation.value]);
                  //         AppLovinProvider.instance.showInterstitial(() {});
                  //       } else {
                  //         EasyLoading.showToast(
                  //             "Please Wait for remaining slides to be Generated..",
                  //             duration: Durations.extralong2);
                  //       }
                  //     },
                  //     child: Text("Edit"))),
                     
            ],
          ),
        ),
      ),
    );
  }
}
