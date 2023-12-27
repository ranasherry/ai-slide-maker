import 'package:get/get.dart';

import '../controllers/show_p_d_f_controller.dart';

class ShowPDFBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowPDFController>(
      () => ShowPDFController(),
    );
  }
}
