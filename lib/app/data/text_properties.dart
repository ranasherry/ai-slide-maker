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
    "fontColor": fontColor,
  };
}


 static TextProperties fromMap(Map<String,dynamic> map){
  return TextProperties(
    fontSize: map['fontSize'],
    fontWeight: map['fontWeight'],
    fontColor: map['fontColor'],
    );

 }
}