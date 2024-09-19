import 'package:get/get.dart';
import 'package:slide_maker/app/modules/profile_view/controller/edit_profile_controller.dart';
import 'package:slide_maker/app/modules/profile_view/controller/profile_view_controller.dart';

class ProfileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileViewCTL());
    // Get.put(EditProfileController());
  }
}
