import 'package:flutter/material.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/utills/images.dart';

SlidePallet pallet1 = SlidePallet(
  id: 1,
  name: "purple",
  slideCategory: "Light",
  bigTitleTStyle: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade900,
  ),
  normalTitleTStyle: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
  ),
  sectionHeaderTStyle: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.blue.shade700,
  ),
  normalDescTStyle: TextStyle(
    fontSize: 16.0,
    color: Colors.blue.shade600,
  ),
  sectionDescTextStyle: TextStyle(
    fontSize: 14.0,
    color: Colors.blue.shade500,
  ),
  imageList: AppImages.slidy_style1,
  fadeColor: const Color.fromARGB(64, 187, 222, 251),
);

SlidePallet pallet2 = SlidePallet(
  id: 2,
  name: "Cyan",
  slideCategory: "Dark",
  bigTitleTStyle: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  normalTitleTStyle: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  sectionHeaderTStyle: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  normalDescTStyle: TextStyle(
    fontSize: 16.0,
    color: Colors.white,
  ),
  sectionDescTextStyle: TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  ),
  imageList: AppImages.slidy_style2,
  fadeColor: const Color.fromARGB(64, 187, 222, 251),
);

SlidePallet pallet3 = SlidePallet(
  id: 3,
  name: "Orange",
  slideCategory: "Light",
  bigTitleTStyle: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
  ),
  normalTitleTStyle: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
  ),
  sectionHeaderTStyle: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.blue.shade700,
  ),
  normalDescTStyle: TextStyle(
    fontSize: 16.0,
    color: Colors.blue.shade600,
  ),
  sectionDescTextStyle: TextStyle(
    fontSize: 14.0,
    color: Colors.blue.shade500,
  ),
  imageList: AppImages.slidy_style3,
  fadeColor: Color.fromARGB(0, 187, 222, 251),
);

SlidePallet pallet4 = SlidePallet(
  id: 3,
  name: "Green",
  slideCategory: "Light",
  bigTitleTStyle: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade900,
  ),
  normalTitleTStyle: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
  ),
  sectionHeaderTStyle: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.blue.shade700,
  ),
  normalDescTStyle: TextStyle(
    fontSize: 16.0,
    color: Colors.blue.shade600,
  ),
  sectionDescTextStyle: TextStyle(
    fontSize: 14.0,
    color: Colors.blue.shade500,
  ),
  imageList: AppImages.slidy_style4,
  fadeColor: const Color.fromARGB(64, 187, 222, 251),
);

List<SlidePallet> palletList = [pallet1, pallet2, pallet3, pallet4];
