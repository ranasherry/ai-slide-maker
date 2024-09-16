import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';

class PresentationHomeController extends GetxController {
  //TODO: Implement PresentationHomeController

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;

  FirestoreService fs = FirestoreService();

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    fetchPresentationHistory();
  }

  Future<void> fetchPresentationHistory() async {
    presentations.value = await PresentationHistoryDatabaseHandler.db
        .fetchAllPresentationHistory();
    developer.log("Fetched Presentation: $presentations");
  }

  Future<void> insertPresentation(MyPresentation myPresentation) async {
    developer.log("Presentation to be inserted: ${presentations.toJson()}");
//TODO: Add Dummy Likes

    int likesCount = Random().nextInt(50);
    if (kDebugMode) {
      myPresentation.likesCount = likesCount;
      debugPrint("Dummy Likes: $likesCount");
    }
    int returnResult = await PresentationHistoryDatabaseHandler.db
        .insertPresentationHistory(myPresentation);
    await fs.insertPresentationHistory(
        myPresentation, myPresentation.presentationId.toString());
//    fetchPresentationHistory();

    fetchPresentationHistory();
  }

  Future<void> updatePresentation(
      MyPresentation myPresentation, int presentationId) async {
    await PresentationHistoryDatabaseHandler.db
        .updatePresentationHistory(presentationId, myPresentation);
    await fs.updatePresentationHistory(
        myPresentation, presentationId.toString());
    fetchPresentationHistory();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }
}
