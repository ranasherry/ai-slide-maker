import 'package:get/get.dart';

import '../controllers/slide_maker_controller.dart';

class SlideMakerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlideMakerController>(
      () => SlideMakerController(),
    );
  }
}
