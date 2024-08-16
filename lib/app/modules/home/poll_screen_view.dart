import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helprer_widgets/main_header_bg.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class PollScreenView extends StatelessWidget {
  const PollScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Stack(
        children: [
          MainHeaderBG(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 40),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 16),
            child: Text(
              "Shape the Future of Our App",
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textfieldcolor)),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 22),
            child: Text(
              "Your feedback will help us enhance the app. Please take a moment to fill out this form.",
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      // fontWeight: FontWeight.bold,
                      color: AppColors.textfieldcolor)),
            ),
          ),
          Column(
            children: [],
          )
        ],
      ),
    ));
  }
}
