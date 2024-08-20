import 'package:get/get.dart';

class pollScreenCTL extends GetxController {
  final RxList<Map<String, dynamic>> polls = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    polls.addAll([
      {
        'id': 1,
        'question': 'What is the meaning of life?',
        'end_date': DateTime(2026, 09, 30),
        'options': [
          {'id': 1, 'title': 'To love', 'votes': 42},
          {'id': 2, 'title': 'To live', 'votes': 10},
          {'id': 3, 'title': 'To die', 'votes': 19},
          {'id': 4, 'title': 'To be happy', 'votes': 25},
        ],
      },
    ]);
  }

  Future<bool> onVoted(String pollId, String pollOption) async {
    // Simulate HTTP request
    await Future.delayed(const Duration(seconds: 1));
    // If HTTP status is success, return true else false
    return true;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
