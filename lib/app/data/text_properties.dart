import 'dart:ui';

import 'package:flutter/material.dart';

class TextProperties{
  double? fontSize;
  FontWeight? fontWeight;
  Color? fontColor;

  TextProperties({
    this.fontSize,
    this.fontWeight,
    this.fontColor,
  });

Map<String, dynamic> toMap() {
  return {
    "fontSize": fontSize,
    "fontWeight": fontWeight != null ? fontWeight!.index : null, 
    "fontColor": fontColor !=null ? fontColor!.value : null,
  };
}



 static TextProperties fromMap(Map<String,dynamic> map){
  return TextProperties(
    fontSize: map['fontSize'] as double?,
    fontWeight: map['fontWeight'] != null ? FontWeight.values[map['fontWeight']] : FontWeight.normal,
    fontColor: map['fontColor'] !=null ? Color((map['fontColor'])) : Colors.transparent,
    );

 }
}