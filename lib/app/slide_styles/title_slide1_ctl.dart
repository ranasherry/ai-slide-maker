// import 'package:get/get.dart';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:slide_maker/app/data/slide.dart';
// import 'package:slide_maker/app/data/slide_pallet.dart';


// class TitleSlideController extends GetxController {
//   final MySlide mySlide;
//   final SlidePallet slidePallet;
//   final Size size;

//   TitleSlideController({
//     required this.mySlide,
//     required this.slidePallet,
//     required this.size,
//   });

//   var bgIndex = 0.obs;
//   var titleFontSize = 34.0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final random = Random();
//     bgIndex.value = random.nextInt(slidePallet.imageList.length);
//     titleFontSize.value = mySlide.slideSections[0].memoryImage != null ||
//             mySlide.slideSections[0].imageReference != null
//         ? size.width * 0.05
//         : size.width * 0.06;

//     print("Title Font Size: ${titleFontSize.value}");
//     print("BG Index: ${bgIndex.value}");
//     print("BG Image: ${slidePallet.imageList[bgIndex.value]}");
//     print(
//         "initState Called: Image reference: ${mySlide.slideSections[0].imageReference}");
//   }
// }