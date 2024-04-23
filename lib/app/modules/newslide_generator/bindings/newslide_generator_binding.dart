import 'package:get/get.dart';

import '../controllers/newslide_generator_controller.dart';

class NewslideGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewslideGeneratorController>(
      () => NewslideGeneratorController(),
    );
  }
}
