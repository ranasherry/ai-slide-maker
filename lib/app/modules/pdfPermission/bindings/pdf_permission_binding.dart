import 'package:get/get.dart';

import '../controllers/pdf_permission_controller.dart';

class PdfPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfPermissionController>(
      () => PdfPermissionController(),
    );
  }
}
