import 'package:get/get.dart';
import 'package:slide_maker/app/modules/showppt/controllers/show_p_p_t_controller.dart';

class ShowPPTBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowPPTController>(
      () => ShowPPTController(),
    );
  }
}
