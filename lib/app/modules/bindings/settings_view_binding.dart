import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/settings_view_ctl.dart';

class SettingsViewbinding extends Bindings {
  @override
  void dependencies() {
   
    Get.put(SettingsViewCTL());

  }
}