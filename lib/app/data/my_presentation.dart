import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:slide_maker/app/data/slide.dart';

class MyPresentation {
  int presentationId;
  String presentationTitle;
  RxList<MySlide> slides;
  // String slideStyleID;

  MyPresentation(
      {required this.presentationId,
      required this.presentationTitle,
      required this.slides});

  Map<String, dynamic> toMap() {
    return {
      'presentationId': presentationId,
      'presentationTitle': presentationTitle,
      'slides': slides?.map((x) => x.toMap()).toList(),
    };
  }
// method below added by rizwan
Map<String, dynamic> toMapDatabase() {
    return {
      'presentationId': presentationId,
      'presentationTitle': presentationTitle,
      'slides': jsonEncode(slides?.map((x) => x.toMap()).toList()),
    };
  }

  factory MyPresentation.fromMap(Map<String, dynamic> map) {
    return MyPresentation(
      presentationId: map['presentationId'] ?? 0 as int,
      presentationTitle: map['presentationTitle'] ?? "" as String,
      slides: (map['slides'] ?? [] as List)
          ?.map((x) => MySlide.fromMap(x as Map<String, dynamic>))
          .toList()
          .obs,
    );
  }
  // method below added by rizwan
  factory MyPresentation.fromMapDatabase(Map<String, dynamic> map) {
    return MyPresentation(
      presentationId: map['presentationId'] ?? 0 as int,
      presentationTitle: map['presentationTitle'] ?? "" as String,
      slides: RxList<MySlide> (
        (jsonDecode(map['slides']) as List<dynamic>)  
          .map((x) => MySlide.fromMap(x as Map<String, dynamic>))
          .toList(),
      )
    );
  }

  String toJson() => json.encode(toMap());

  factory MyPresentation.fromJson(String source) =>
      MyPresentation.fromMap(json.decode(source) as Map<String, dynamic>);
}
