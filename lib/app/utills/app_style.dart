import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class AppStyle {
  static final headingText = GoogleFonts.roboto(
      textStyle: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 6,
          fontWeight: FontWeight.bold,
          color: Color(0xFF262729)));

  static final subHeadingText = GoogleFonts.robotoFlex(
      textStyle: TextStyle(
          height: 1.2,
          fontSize: SizeConfig.blockSizeHorizontal * 3.5,
          color: Colors.grey.shade500));

  static final button = GoogleFonts.roboto(
      textStyle: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 4.2,
          fontWeight: FontWeight.bold,
          color: Colors.white));
}
