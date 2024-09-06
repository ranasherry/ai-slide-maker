import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'dart:developer' as developer;

class CreationViewCtl extends GetxController {
  RxList<MyPresentation> presentations = <MyPresentation>[].obs;
  RxBool isLoading = true.obs;
  var lastDoc; // To track the last document
  var isMoreDataAvailable = true.obs;
  ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadInitialData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isMoreDataAvailable.value) {
        loadMoreData();
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    var result =
        await FirestoreService().fetchPresentationHistoryFirestorePagenation();
    presentations.assignAll(result['presentations'] as List<MyPresentation>);
    lastDoc = result['lastDoc'];
    isLoading.value = false;
  }

  Future<void> loadMoreData() async {
    developer.log("loadMoreData");

    if (lastDoc == null) {
      isMoreDataAvailable.value = false;
      return;
    }
    isLoading.value = true;
    var result = await FirestoreService()
        .fetchPresentationHistoryFirestorePagenation(lastDoc: lastDoc);
    final listPres = result['presentations'] as List<MyPresentation>;

    if (listPres.isEmpty) {
      isMoreDataAvailable.value = false;
    } else {
      presentations.addAll(result['presentations'] as List<MyPresentation>);
      lastDoc = result['lastDoc'];
    }
    isLoading.value = false;
  }
}
