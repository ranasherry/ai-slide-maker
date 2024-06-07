class BookPageModel {
  String ChapName;
  // Uint8List file;
  // DocumentFile File;
  String ChapData;

  BookPageModel({
    required this.ChapName,
    // required this.file,
    required this.ChapData,
  });

  Map<String, dynamic> toMap() => {
        'chapName': ChapName,
        'chapData': ChapData,
      };
  factory BookPageModel.fromMap(Map<String, dynamic> data) => BookPageModel(
        ChapName: data['chapName'] as String,
        ChapData: data['chapData'] as String,
      );
}

class SlideItem {
  final String slideTitle;
  final List<BookPageModel> listOfPages;
  final int timestamp; // Use milliseconds since epoch for consistency

  SlideItem({
    required this.slideTitle,
    required this.listOfPages,
    required this.timestamp,
  }); // Set timestamp on creation

  factory SlideItem.fromMap(Map<String, dynamic> data) => SlideItem(
        slideTitle: data['slideTitle'] as String,
        listOfPages: (data['listOfPages'] as List)
            .cast<Map<String, dynamic>>()
            .map((pageData) => BookPageModel.fromMap(pageData))
            .toList(),
        timestamp: data['timestamp'] as int,
      );

  Map<String, dynamic> toMap() => {
        'slideTitle': slideTitle,
        'listOfPages': listOfPages.map((page) => page.toMap()).toList(),
        'timestamp': timestamp,
      };
}
