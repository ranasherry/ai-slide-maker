import 'package:get/get.dart';
import 'package:slide_maker/app/modules/profile_view/controller/user_profileview_controller.dart';

class UserProfileviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserProfileviewController());
  }
}
