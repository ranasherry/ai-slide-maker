import 'package:get/get.dart';
import 'package:slide_maker/app/modules/showppt/controllers/ppt_listview_ctl.dart';
import 'package:slide_maker/app/modules/showppt/controllers/show_p_p_t_controller.dart';

class PPTListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PPTListController>(
      () => PPTListController(),
    );
  }
}
