import 'package:get/get.dart';
import 'package:slide_maker/app/modules/profile_view/controller/edit_profile_controller.dart';

class EditProfileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put((EditProfileController));
  }
}
