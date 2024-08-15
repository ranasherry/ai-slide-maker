import 'package:get/get.dart';
import 'package:slide_maker/app/modules/in_app_purchases/controllers/new_in_app_purchase_controller.dart';

class newInAppPurchaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(newInAppPurchaseCTL());
  }
}
