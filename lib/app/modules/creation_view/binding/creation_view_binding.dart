import 'package:get/get.dart';
import 'package:slide_maker/app/modules/creation_view/controller/creation_view_ctl.dart';

class CreationViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreationViewCtl());
  }
}
