import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/history_ctl.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HistoryCTL());
  }
}
