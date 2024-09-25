import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/my_firebase_user.dart';

class UserProfileviewController extends GetxController {
  Rx<UserData> userData = UserData(
          id: "",
          name: "",
          email: "",
          revenueCatUserId: "",
          gender: "male",
          joinDate: Timestamp.fromDate(DateTime(2024, 9, 23)))
      .obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    userData.value = Get.arguments[0] as UserData;
    isLoading.value = false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
