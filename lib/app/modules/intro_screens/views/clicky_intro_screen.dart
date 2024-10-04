import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/intro_screens/controllers/new_intro_screen_controller.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class ClickyIntroScreen extends GetView<newInroScreenCTL> {
  const ClickyIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 42,
            width: SizeConfig.screenWidth,
            child: Image.asset(
              AppImages.clicky_community,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            "Create Your",
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 8,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainColor)),
          ),
          Text("Community",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainColor))),
          Text("with",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainColor))),
          Text("Clicky",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.mainColor))),
          verticalSpace(SizeConfig.blockSizeVertical * 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 2),
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 14,
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 2)),
                child: Center(
                  child: Text(
                    "AI",
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 7,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textfieldcolor)),
                  ),
                ),
              ),
              Text(
                "Slide Maker",
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 7,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              RevenueCatService().GoToPurchaseScreen();
              // FirebaseAnalytics.instance.logSelectItem(
              //     itemListId: "Interested Yes", itemListName: "Interested Yes");
              FirebaseAnalytics.instance.logSelectContent(
                  contentType: "Interesdted?", itemId: "Interested Yes");
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 4,
                  bottom: SizeConfig.blockSizeVertical * 1),
              height: SizeConfig.blockSizeVertical * 6.5,
              width: SizeConfig.blockSizeHorizontal * 55,
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 8)),
              child: Center(
                child: Text(
                  "Interested",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          // fontWeight: FontWeight.bold,
                          color: AppColors.textfieldcolor)),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.toNamed(Routes.HOMEVIEW1);
              // FirebaseAnalytics.instance.logSelectItem(
              //     itemListId: "Interested Skip",
              //     itemListName: "Interested Skip");
              FirebaseAnalytics.instance.logSelectContent(
                  contentType: "Interesdted?", itemId: "Interested Skip");

              ComFunction.GotoHomeScreen();
            },
            child: Text(
              "Skip",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      color: AppColors.greybox,
                      decoration: TextDecoration.underline)),
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 3),
          Text(
              'Share and chat with millions,\n connecting and inspiring globally',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
              )))
        ],
      ),
    );
  }
}
