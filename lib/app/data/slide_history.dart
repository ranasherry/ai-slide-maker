import 'dart:convert';

import 'package:slide_maker/app/data/slideResponce.dart';

class SlidesHistory {
  int id = 0;
  String title = '';
  DateTime timestamp = DateTime.now(); // Initialize with current time
  List<SlideResponse> slidesList =
      <SlideResponse>[]; // Use dynamic for flexibility in slide content

  // Constructor to initialize properties
  SlidesHistory({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.slidesList,
  });

  // Convert model to Map for database storage
  Map<String, dynamic> toMap() {
    final slidesListJson =
        jsonEncode(slidesList.map((e) => e.toMap()).toList());
    // final slidesListJson = jsonEncode(slidesList);
    return {
      // 'id': id,
      'title': title,
      'timestamp': timestamp.millisecondsSinceEpoch, // Store as milliseconds
      'slidesList': slidesListJson,
    };
  }

  // Create SlidesModel object from Map (retrieved from database)
  static SlidesHistory fromMap(Map<String, dynamic> map) {
    final slidesListJson = map['slidesList'];
    List<SlideResponse> slidesList = [];
    if (slidesListJson != null) {
      slidesList = (jsonDecode(slidesListJson) as List)
          .map((e) => SlideResponse.fromJson(e))
          .toList(); // Decode and convert to SlideResponse objects
    }

    return SlidesHistory(
      id: map['id'],
      title: map['title'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      slidesList: slidesList,
    );
  }
}
