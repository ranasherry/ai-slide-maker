import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/slide_maker_controller.dart';

// import '../../home/controllers/nav_view_ctl.dart';
import '../../utills/Gems_rates.dart';

class GemsViewController extends GetxController {
  //TODO: Implement GemsViewController
  SlideMakerController slideMakerController = Get.find();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  increase_inter_gems() {
    slideMakerController.increaseGEMS(GEMS_RATE.INTER_INCREAES_GEMS_RATE);
  }

  increase_reward_gems() {
    slideMakerController.increaseGEMS(GEMS_RATE.REWARD_INCREAES_GEMS_RATE);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
