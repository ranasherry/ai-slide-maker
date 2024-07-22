import 'package:get/get.dart';

import '../controllers/presentaion_generator_controller.dart';

class PresentaionGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresentaionGeneratorController>(
      () => PresentaionGeneratorController(),
    );
  }
}
