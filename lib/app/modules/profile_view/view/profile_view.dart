import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class ProfileView extends StatelessWidget {
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
                color: AppColors.Bright_Pink_color,
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
                top: SizeConfig.blockSizeVertical * 8,
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
              )
            ],
          )
        ],
      ),
    );
  }
}
