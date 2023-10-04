class SlideResponse {
  final String slideTitle;
  final String slideDescription;

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
}