import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/slide_assistant_controller.dart';

class AiSlideAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AiSlideAssistantCTL());
  }
}
