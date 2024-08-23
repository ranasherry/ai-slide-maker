import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide1.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

Widget individualSlideMethod(
    int index, Rx<MyPresentation> myPresentation, Size size) {
  // Size size = Size(
  //     SizeConfig.blockSizeHorizontal * 90, SizeConfig.blockSizeHorizontal * 45);

  SlidePallet selectedPallet = palletList[palletList.indexWhere((element) =>
              int.parse(myPresentation.value.styleId) == element.id) !=
          -1
      ? palletList.indexWhere(
          (element) => int.parse(myPresentation.value.styleId) == element.id)
      : 0];
  return Container(
    // margin: EdgeInsets.symmetric(
    //     horizontal: SizeConfig.blockSizeHorizontal * 2,
    //     vertical: SizeConfig.blockSizeVertical),
    child: Builder(builder: (context) {
      if (index == 0) {
        return Obx(() => TitleSlide1(
              mySlide: myPresentation.value.slides[index],
              slidePallet: selectedPallet,
              size: size,
            ));
      } else {
        //? Sections
        if (index == 1) {
          return Obx(() => SectionedSlide2(
                mySlide: myPresentation.value.slides[index],
                slidePallet: selectedPallet,
                size: size,
              ));
        } else {
          return Obx(() => SectionedSlide1(
                mySlide: myPresentation.value.slides[index],
                slidePallet: selectedPallet,
                size: size,
              ));
        }
      }
    }),
  );
}
