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

class NewIntroScreensView extends GetView<newInroScreenCTL> {
  const NewIntroScreensView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                            controller.goToHomePage();
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
                    child: Text("Please choose your profession",
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
                                  return Wrap(
                                    spacing: 8.0,
                                    children:
                                        controller.chipOptions.map((option) {
                                      return ChoiceChip(
                                        elevation: 2,
                                        label: Text(option,
                                            style: GoogleFonts.aBeeZee(
                                              textStyle: TextStyle(
                                                color: controller.selectedChoice
                                                            .value ==
                                                        option
                                                    ? AppColors.mainColor
                                                    : Colors.black,
                                              ),
                                            )),
                                        selected:
                                            controller.selectedChoice.value ==
                                                option,
                                        onSelected: (selected) {
                                          if (selected) {
                                            controller.selectChoice(option);
                                          }
                                        },
                                        backgroundColor:
                                            AppColors.textfieldcolor,
                                        selectedColor: AppColors.textfieldcolor,
                                        side: BorderSide(
                                          color:
                                              controller.selectedChoice.value ==
                                                      option
                                                  ? AppColors.mainColor
                                                  : Colors.transparent,
                                        ),
                                        showCheckmark: false,
                                        shadowColor: Colors.grey.shade300,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.blockSizeHorizontal *
                                                    8)),
                                      );
                                    }).toList(),
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
                            if (controller.selectedChoice.value != "") {
                              controller.setUserProfession(
                                  controller.selectedChoice.value);
                            } else {
                              EasyLoading.showError(
                                  "Please select a Profession or Skip");
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

          // Container(
          //     height: SizeConfig.blockSizeVertical * 40.3,
          //     width: SizeConfig.screenWidth,
          //     decoration: BoxDecoration(
          //         image: DecorationImage(
          //             image: AssetImage(AppImages.slide_background))),
          //     child: Center(
          //       child: Text("Please choose your profession",
          //           style: GoogleFonts.aBeeZee(
          //             textStyle: TextStyle(
          //                 fontSize: SizeConfig.blockSizeHorizontal * 6,
          //                 fontWeight: FontWeight.bold,
          //                 color: AppColors.textfieldcolor),
          //           )),
          //     )),
        ],
      ),
      //  Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     verticalSpace(SizeConfig.blockSizeVertical * 5),
      //     Padding(
      //       padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
      //       child: Text("Select User Type", style: AppStyle.headingText),
      //     ),
      //     Padding(
      //       padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
      //       child: Text("Please choose your profession",
      //           style: AppStyle.subHeadingText),
      //     ),
      //     verticalSpace(SizeConfig.blockSizeVertical * 2),
      //     Expanded(
      //       child: Obx(
      //         () => GridView(
      //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 2,
      //               mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
      //               crossAxisSpacing: SizeConfig.blockSizeVertical * 1.5),
      //           padding: EdgeInsets.symmetric(
      //             horizontal: SizeConfig.blockSizeHorizontal * 3,
      //           ),
      //           children: [
      //             user_profession(AppImages.information_technoloogy,
      //                 "Infomation Technology"),
      //             user_profession(
      //                 AppImages.business_management, "Buisness Management"),
      //             user_profession(AppImages.healthcare, "Healthcare"),
      //             user_profession(AppImages.education, "Education"),
      //             user_profession(AppImages.engineering, "Engineering"),
      //             user_profession(AppImages.creativity, "Other"),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Container(
      //       height: SizeConfig.blockSizeVertical * 7,
      //       width: SizeConfig.blockSizeHorizontal * 50,
      //       decoration: BoxDecoration(
      //         color: AppColors.mainColor,
      //       ),
      //       child: Icon(
      //         Icons.arrow_forward_ios_rounded,
      //         color: AppColors.textfieldcolor,
      //       ),
      //     )
      //     // Row(
      //     //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     //   children: [
      //     //     Container(
      //     //       height: SizeConfig.blockSizeVertical * 7,
      //     //       width: SizeConfig.blockSizeHorizontal * 60,
      //     //       decoration: BoxDecoration(
      //     //           color: AppColors.textfieldcolor,
      //     //           boxShadow: [
      //     //             BoxShadow(
      //     //               color: Colors.grey.withOpacity(0.2), // Shadow color
      //     //               spreadRadius: 2, // How much the shadow spreads
      //     //               blurRadius: 10, // How soft the shadow is
      //     //               offset: Offset(4, 4), // Position of the shadow (x, y)
      //     //             ),
      //     //           ],
      //     //           borderRadius: BorderRadius.circular(
      //     //               SizeConfig.blockSizeHorizontal * 8)),
      //     //       child: Center(
      //     //         child: Text(
      //     //           "Other",
      //     //           style: GoogleFonts.aBeeZee(
      //     //               textStyle: TextStyle(
      //     //                   fontSize: SizeConfig.blockSizeHorizontal * 3,
      //     //                   fontWeight: FontWeight.bold,
      //     //                   color: AppColors.black_color)),
      //     //         ),
      //     //       ),
      //     //     ),

      //     //   ],
      //     // )
      //   ],
      // ),
    );
  }

  // Widget user_profession(String image, String text) {
  //   final isSelected = controller.selectedProfession.value == text;
  //   return GestureDetector(
  //     onTap: () {
  //       controller.selectedProfession(text);
  //     },
  //     child: Container(
  //       height: SizeConfig.blockSizeVertical * 20,
  //       width: SizeConfig.blockSizeHorizontal * 42,
  //       decoration: BoxDecoration(
  //           color: AppColors.textfieldcolor,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.2), // Shadow color
  //               spreadRadius: 2, // How much the shadow spreads
  //               blurRadius: 10, // How soft the shadow is
  //               offset: Offset(4, 4), // Position of the shadow (x, y)
  //             ),
  //           ],
  //           border: isSelected ? Border.all(color: AppColors.mainColor) : null,
  //           borderRadius:
  //               BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3)),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           Image.asset(
  //             image,
  //             scale: 10,
  //           ),
  //           Text(
  //             text,
  //             style: GoogleFonts.aBeeZee(
  //                 textStyle: TextStyle(
  //                     fontSize: SizeConfig.blockSizeHorizontal * 3,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppColors.black_color)),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// Technology and IT

