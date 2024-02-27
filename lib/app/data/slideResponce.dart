class SlideResponse {
  String slideTitle;
  String slideDescription;

  SlideResponse({
    required this.slideTitle,
    required this.slideDescription,
  });

  factory SlideResponse.fromJson(Map<String, dynamic> json) {
    return SlideResponse(
      slideTitle: json['slide_title'] as String,
      slideDescription: json['slide_descr'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slide_title': slideTitle,
      'slide_descr': slideDescription,
    };
  }

  factory SlideResponse.fromMap(Map<String, dynamic> json) {
    return SlideResponse(
      slideTitle: json['slide_title'] as String,
      slideDescription: json['slide_descr'] as String,
    );
  }
}
