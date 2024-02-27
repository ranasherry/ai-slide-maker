import 'package:get/get.dart';

import '../controllers/invitation_maker_controller.dart';

class InvitationMakerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvitationMakerController>(
      () => InvitationMakerController(),
    );
  }
}
