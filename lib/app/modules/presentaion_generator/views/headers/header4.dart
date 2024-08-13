import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class Header4 extends StatelessWidget {
  const Header4({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Check the generated \nSlides",
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoFlex(
              textStyle: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal * 7.5,
            fontWeight: FontWeight.bold,
            color: AppColors.textfieldcolor,
          )),
        ),
        // Text(
        //   "slides",
        //   textAlign: TextAlign.center,
        //   style: GoogleFonts.robotoFlex(
        //       textStyle: TextStyle(
        //     height: 1.1,
        //     fontSize: SizeConfig.blockSizeHorizontal * 8,
        //     fontWeight: FontWeight.bold,
        //     color: AppColors.textfieldcolor,
        //   )),
        // ),
        verticalSpace(SizeConfig.blockSizeVertical * 2),
        Container(
          width: SizeConfig.blockSizeHorizontal * 65,
          child: Text(
            "A couple of minutes will save your hours",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 3,
                    color: AppColors.textfieldcolor)),
          ),
        ),
      ],
    );
  }
}
