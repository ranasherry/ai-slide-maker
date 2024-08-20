import 'package:flutter/material.dart';

class SlidePallet {
  int id;
  String name;
  String slideCategory;
  int bigTitleTColor;
  int normalTitleTColor;
  int sectionHeaderTColor;
  int normalDescTColor;
  int sectionDescTextColor;
  List<String> imageList;
  Color fadeColor;
  bool isPaid;

  SlidePallet({
    required this.id,
    required this.name,
    required this.slideCategory,
    required this.bigTitleTColor,
    required this.normalTitleTColor,
    required this.sectionHeaderTColor,
    required this.normalDescTColor,
    required this.sectionDescTextColor,
    required this.imageList,
    required this.fadeColor,
    required this.isPaid,
  });
}
