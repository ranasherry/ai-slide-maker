import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/history_ctl.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/controllers/settings_view_ctl.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeViewCtl());
    Get.put(SettingsViewCTL());
  }
}
