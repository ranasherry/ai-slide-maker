import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/history_ctl.dart';
import 'package:slide_maker/app/modules/controllers/history_slide_ctl.dart';

class HistorySlideBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HistorySlideCTL());
  }
}
