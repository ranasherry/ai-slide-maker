import 'package:get/get.dart';

import '../controllers/ppt_uploader_controller.dart';

class PptUploaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PptUploaderController>(
      () => PptUploaderController(),
    );
  }
}
