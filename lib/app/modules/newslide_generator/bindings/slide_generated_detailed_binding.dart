import 'package:get/get.dart';
import 'package:slide_maker/app/modules/newslide_generator/controllers/slide_detailed_generated_ctl.dart';

import '../controllers/newslide_generator_controller.dart';

class SlideGeneratedDetailedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlideDetailedGeneratedCTL>(
      () => SlideDetailedGeneratedCTL(),
    );
  }
}
