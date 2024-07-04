import 'package:get/get.dart';
import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/slide_history.dart';
import 'package:slide_maker/app/data/slides_history_dbhandler.dart';

class HistoryCTL extends GetxController {
  RxList<SlideItem> savedSlides = <SlideItem>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchSlideHistory();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> fetchSlideHistory() async {
    print("FetchUserCalled..");
    try {
      final slides =
          await SlideHistoryDatabaseHandler.db.fetchAllSlideHistory();
      savedSlides.value = slides; // Update the observable list
    } catch (error) {
      print('Error fetching slides: $error');
      // Handle error appropriately, e.g., show an error message
    }
  }
}
