import 'dart:convert';

import 'package:slide_maker/app/data/helping_enums.dart';

class BookPageModel {
  String ChapName;
  // Uint8List file;
  // DocumentFile File;
  String ChapData;
  String? ImagePath;
  SlideImageType imageType;
  bool containsImage;

  BookPageModel({
    required this.ChapName,
    // required this.file,
    required this.ChapData,
    this.ImagePath,
    required this.imageType,
    required this.containsImage,
  });

  Map<String, dynamic> toMap() => {
        'chapName': ChapName,
        'chapData': ChapData,
        'ImagePath': ImagePath,
        'imageType': imageType.toString(),
        'containsImage': containsImage.toString(),
      };

  factory BookPageModel.fromJson(Map<String, dynamic> json) {
    return BookPageModel(
        ChapName: json['chapName'] as String,
        ChapData: json['chapData'] as String,
        ImagePath: json['ImagePath'] as String,
        imageType: SlideImageType.svg,
        containsImage: bool.parse(json['containsImage'] as String));
  }

  factory BookPageModel.fromMap(Map<String, dynamic> data) => BookPageModel(
      ChapName: data['chapName'] as String,
      ChapData: data['chapData'] as String,
      ImagePath: data['ImagePath'] as String,
      imageType: SlideImageType.svg,
      containsImage: bool.parse(data['containsImage'] as String));
}

class SlideItem {
  int id = 0;
  final String slideTitle;
  final List<BookPageModel> listOfPages;
  final int timestamp; // Use milliseconds since epoch for consistency

  SlideItem({
    required this.id,
    required this.slideTitle,
    required this.listOfPages,
    required this.timestamp,
  }); // Set timestamp on creation

  factory SlideItem.fromMap(Map<String, dynamic> data) {
    final slidesListJson = data['listOfPages'];

    List<BookPageModel> slidesList = [];
    if (slidesListJson != null) {
      slidesList = (jsonDecode(slidesListJson) as List)
          .map((e) => BookPageModel.fromJson(e))
          .toList(); // Decode and convert to SlideResponse objects
    }

    return SlideItem(
      id: data['id'],
      slideTitle: data['slideTitle'] as String,
      listOfPages: slidesList,
      timestamp: data['timestamp'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final slidesListJson =
        jsonEncode(listOfPages.map((e) => e.toMap()).toList());
    return {
      // 'id': id,
      'slideTitle': slideTitle,
      'listOfPages': slidesListJson,
      'timestamp': timestamp,
    };
  }
}
