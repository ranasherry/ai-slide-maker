import 'package:flutter/material.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'dart:math' as math;

import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';

Align WaterMark(
    {required double fontSize, required Size size, required Color color}) {
  return Align(
    alignment: Alignment.bottomRight,
    child: Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.01, vertical: size.width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Opacity(
            opacity: 0.8,
            child: Text(
              "Made with ${RCVariables.AppName}",
              style: TextStyle(fontSize: fontSize, color: color),
            ),
          ),
          horizontalSpace(size.width * 0.02),
          Container(
            width: size.width * 0.1,
            height: size.width * 0.1,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                AppImages.mainIcon,
              ),
            ),
          ),
          horizontalSpace(size.width * 0.02)
        ],
      ),
    ),
  );
}
