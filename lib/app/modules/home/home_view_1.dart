import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helprer_widgets/main_header_bg.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class HomeView1 extends StatelessWidget {
  const HomeView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              MainHeaderBG(
                height: SizeConfig.blockSizeVertical * 35,
                width: SizeConfig.screenWidth,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeVertical * 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 4.5,
                      width: SizeConfig.blockSizeHorizontal * 15,
                      decoration: BoxDecoration(
                          color: AppColors.textfieldcolor,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 2)),
                      child: Text(
                        "AI",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor)),
                      ),
                    ),
                    horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                    Container(
                      child: Text(
                        "Slide Maker",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textfieldcolor)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
