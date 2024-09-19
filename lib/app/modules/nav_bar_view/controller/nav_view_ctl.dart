import 'package:get/get.dart';
import 'package:slide_maker/app/modules/creation_view/view/creation_view.dart';
import 'package:slide_maker/app/modules/home/home_view_1.dart';
import 'package:slide_maker/app/modules/profile_view/view/profile_view.dart';

class NavCTL extends GetxController {
  RxInt current_index = 0.obs;

  int navAdCounter = 1;

  final screens = [
    HomeView1(),
    CreationView(),
    // ProfileView(),
  ];
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
