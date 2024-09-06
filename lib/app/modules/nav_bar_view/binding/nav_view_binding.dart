import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/creation_view/controller/creation_view_ctl.dart';
import 'package:slide_maker/app/modules/nav_bar_view/controller/nav_view_ctl.dart';

class NavViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavCTL());
    Get.put(HomeViewCtl());
    Get.put(CreationViewCtl());  
  }
}
