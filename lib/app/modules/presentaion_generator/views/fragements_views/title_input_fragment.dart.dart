// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/presentaion_generator/controllers/presentaion_generator_controller.dart';
import 'package:slide_maker/app/utills/app_style.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class titleInputFragment extends GetView<PresentaionGeneratorController> {
  const titleInputFragment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              // height: SizeConfig.blockSizeVertical * 50,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                  color: Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(SizeConfig.blockSizeHorizontal * 6),
                      topRight:
                          Radius.circular(SizeConfig.blockSizeHorizontal * 6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    child: Text(
                      "The topic of the presentation",
                      style: AppStyle.headingText,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    width: SizeConfig.blockSizeHorizontal * 80,
                    child: Text(
                        "Describe in as much detail as possible what your presentation will be about.",
                        style: AppStyle.subHeadingText),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 6),
                    height: SizeConfig.blockSizeVertical * 10,
                    decoration: BoxDecoration(
                        color: AppColors.textfieldcolor,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 6)),
                    child: Obx(
                      () => TextFormField(
                        controller: controller.titleTextCTL,
                        onChanged: (text) {
                          // Update the observable text in the controller
                          controller.updateText(text);
                        },
                        textAlign: TextAlign.start,
                        cursorColor: AppColors.mainColor,
                        style: AppStyle.headingText,
                        decoration: InputDecoration(
                          hintText: 'Enter title',
                          hintStyle: GoogleFonts.robotoFlex(
                              textStyle: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 6,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400)),
                          filled: true,
                          fillColor: AppColors.textfieldcolor,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(
                                SizeConfig.blockSizeHorizontal * 6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(
                                SizeConfig.blockSizeHorizontal * 6)),
                          ),
                          suffixIcon: controller.isEmpty.value.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                          SizeConfig.blockSizeHorizontal * 6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: SizeConfig.blockSizeHorizontal * 4,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.blockSizeHorizontal * 8,
                        top: SizeConfig.blockSizeVertical * 1),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Obx(
                        () => Text(
                            '${controller.isEmpty.value.length} / 50 characters used',
                            style: AppStyle.subHeadingText),
                      ),
                    ),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 5),
                  Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    child: Text(
                      "Number of slides",
                      style: AppStyle.headingText,
                    ),
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 90,
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    child: Text(
                      "The more slides you choose, the more time it will take to generate text and slides",
                      style: AppStyle.subHeadingText,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        selectSlidesNumber();
                        // Get.toNamed(Routes.TESTINGSCREEN);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeVertical * 2),
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2),
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal * 90,
                        decoration: BoxDecoration(
                            color: AppColors.textfieldcolor,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                controller.selectedSlides.value,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: SizeConfig.blockSizeHorizontal * 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 4),
                  Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    child: Text(
                      "Tone of voice",
                      style: AppStyle.headingText,
                    ),
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 90,
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    child: Text(
                      "Choose the style in which the text for the presentation will be generated",
                      style: AppStyle.subHeadingText,
                    ),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      select_method(AppImages.default_image, "Default",
                          controller.selectedTone.value),
                      select_method(AppImages.professional, "Professional",
                          controller.selectedTone.value),
                      select_method(AppImages.academic, "Academic",
                          controller.selectedTone.value),
                    ],
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 5.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        select_method(AppImages.inspirational, "Inspirational",
                            controller.selectedTone.value),
                        horizontalSpace(SizeConfig.blockSizeHorizontal * 4.9),
                        select_method(AppImages.humorous, "humorous",
                            controller.selectedTone.value),
                      ],
                    ),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    child: Text(
                      "Amount of text",
                      style: AppStyle.headingText,
                    ),
                  ),
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 90,
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7),
                    child: Text(
                      "Choose the amount of text that will be generated for each side",
                      style: AppStyle.subHeadingText,
                    ),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      text_amount(AppImages.defaultAmount, "Default"),
                      text_amount(AppImages.medium, "Medium"),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: SizeConfig.blockSizeVertical * 16,
                            width: SizeConfig.blockSizeHorizontal * 27,
                            decoration: BoxDecoration(
                                color: AppColors.textfieldcolor,
                                border: Border.all(
                                    color: AppColors.mainColor, width: 2),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockSizeHorizontal * 5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    height: SizeConfig.blockSizeVertical * 8,
                                    width: SizeConfig.blockSizeHorizontal * 17,
                                    decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.blockSizeHorizontal *
                                                4)),
                                    child: SvgPicture.asset(AppImages.pro)),
                                Text(
                                  "Detailed",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: SizeConfig.blockSizeVertical * 14.4,
                            left: SizeConfig.blockSizeHorizontal * 6,
                            child: Container(
                                height: SizeConfig.blockSizeVertical * 3,
                                width: SizeConfig.blockSizeHorizontal * 15,
                                decoration: BoxDecoration(
                                    color: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 8)),
                                child: Center(
                                  child: Text(
                                    "Pro",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 4,
                                        color: Colors.white),
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 3)
                ],
              ),
            ),
          ),
          footerWidget()
        ],
      ),
    );
  }

  // Align footerWidget() {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Card(
  //       elevation: 5.0, // Set the elevation to the desired value
  //       margin: EdgeInsets.zero, // Remove default margins if needed
  //       child: Container(
  //         width: SizeConfig.screenWidth,
  //         height: SizeConfig.screenHeight * 0.15,
  //         decoration: BoxDecoration(
  //           color: AppColors.footerContainerColor,
  //           border: Border(
  //             top: BorderSide(
  //               color: const Color.fromARGB(
  //                   255, 207, 207, 207), // Set the color to grey
  //               width: 1.0, // Set the width of the border
  //             ),
  //           ),
  //         ),
  //         child: Column(
  //           children: [
  //             Container(
  //                 margin: EdgeInsets.symmetric(
  //                     horizontal: SizeConfig.blockSizeHorizontal * 6,
  //                     vertical: SizeConfig.blockSizeVertical),
  //                 width: SizeConfig.screenWidth,
  //                 height: SizeConfig.blockSizeVertical * 6.5,
  //                 child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                         backgroundColor: AppColors
  //                             .buttonBGColor, // Button background color
  //                         foregroundColor: Colors.white),
  //                     onPressed: () {
  //                       controller.RequestPresentationPlan();
  //                     },
  //                     child: Text("Generate a plan")))
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Container text_amount(String imageText, String titletext) {
    return Container(
      height: SizeConfig.blockSizeVertical * 16,
      width: SizeConfig.blockSizeHorizontal * 27,
      decoration: BoxDecoration(
          color: AppColors.textfieldcolor,
          border: Border.all(color: AppColors.mainColor, width: 2),
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              height: SizeConfig.blockSizeVertical * 8,
              width: SizeConfig.blockSizeHorizontal * 17,
              decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 4)),
              child: SvgPicture.asset(
                imageText,
              )),
          Text(
            titletext,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
                color: AppColors.titles),
          )
        ],
      ),
    );
  }

  Widget select_method(String image, String text, String selectedTone) {
    bool isSelected = text == selectedTone;
    return GestureDetector(
      onTap: () {
        controller.selectTone(text);
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 16,
        width: SizeConfig.blockSizeHorizontal * 27,
        decoration: BoxDecoration(
            color: AppColors.textfieldcolor,
            border: Border.all(
                color:
                    isSelected ? AppColors.mainColor : AppColors.textfieldcolor,
                width: 2),
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              image,
              scale: 17,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: AppColors.titles),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> selectSlidesNumber() {
    return Get.dialog(Dialog(
      child: FractionallySizedBox(
        widthFactor: 1.1,
        child: Container(
            height: SizeConfig.blockSizeVertical * 85,
            decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 6,
                        top: SizeConfig.blockSizeVertical * 2),
                    height: SizeConfig.blockSizeVertical * 6,
                    width: SizeConfig.blockSizeHorizontal * 10,
                    decoration: BoxDecoration(
                      color: AppColors.textfieldcolor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: SizeConfig.blockSizeHorizontal * 5,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        selectedSlidesnumber("1"),
                        selectedSlidesnumber("2"),
                        selectedSlidesnumber("3"),
                        selectedSlidesnumber("4"),
                        selectedSlidesnumber("5"),
                        selectedSlidesnumber("6"),
                        selectedSlidesnumber("7"),
                        selectedSlidesnumber("8"),
                        selectedSlidesPro("9"),
                        selectedSlidesPro("10"),
                        selectedSlidesPro("11"),
                        selectedSlidesPro("12"),
                        verticalSpace(SizeConfig.blockSizeVertical * 2)
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    ));
  }

  Center selectedSlidesnumber(String slidesNumber) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 1.5,
        ),
        height: SizeConfig.blockSizeVertical * 5.5,
        width: SizeConfig.blockSizeHorizontal * 70,
        decoration: BoxDecoration(
            color: AppColors.textfieldcolor,
            border: Border.all(color: AppColors.mainColor, width: 2.5),
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 29),
                child: Text(
                  slidesNumber,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: SizeConfig.blockSizeHorizontal * 2,
                  left: SizeConfig.blockSizeHorizontal * 22),
              child: Container(
                height: SizeConfig.blockSizeVertical * 4,
                width: SizeConfig.blockSizeHorizontal * 6,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: SizeConfig.blockSizeHorizontal * 4,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Center selectedSlidesPro(String slidesNumber) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1.5),
        height: SizeConfig.blockSizeVertical * 5.5,
        width: SizeConfig.blockSizeHorizontal * 70,
        decoration: BoxDecoration(
            color: AppColors.textfieldcolor,
            border: Border.all(color: AppColors.mainColor, width: 2.5),
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 29),
                child: Text(
                  slidesNumber,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: SizeConfig.blockSizeHorizontal * 2,
                  left: SizeConfig.blockSizeHorizontal * 12.5),
              child: Container(
                  height: SizeConfig.blockSizeVertical * 3.5,
                  width: SizeConfig.blockSizeHorizontal * 15,
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 8)),
                  child: Center(
                    child: Text(
                      "Pro",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
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
}
