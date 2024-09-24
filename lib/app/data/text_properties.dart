import 'dart:ui';

class TextProperties{
  double? fontSize;
  double? fontWeight;
  Color? fontColor;

  TextProperties({
    this.fontSize,
    this.fontWeight,
    this.fontColor,
  });

Map<String, dynamic> toMap(){
  return {
    "fontSize": fontSize,
    "fontWeight": fontWeight,
    "fontColor": fontColor?.value,
  };
}


 static TextProperties fromMap(Map<String,dynamic> map){
  return TextProperties(
    fontSize: map['fontSize'] as double?,
    fontWeight: map['fontWeight'] as double?,
    fontColor: map['fontColor'] != null ? Color(map['fontColor']) : null,
    );

 }
}