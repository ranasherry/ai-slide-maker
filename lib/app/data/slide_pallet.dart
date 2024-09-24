import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/text_properties.dart';

class SlidePallet {
  int palletId;
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
  List<TextProperties>? slideTitlesFontValue;
  List<List<TextProperties>>? slideSectionHeadersFontValue;
  List<List<TextProperties>>? slideSectionContentsFontValue;

  SlidePallet({
    required this.palletId,
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
    this.slideTitlesFontValue,
    this.slideSectionHeadersFontValue,
    this.slideSectionContentsFontValue,
  });
 
 Map<String,dynamic> toMap(){
  return {
    "palletId": palletId,
    "name": name,
    "slideCategory": slideCategory,
    "bigTitleTColor" : bigTitleTColor,
    "normalTitleTColor" : normalTitleTColor,
    "sectionHeaderTColor" : sectionHeaderTColor,
    "normalDescTColor" : normalDescTColor,
    "sectionDescTextColor" : sectionDescTextColor,
    "imageList" : json.encode(imageList),
    "fadeColor" : fadeColor.value,
    "isPaid" : isPaid == true ? 1 : 0,
   'slideTitlesFontValue': jsonEncode(slideTitlesFontValue?.map((e)=>e.toMap()).toList() ?? []),
    'slideSectionHeadersFontValue': jsonEncode(slideSectionHeadersFontValue?.map((e)=>e.map((element)=>element.toMap()).toList()).toList() ?? []),
    'slideSectionContentsFontValue': jsonEncode(slideSectionContentsFontValue?.map((e)=>e.map((element)=>element.toMap()).toList()).toList() ?? []),
  };
 }

 static SlidePallet fromMap(Map<String,dynamic> map){
   print("slideTitlesFontValue (raw from DB): ${map['slideTitlesFontValue']}");
  print("slideSectionHeadersFontValue (raw from DB): ${map['slideSectionHeadersFontValue']}");
  print("slideSectionContentsFontValue (raw from DB): ${map['slideSectionContentsFontValue']}");
  return SlidePallet(
    palletId : map["palletId"],
    name : map["name"],
    slideCategory: map["slideCategory"],
    bigTitleTColor : map["bigTitleTColor"],
    normalTitleTColor : map["normalTitleTColor"],
    sectionHeaderTColor : map["sectionHeaderTColor"],
    normalDescTColor : map["normalDescTColor"],
    sectionDescTextColor : map["sectionDescTextColor"],
    imageList : List<String>.from(jsonDecode(map["imageList"])),
    fadeColor : Color(map["fadeColor"]),
    isPaid : (map["isPaid"] == 1) ? true : false,
slideTitlesFontValue: (map['slideTitlesFontValue'] != null && (jsonDecode(map['slideTitlesFontValue']) as List).isNotEmpty)
        ? List<TextProperties>.from(jsonDecode((map['slideTitlesFontValue']))) 
        : [],
      slideSectionHeadersFontValue: (map['slideSectionHeadersFontValue'] != null && (jsonDecode(map['slideSectionHeadersFontValue']) as List).isNotEmpty)
        ? (jsonDecode(map['slideSectionHeadersFontValue']) as List)
            .map((header) => List<TextProperties>.from(header))
            .toList() 
        : [],
      slideSectionContentsFontValue: (map['slideSectionContentsFontValue'] != null && (jsonDecode(map['slideSectionContentsFontValue']) as List).isNotEmpty)
        ? (jsonDecode(map['slideSectionContentsFontValue']) as List)
            .map((content) => List<TextProperties>.from(content))
            .toList() 
        : [],
                  );
 }
}