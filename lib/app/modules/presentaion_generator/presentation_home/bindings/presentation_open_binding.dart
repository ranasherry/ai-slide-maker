import 'package:get/get.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_open_ctl.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';

import '../controllers/presentation_home_controller.dart';

class PresentationOpenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresentationOpenCtl>(
      () => PresentationOpenCtl(),
    );
    Get.lazyPut<PresentationEditCtl>(
      () => PresentationEditCtl(),
    );

       
  }
}
