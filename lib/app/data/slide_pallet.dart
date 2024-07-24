import 'package:flutter/material.dart';

class SlidePallet {
  int id;
  String name;
  String slideCategory;
  TextStyle bigTitleTStyle,
      normalTitleTStyle,
      sectionHeaderTStyle,
      normalDescTStyle,
      sectionDescTextStyle;
  List<String> imageList;
  Color fadeColor;

  SlidePallet({
    required this.id,
    required this.name,
    required this.slideCategory,
    required this.bigTitleTStyle,
    required this.normalTitleTStyle,
    required this.sectionHeaderTStyle,
    required this.normalDescTStyle,
    required this.sectionDescTextStyle,
    required this.imageList,
    required this.fadeColor,
  });
}
