import 'package:get/get.dart';

import '../controllers/in_app_purchases_controller.dart';

class InAppPurchasesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InAppPurchasesController>(
      () => InAppPurchasesController(),
    );
  }
}
