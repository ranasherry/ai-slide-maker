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
  List<TextProperties>? slideTitlesTextProperties;
  List<List<TextProperties>>? slideSectionHeadersTextProperties;
  List<List<TextProperties>>? slideSectionContentsTextProperties;

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
    this.slideTitlesTextProperties,
    this.slideSectionHeadersTextProperties,
    this.slideSectionContentsTextProperties,
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
   'slideTitlesTextProperties': jsonEncode(slideTitlesTextProperties?.map((e)=>e.toMap()).toList() ?? []),
    'slideSectionHeadersTextProperties': jsonEncode(slideSectionHeadersTextProperties?.map((e)=>e.map((element)=>element.toMap()).toList()).toList() ?? []),
    'slideSectionContentsTextProperties': jsonEncode(slideSectionContentsTextProperties?.map((e)=>e.map((element)=>element.toMap()).toList()).toList() ?? []),
  };
 }

 static SlidePallet fromMap(Map<String,dynamic> map){
   print("slideTitlesTextProperties (raw from DB): ${map['slideTitlesTextProperties']}");
  print("slideSectionHeadersTextProperties (raw from DB): ${map['slideSectionHeadersTextProperties']}");
  print("slideSectionContentsTextProperties (raw from DB): ${map['slideSectionContentsTextProperties']}");
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
slideTitlesTextProperties: (map['slideTitlesTextProperties'] != null && (jsonDecode(map['slideTitlesTextProperties']) as List).isNotEmpty)
        ? List<TextProperties>.from((jsonDecode(map['slideTitlesTextProperties']) as List).map((e)=>TextProperties.fromMap(e))) 
        : [],
      slideSectionHeadersTextProperties: (map['slideSectionHeadersTextProperties'] != null && (jsonDecode(map['slideSectionHeadersTextProperties']) as List).isNotEmpty)
        ? (jsonDecode(map['slideSectionHeadersTextProperties']) as List)
            .map((header) => List<TextProperties>.from((header as List).map((e)=> TextProperties.fromMap(e))))
            .toList() 
        : [],
      slideSectionContentsTextProperties: (map['slideSectionContentsTextProperties'] != null && (jsonDecode(map['slideSectionContentsTextProperties']) as List).isNotEmpty)
        ? (jsonDecode(map['slideSectionContentsTextProperties']) as List)
            .map((content) => List<TextProperties>.from((content as List).map((e)=> TextProperties.fromMap(e))))
            .toList() 
        : [],
                  );
 }
 void setColor(){
  slideTitlesTextProperties?.map((e)=>e.fontColor=Color(bigTitleTColor));
 }
}