import 'package:get/get.dart';

import '../controllers/pdf_view_controller.dart';

class PdfViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfViewController>(
      () => PdfViewController(),
    );
  }
}
