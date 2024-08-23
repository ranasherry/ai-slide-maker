import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
import 'package:slide_maker/app/data/slide.dart';

class PresentationOpenCtl extends GetxController {
  //TODO: Implement PresentationHomeController

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;

  RxString presentationTitle = "".obs;

  Rx<MyPresentation> myPresentation = MyPresentation(
    presentationId: 0,
    presentationTitle: "",
    slides: <MySlide>[].obs,
    createrId: null,
    timestamp: DateTime.now().millisecondsSinceEpoch,
    styleId: '1',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    MyPresentation pres = Get.arguments[0] as MyPresentation;

    presentationTitle.value = pres.presentationTitle;
    myPresentation.value = pres;
    developer.log("Opened Slide: ${pres.toMap()}");
  }

  @override
  void onClose() {
    super.onClose();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }
}
