import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  double titleFontSize;

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
    double? titleFontSize, // Optional field with null check
  }) : titleFontSize = titleFontSize ?? 0.05; // Assign default value if not provided
}