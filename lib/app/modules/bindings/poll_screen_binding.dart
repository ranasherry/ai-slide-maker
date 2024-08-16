import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/poll_screen_controller.dart';

class PollScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(pollScreenCTL());
    ;
  }
}
