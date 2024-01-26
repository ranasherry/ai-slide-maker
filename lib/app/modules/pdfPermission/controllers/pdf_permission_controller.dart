import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

class PdfPermissionController extends GetxController {
  //TODO: Implement PermissionPageController
  final count = 0.obs;
  int andriodVersion = 0;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String routes = "";
  // PermissionStatus status;
  @override
  void onInit() {
    super.onInit();

    routes = Get.arguments as String;
  }

  checkPermission() async {
    var andriod = await deviceInfo.androidInfo;
    print("Info: ${andriod.version.release}");
    andriodVersion = int.parse(andriod.version.release);
    print("Info: ${andriodVersion}");
    if (andriodVersion >= 11) {
      PermissionStatus status =
          await Permission.manageExternalStorage.request();
      Route(status);
    } else {
      PermissionStatus status = await Permission.storage.request();
      Route(status);
    }
    // PermissionStatus status = await Permission.manageExternalStorage.request();
    // PermissionStatus status = await Permission.storage.request();
    // if (status == PermissionStatus.granted) {
    //   print("Storage Granted");
    //   Get.offNamed(Routes.HomeView);
    // }
  }

  Route(status) {
    if (status == PermissionStatus.granted) {
      print("Storage Granted");
      Get.back();
      Get.toNamed(routes);
      // Get.offNamed(routes);
      // Get.offNamed(Routes.HomeView);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
