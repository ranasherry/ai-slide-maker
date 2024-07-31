import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';

class MySlide {
  int? id;
  String slideTitle;
  List<SlideSection> slideSections;
  SlideType slideType;

  MySlide(
      {this.id,
      required this.slideTitle,
      required this.slideSections,
      required this.slideType});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slideTitle': slideTitle,
      'slideSections': slideSections?.map((x) => x.toMap()).toList(),
      'slideType': slideType?.value,
    };
  }

  factory MySlide.fromMap(Map<String, dynamic> map) {
    return MySlide(
      id: map['id'] as int?,
      slideTitle: map['slideTitle'] ?? "" as String,
      slideSections: List<SlideSection>.from((map['slideSections'] as List)
          .map<SlideSection>(
              (x) => SlideSection.fromMap(x as Map<String, dynamic>))),

      // slideSections: (map['slideSections'] ?? [] as List)
      //     ?.map((x) => SlideSection.fromMap(x as Map<String, dynamic>))
      //     .toList(),
      slideType: SlideType.fromString(map['slideType'] ?? "title" as String) ??
          SlideType.title,
    );
  }

  String toJson() => json.encode(toMap());

  factory MySlide.fromJson(String source) =>
      MySlide.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum SlideType {
  title,
  sectioned;

  static SlideType? fromString(String value) {
    switch (value) {
      case 'title':
        return SlideType.title;
      case 'sectioned':
        return SlideType.sectioned;
      default:
        return null; // Or throw an exception if invalid value
    }
  }
}

extension SlideTypeExtension on SlideType {
  // Helper method to convert enum to string
  String get value {
    switch (this) {
      case SlideType.title:
        return 'title';
      case SlideType.sectioned:
        return 'sectioned';
    }
  }

  // Helper method to convert string to enum
}

class SlideSection {
  String? sectionHeader;
  String? sectionContent;
  Uint8List? memoryImage;

  SlideSection({this.sectionHeader, this.sectionContent, this.memoryImage});

  Map<String, dynamic> toMap() {
    return {
      'sectionHeader': sectionHeader,
      'sectionContent': sectionContent,
      'memoryImage':
          memoryImage?.toList(), // Convert Uint8List to List for JSON
    };
  }

  factory SlideSection.fromMap(Map<String, dynamic> map) {
    return SlideSection(
        sectionHeader: map['sectionHeader'] as String?,
        sectionContent: map['sectionContent'] as String?,
        memoryImage: map['memoryImage'] != null
            ? Uint8List.fromList(map['memoryImage'].cast<int>())
            : null
        // map['memoryImage'] != null
        //     ? Uint8List.fromList(map['memoryImage'])
        //     : null,
        );
  }

  String toJson() => json.encode(toMap());

  factory SlideSection.fromJson(String source) =>
      SlideSection.fromMap(json.decode(source) as Map<String, dynamic>);
}
