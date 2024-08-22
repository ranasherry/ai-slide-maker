import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/profile_view/controller/profile_view_controller.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class ProfileView extends GetView<ProfileViewCTL> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 30,
                width: SizeConfig.screenWidth,
                // color: AppColors.Bright_Pink_color,
                child: SvgPicture.asset(
                  AppImages.profile_background,
                  alignment: Alignment.centerLeft,
                ),
              ),
              Positioned(
                top: SizeConfig.blockSizeVertical * 8,
                left: SizeConfig.blockSizeHorizontal * 10,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 10,
                  width: SizeConfig.blockSizeHorizontal * 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.textfieldcolor),
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: SizeConfig.blockSizeHorizontal * 10,
                  ),
                ),
              ),
              Positioned(
                top: SizeConfig.blockSizeVertical * 7,
                left: SizeConfig.blockSizeHorizontal * 36,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rana mehar Gujjar",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    verticalSpace(SizeConfig.blockSizeVertical * 0.7),
                    Text("UID:183209897091"),
                    verticalSpace(SizeConfig.blockSizeVertical * 0.7),
                    Text("rana_Mehar_Gujjar@megail.com"),
                    verticalSpace(SizeConfig.blockSizeVertical * 0.7),
                    Row(
                      children: [
                        Text("Male"),
                        horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                        Text("🎂 Feb 29, 2025"),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: SizeConfig.blockSizeVertical * 22,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        followers_method("Followers : 0"),
                        horizontalSpace(SizeConfig.blockSizeHorizontal * 10),
                        followers_method("Following : 100")
                      ]),
                ),
              )
            ],
          ),
          Container(
            height: SizeConfig.blockSizeVertical * 7,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(color: AppColors.mainColor),
            child: Center(
              child: Text(
                "Your Creations",
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 6,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textfieldcolor)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4,
                  vertical: SizeConfig.blockSizeVertical * 1),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 4),
                  height: SizeConfig.blockSizeVertical * 10,
                  width: SizeConfig.blockSizeHorizontal * 60,
                  decoration: BoxDecoration(
                      color: AppColors.textfieldcolor,
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 7)),
                  child: Row(
                    children: [
                      Container(
                          height: SizeConfig.blockSizeVertical * 7,
                          width: SizeConfig.blockSizeHorizontal * 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.blockSizeHorizontal * 3)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 3),
                            child: Image.asset(
                              AppImages.slidy_style8[0],
                              fit: BoxFit.cover,
                            ),
                          )),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Solar Flair",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.titles)),
                          ),
                          Text(
                            "Date/Time",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3,
                                    color: AppColors.titles)),
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {}, child: Icon(Icons.more_vert))
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container followers_method(String text) {
    return Container(
      height: SizeConfig.blockSizeVertical * 5,
      width: SizeConfig.blockSizeHorizontal * 37,
      decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4)),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: AppColors.textfieldcolor)),
        ),
      ),
    );
  }
}
