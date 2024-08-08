import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/intro_screens/controllers/new_intro_screen_controller.dart';
import 'package:slide_maker/app/utills/app_style.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helprer_widgets/main_header_bg.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class GenderAskingView extends GetView<newInroScreenCTL> {
  const GenderAskingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Stack(
              children: [
                MainHeaderBG(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.blockSizeVertical * 35),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 6,
                          right: SizeConfig.blockSizeHorizontal * 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(
                              8.0), // Ripple effect border radius
                          onTap: () {
                            // Add your onPressed code here!
                            print("Button Pressed");
                            controller.goToProfessionPage();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 5,
                                vertical: 5),
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: Colors.white, // Text color
                              ),
                            ),
                          ))),
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockSizeVertical * 35,
                  child: Center(
                    child: Text("Please choose your Gender",
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 6,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textfieldcolor),
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 70,
                    child: Column(
                      children: [
                        Container(
                          // height: SizeConfig.blockSizeVertical * 35,

                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),

                          child: Column(
                            children: [
                              verticalSpace(SizeConfig.blockSizeVertical * 3),
                              Center(
                                child: Obx(() {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.genderOptions.length,
                                    itemBuilder: (context, index) {
                                      final option =
                                          controller.genderOptions[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.blockSizeHorizontal *
                                                    5,
                                            vertical:
                                                SizeConfig.blockSizeVertical),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color.fromARGB(
                                                    255, 255, 255, 255)
                                                .withOpacity(0.2)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Obx(() => CustomRadioTile(
                                                option: option,
                                                groupValue: controller
                                                    .SelectedGender.value,
                                                onChanged: (value) {
                                                  controller.SelectedGender
                                                      .value = value ?? "";
                                                  print(
                                                      "Selected Gender: ${controller.SelectedGender.value}");
                                                },
                                              )),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                              // Spacer(),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (controller.SelectedGender.value != "") {
                              controller.selectGender(
                                  controller.SelectedGender.value);
                            } else {
                              EasyLoading.showError(
                                  "Please select your Gender or Skip");
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.blockSizeVertical * 2),
                              height: SizeConfig.blockSizeVertical * 7,
                              width: SizeConfig.blockSizeHorizontal * 85,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                // border: Border.all(color: Color(0xFFDD3B00))
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockSizeHorizontal * 8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.2), // Shadow color
                                    spreadRadius:
                                        2, // How much the shadow spreads
                                    blurRadius: 10, // How soft the shadow is
                                    offset: Offset(
                                        4, 4), // Position of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text("Next", style: AppStyle.button),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomChoiceTile extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onSelect;

  CustomChoiceTile({
    required this.option,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        option,
        style: GoogleFonts.aBeeZee(
          textStyle: TextStyle(
            fontSize: 18,
            color: isSelected ? AppColors.mainColor : Colors.black,
          ),
        ),
      ),
      leading: Icon(Icons.select_all),
      // tileColor: AppColors.textfieldcolor,
      selectedTileColor: AppColors.textfieldcolor.withOpacity(0.5),
      selected: isSelected,
      onTap: onSelect,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: isSelected ? AppColors.mainColor : Colors.transparent,
        ),
      ),
    );
  }
}

class CustomRadioTile extends StatelessWidget {
  final String option;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  CustomRadioTile({
    required this.option,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        option,
        style: GoogleFonts.aBeeZee(
          textStyle: TextStyle(
            fontSize: 18,
            color: groupValue == option ? AppColors.mainColor : Colors.black,
          ),
        ),
      ),
      leading: Radio<String>(
        value: option,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppColors.mainColor,
      ),
      selectedTileColor: AppColors.textfieldcolor.withOpacity(0.5),
      selected: groupValue == option,
      onTap: () => onChanged(option),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color:
              groupValue == option ? AppColors.mainColor : Colors.transparent,
        ),
      ),
    );
  }
}
