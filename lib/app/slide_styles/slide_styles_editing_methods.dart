import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';

import 'package:slide_maker/app/slide_styles/sectioned_slide1_editor.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide2_editor.dart';
import 'package:slide_maker/app/slide_styles/sectioned_slide7.dart';

import 'package:slide_maker/app/slide_styles/title_slide1_editor.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

Widget individualSlideEditorMethod(
    int index, Rx<MyPresentation> myPresentation, Size size, bool isReadOnly) {
  // Size size = Size(
  //     SizeConfig.blockSizeHorizontal * 90, SizeConfig.blockSizeHorizontal * 45);

  // SlidePallet selectedPallet = palletList[palletList.indexWhere((element) =>
  //             int.parse(myPresentation.value.styleId) == element.id) !=
  //         -1
  //     ? palletList.indexWhere(
  //         (element) => int.parse(myPresentation.value.styleId) == element.id)
  //     : 0];
  return Container(
    // margin: EdgeInsets.symmetric(
    //     horizontal: SizeConfig.blockSizeHorizontal * 2,
    //     vertical: SizeConfig.blockSizeVertical),
    child: Obx(() {
      SlidePallet selectedPallet = palletList[palletList.indexWhere((element) =>
                  int.parse(myPresentation.value.styleId.value) ==
                  element.id) !=
              -1
          ? palletList.indexWhere((element) =>
              int.parse(myPresentation.value.styleId.value) == element.id)
          : 0];

      if (index == 0) {
        return Obx(() => TitleSlide1Editor(
              mySlide: myPresentation.value.slides[index],
              slidePallet: selectedPallet,
              size: size,
              index: index,
              isReadOnly: isReadOnly,
            ));
      } else {
        //? Sections
        if (index == 1) {
          return Obx(() =>
              // ? uncomment before release [jamal]
              // SectionedSlide2Editor(
              SectionedSlide7(
                mySlide: myPresentation.value.slides[index],
                slidePallet: selectedPallet,
                size: size,
                // index: index,
                // isReadOnly: isReadOnly,
              ));
        } else {
          return Obx(() => SectionedSlide1Editor(
                mySlide: myPresentation.value.slides[index],
                slidePallet: selectedPallet,
                size: size,
                index: index,
                isReadOnly: isReadOnly,
              ));
        }
      }
    }),
  );
}
