import 'package:get/get.dart';

import '../controllers/presentation_home_controller.dart';

class PresentationHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresentationHomeController>(
      () => PresentationHomeController(),
    );
  }
}
