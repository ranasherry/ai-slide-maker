import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

class WeddingInvitationController extends GetxController {
  //TODO: Implement InvitationMakerController

  final count = 0.obs;

  final groomNameTextController = TextEditingController();
  final brideNameTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final contactNoController = TextEditingController();

  DateTime dateTime = DateTime.now();
  GlobalKey shotKey = GlobalKey();

  //? All Bool Entities Below
  RxBool isOnTemplates = false.obs;

  @override
  void onInit() {
    super.onInit();
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

  void onNext() {
    final groomName = groomNameTextController.text;
    final brideName = brideNameTextController.text;
    final contactNumber = contactNoController.text;

    if (groomName.isEmpty || brideName.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all fields correctly.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    } else {
      isOnTemplates.value = true;
      Get.snackbar(
        'Success!',
        'Wedding invitation details submitted.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    // Handle successful form submission (replace with your desired action)
  }

  void saveCard() async {
    WidgetShotRenderRepaintBoundary repaintBoundary = shotKey.currentContext!
        .findRenderObject() as WidgetShotRenderRepaintBoundary;
    var resultImage = await repaintBoundary.screenshot(
        // backgroundColor: Colors.amberAccent,
        format: ShotFormat.png,
        pixelRatio: 1);

    try {
      /// 存储的文件的路径
      String path = (await getTemporaryDirectory()).path;
      path += '/${DateTime.now().toString()}.png';
      File file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      }
      await file.writeAsBytes(resultImage!);
      debugPrint("result = ${file.path}");

      Share.shareXFiles(
        [
          XFile(file.path)
          // XFile.fromData(
          //   resultImage,
          //   name: 'WeddingInvitation.ppt',
          //   lastModified: DateTime.now(),
          //   length: resultImage.length,
          // )
        ],
        // text: 'Presentation',
      );
    } catch (error) {
      /// flutter保存图片到App内存文件夹出错
      debugPrint("error = ${error}");
    }
  }
}
