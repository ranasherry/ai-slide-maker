import 'package:get/get.dart';
import 'package:slide_maker/app/modules/invitation_maker/controllers/weddinginvitation_controller.dart';

class WeddingInvitationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeddingInvitationController>(
      () => WeddingInvitationController(),
    );
  }
}
