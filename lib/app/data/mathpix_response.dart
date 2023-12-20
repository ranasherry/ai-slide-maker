class MathpixResponse {
  var autoRotateConfidence;
  var autoRotateDegrees;
  var confidence;
  var confidenceRate;
  List<DataItem> data;
  bool isHandwritten;
  bool isPrinted;
  String requestId;
  String text;
  String version;

  MathpixResponse({
    required this.autoRotateConfidence,
    required this.autoRotateDegrees,
    required this.confidence,
    required this.confidenceRate,
    required this.data,
    required this.isHandwritten,
    required this.isPrinted,
    required this.requestId,
    required this.text,
    required this.version,
  });

  factory MathpixResponse.fromJson(Map<String, dynamic> json) {
    List<DataItem> dataItems = (json['data'] as List)
        .map((data) => DataItem.fromJson(data))
        .toList();

    return MathpixResponse(
      autoRotateConfidence: json['auto_rotate_confidence'],
      autoRotateDegrees: json['auto_rotate_degrees'],
      confidence: json['confidence'],
      confidenceRate: json['confidence_rate'],
      data: dataItems,
      isHandwritten: json['is_handwritten'],
      isPrinted: json['is_printed'],
      requestId: json['request_id'],
      text: json['text'],
      version: json['version'],
    );
  }
}

class DataItem {
  String type;
  String value;

  DataItem({
    required this.type,
    required this.value,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      type: json['type'],
      value: json['value'],
    );
  }
}
