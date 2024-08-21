import 'package:get/get.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';

class PresentationHomeController extends GetxController {
  //TODO: Implement PresentationHomeController

  var presentations = <MyPresentation>[].obs;

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
}
