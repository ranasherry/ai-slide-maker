import 'package:flutter/material.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/utills/images.dart';

SlidePallet pallet1 = SlidePallet(
    id: 1,
    name: "purple",
    slideCategory: "Light",
    bigTitleTColor: Colors.blue.shade900.value,
    normalTitleTColor: Colors.blue.shade800.value,
    sectionHeaderTColor: Colors.blue.shade700.value,
    normalDescTColor: Colors.blue.shade600.value,
    sectionDescTextColor: Colors.blue.shade500.value,
    imageList: AppImages.slidy_style1,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: false);

SlidePallet pallet2 = SlidePallet(
    id: 2,
    name: "Cyan",
    slideCategory: "Dark",
    bigTitleTColor: Colors.white.value,
    normalTitleTColor: Colors.white.value,
    sectionHeaderTColor: Colors.white.value,
    normalDescTColor: Colors.white.value,
    sectionDescTextColor: Colors.white.value,
    imageList: AppImages.slidy_style2,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: true);

SlidePallet pallet3 = SlidePallet(
    id: 3,
    name: "Orange",
    slideCategory: "Light",
    bigTitleTColor: Colors.blue.shade800.value,
    normalTitleTColor: Colors.blue.shade800.value,
    sectionHeaderTColor: Colors.blue.shade700.value,
    normalDescTColor: Colors.blue.shade600.value,
    sectionDescTextColor: Colors.blue.shade500.value,
    imageList: AppImages.slidy_style3,
    fadeColor: const Color.fromARGB(0, 187, 222, 251),
    isPaid: false);

SlidePallet pallet4 = SlidePallet(
    id: 4, // Corrected ID to be unique
    name: "Green",
    slideCategory: "Light",
    bigTitleTColor: Colors.blue.shade900.value,
    normalTitleTColor: Colors.blue.shade800.value,
    sectionHeaderTColor: Colors.blue.shade700.value,
    normalDescTColor: Colors.blue.shade600.value,
    sectionDescTextColor: Colors.blue.shade500.value,
    imageList: AppImages.slidy_style4,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: false);

SlidePallet pallet5 = SlidePallet(
    id: 5,
    name: "brown",
    slideCategory: "Light",
    bigTitleTColor: Colors.grey.shade900.value,
    normalTitleTColor: Colors.grey.shade800.value,
    sectionHeaderTColor: Colors.grey.shade700.value,
    normalDescTColor: Colors.grey.shade600.value,
    sectionDescTextColor: Colors.grey.shade500.value,
    imageList: AppImages.slidy_style5,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: false);

SlidePallet pallet6 = SlidePallet(
    id: 6,
    name: "milky",
    slideCategory: "Light",
    bigTitleTColor: Colors.black.value,
    normalTitleTColor: Colors.black.value,
    sectionHeaderTColor: Colors.black.value,
    normalDescTColor: Colors.black.value,
    sectionDescTextColor: Colors.black.value,
    imageList: AppImages.slidy_style6,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: true);

SlidePallet pallet7 = SlidePallet(
    id: 7,
    name: "chocolate",
    slideCategory: "Light",
    bigTitleTColor: Color(0xFFFBDA7C).value,
    normalTitleTColor: Colors.white.value,
    sectionHeaderTColor: Color(0xFFFBDA7C).value,
    normalDescTColor: Colors.white.value,
    sectionDescTextColor: Colors.white.value,
    imageList: AppImages.slidy_style7,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: true);

SlidePallet pallet8 = SlidePallet(
    id: 8,
    name: "Dark chocolate",
    slideCategory: "Light",
    bigTitleTColor: Color(0xFFFFBA63).value,
    normalTitleTColor: Color(0xFFFFBA63).value,
    sectionHeaderTColor: Color(0xFFFFA93C).value,
    normalDescTColor: Color(0xFFFFBA63).value,
    sectionDescTextColor: Color(0xFFFFBA63).value,
    imageList: AppImages.slidy_style8,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: true);

SlidePallet pallet9 = SlidePallet(
    id: 9, // Updated to ensure uniqueness
    name: "marshmallow",
    slideCategory: "Light",
    bigTitleTColor: Colors.black.value,
    normalTitleTColor: Colors.black.value,
    sectionHeaderTColor: Colors.black.value,
    normalDescTColor: Colors.black.value,
    sectionDescTextColor: Colors.black.value,
    imageList: AppImages.slidy_style9,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: true);

List<SlidePallet> palletList = [
  pallet1,
  pallet2,
  pallet3,
  pallet4,
  pallet5,
  pallet6,
  pallet7,
  pallet8,
  pallet9,
];
