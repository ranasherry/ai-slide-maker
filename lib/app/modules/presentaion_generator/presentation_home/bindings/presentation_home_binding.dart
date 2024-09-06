import 'package:get/get.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';

import '../controllers/presentation_home_controller.dart';

class PresentationHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresentationHomeController>(
      () => PresentationHomeController(),
    );
      //  Get.lazyPut<PresentationEditCtl>(
      // () => PresentationEditCtl(),
      //     );
  }
}
