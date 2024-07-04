import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/helping_enums.dart';
import 'package:slide_maker/app/utills/size_config.dart';

Widget NextPageLoadingWidget() {
  return Container(
    height: SizeConfig.blockSizeVertical * 80,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: SizeConfig.blockSizeHorizontal * 20,
              height: SizeConfig.blockSizeHorizontal * 20,
              child: CircularProgressIndicator()),
          verticalSpace(SizeConfig.blockSizeVertical * 3),
          Text("Please Wait loading This Slide"),
          verticalSpace(SizeConfig.blockSizeVertical * 3),
        ],
      ),
    ),
  );
}

Widget myAllImageProvider(
    {required BookPageModel page,
    required double width,
    required double height}) {
  log("Pagetitle: ${page.ChapName} ImageType: ${page.imageType} ");
  switch (page.imageType) {
    case SlideImageType.svg:
      return Container(
          width: width,
          height: height,
          child: SvgPicture.asset(
            page.ImagePath ?? "",
            height: height,
            width: width,
            fit: BoxFit.cover,
            // colorFilter:
            // ColorFilter.mode(Colors.green, BlendMode.softLight),
            semanticsLabel: page.ChapName,
            placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator()),
          ));
      break;
    default:
      return Container(
          width: width,
          height: height,
          child: SvgPicture.asset(
            page.ImagePath ?? "",
            height: height,
            width: width,
            fit: BoxFit.cover,
            // colorFilter:
            // ColorFilter.mode(Colors.green, BlendMode.softLight),
            semanticsLabel: page.ChapName,
            placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator()),
          ));
    // return Container();
  }
}
