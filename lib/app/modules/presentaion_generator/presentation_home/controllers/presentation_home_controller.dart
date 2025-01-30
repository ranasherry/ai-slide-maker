import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/provider/userdata_provider.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

class PresentationHomeController extends GetxController {
  //TODO: Implement PresentationHomeController

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;
  late SlidePallet slidePallet;
  RxList<SlidePallet> allSlidePallets = <SlidePallet>[].obs;

  FirestoreService fs = FirestoreService();

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllPresentationHistory();
    fetchAllSlidePallet();
  }

  SlidePallet getSlidePalletFromID(String id) {
    int index = palletList.indexWhere((s) => s.palletId == int.parse(id));
    if (index >= 0) {
      return palletList[index];
    } else {
      return palletList[0];
    }
  }

  Future<void> fetchAllPresentationHistory() async {
    presentations.value = await PresentationHistoryDatabaseHandler.db
        .fetchAllPresentationHistory();

    developer.log("Fetched Presentation: $presentations");
  }

  Future<void> fetchAllSlidePallet() async {
    allSlidePallets.value =
        await PresentationHistoryDatabaseHandler.db.fetchAllSlidePallet();

    // developer.log("Fetched All slide pallets: ${await PresentationHistoryDatabaseHandler.db
    //     .fetchAllSlidePallet()}");
  }

  Future<SlidePallet> fetchSlidePalletById(int slidePalletId) async {
    slidePallet = await PresentationHistoryDatabaseHandler.db
        .fetchSlidePalletById(slidePalletId);
    developer.log("Fetched Slide Pallet: ${slidePallet.palletId}");
    return slidePallet;
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
    fetchAllPresentationHistory();
  }

  Future<void> insertPresentationWithSlidePallet(
      SlidePallet slidePallet, MyPresentation myPresentation) async {
    int rowId = await PresentationHistoryDatabaseHandler.db
        .insertSlidePallet(slidePallet);

//TODO: Uncomment when full rollout
    // await fs.insertSlidePallet(
    //     slidePallet, myPresentation.presentationId.toString());

    myPresentation.styleId.value = rowId.toString();
    developer.log("this is style id :${myPresentation.styleId.value} ${rowId}");
    await PresentationHistoryDatabaseHandler.db
        .insertPresentationHistory(myPresentation);
    final userdataProvider =
        Provider.of<UserdataProvider>(Get.context!, listen: false);

    UserData? userData = userdataProvider.getUserData;

    if (userData != null) {
      String? createrId = userData.id;
      myPresentation.createrId = createrId;
      await fs.insertPresentationHistory(
          myPresentation, myPresentation.presentationId.toString());
    }

    fetchAllPresentationHistory();
  }

  Future<void> updatePresentation(
      MyPresentation myPresentation, int presentationId) async {
    await PresentationHistoryDatabaseHandler.db
        .updatePresentationHistory(presentationId, myPresentation);
    await fs.updatePresentationHistory(
        myPresentation, presentationId.toString());
    fetchAllPresentationHistory();
  }

  Future<void> updateSlidePallet(
      SlidePallet slidePallet, int slidePalletId) async {
    await PresentationHistoryDatabaseHandler.db
        .updateSlidePallet(slidePalletId, slidePallet);
    await fs.updateSlidePallet(slidePallet, slidePalletId.toString());
    fetchSlidePalletById(slidePalletId);
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }
}
