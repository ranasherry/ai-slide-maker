import 'package:get/get.dart';
import 'package:slide_maker/app/data/slideResponce.dart';
import 'package:slide_maker/app/data/slide_history.dart';
import 'package:slide_maker/app/data/slides_history_dbhandler.dart';

class HistorySlideCTL extends GetxController {
  SlidesHistory? slidesHistory;
  RxList<SlideResponse> slideResponseList = <SlideResponse>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    slidesHistory =
        Get.arguments[0] as SlidesHistory?; // Get argument and cast as nullable

    // Handle null case:
    if (slidesHistory == null) {
      // Example: Show an error message or navigate back
      Get.snackbar('Error', 'Slide history not found in arguments.');
      Get.back();
    } else {
      // Process slidesHistory
      slideResponseList
          .assignAll(slidesHistory!.slidesList); // Access slidesList safely
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