// Software Developer/Engineer
// Data Scientist
// IT Support/Administrator
// Cybersecurity Specialist
// Web Developer
// Creative and Design

// Graphic Designer
// UX/UI Designer
// Video Editor
// Animator
// Content Creator/Writer
// Business and Management

// Project Manager
// Business Analyst
// Marketing Specialist
// Entrepreneur
// Sales Manager
// Healthcare

// Doctor/Nurse
// Pharmacist
// Therapist/Counselor
// Medical Researcher
// Public Health Specialist
// Education

// Teacher/Professor
// Educational Consultant
// Academic Researcher
// Instructional Designer
// Tutor
// Engineering

// Civil Engineer
// Mechanical Engineer
// Electrical Engineer
// Chemical Engineer
// Environmental Engineer
// Law and Public Service

// Lawyer/Attorney
// Paralegal
// Government Official
// Law Enforcement Officer
// Social Worker
// Finance and Accounting

// Accountant
// Financial Analyst
// Investment Banker
// Auditor
// Tax Specialist
// Science and Research

// Research Scientist
// Biologist
// Chemist
// Physicist
// Environmental Scientist
// Hospitality and Tourism

// Hotel Manager
// Travel Agent
// Event Planner
// Chef
// Tour Guide
// Arts and Entertainment

// Actor/Actress
// Musician
// Dancer
// Director/Producer
// Writer/Author
// Skilled Trades

// Electrician
// Plumber
// Carpenter
// Welder
// Mechanic
