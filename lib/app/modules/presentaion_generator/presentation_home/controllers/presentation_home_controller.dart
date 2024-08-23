import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';

class PresentationHomeController extends GetxController {
  //TODO: Implement PresentationHomeController

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPresentationHistory();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchPresentationHistory() async {
    presentations.value = await PresentationHistoryDatabaseHandler.db
        .fetchAllPresentationHistory();
  }

  Future<void> insertPresentation(MyPresentation myPresentation) async {
    await PresentationHistoryDatabaseHandler.db
        .insertPresentationHistory(myPresentation);
    fetchPresentationHistory();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }
}
