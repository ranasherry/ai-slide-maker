import 'package:get/get.dart';
import 'package:slide_maker/app/modules/intro_screens/controllers/new_intro_screen_controller.dart';

class newIntroScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<newInroScreenCTL>(
      () => newInroScreenCTL(),
    );
  }
}
