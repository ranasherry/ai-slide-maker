import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/like.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/utills/CM.dart';

class CreationViewProvider extends ChangeNotifier {
  List<MyPresentation> presentations = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  var lastDoc; // To track the last document
  bool isMoreDataAvailable = true;
  ScrollController scrollController = ScrollController();

  String searchTerm = '';

  CreationViewProvider() {
    loadInitialData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isMoreDataAvailable) {
        loadMoreData();
      }
    });
  }

  Future<void> loadInitialData() async {
    isLoading = true;
    notifyListeners();
    // var result =
    //     await FirestoreService().fetchPresentationHistoryFirestorePagenation();
    var result = await FirestoreService()
        .fetchPresentationHistoryFirestorePagenation(searchTerm: searchTerm);
    presentations = result['presentations'] as List<MyPresentation>;
    lastDoc = result['lastDoc'];
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadSearchData() async {
    isLoading = true;
    notifyListeners();
    // var result =
    //     await FirestoreService().fetchPresentationHistoryFirestorePagenation();
    var result = await FirestoreService()
        .fetchPresentationHistoryFirestoreSearch(searchTerm: searchTerm);
    presentations = result['presentations'] as List<MyPresentation>;
    lastDoc = result['lastDoc'];
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreData() async {
    developer.log("loadMoreData");
    if (lastDoc == null) {
      isMoreDataAvailable = false;
      notifyListeners();
      return;
    }

    if (isLoadingMore) return;

    isLoadingMore = true;
    Future.delayed(Duration(milliseconds: 4000), () async {
      // isLoading = true;
      notifyListeners();
      var result = await FirestoreService()
          .fetchPresentationHistoryFirestorePagenation(lastDoc: lastDoc);
      final listPres = result['presentations'] as List<MyPresentation>;

      if (listPres.isEmpty) {
        isMoreDataAvailable = false;
      } else {
        presentations.addAll(listPres);
        lastDoc = result['lastDoc'];
      }
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    });
  }

  void searchPresentation(String term) {
    searchTerm = term;
    if (searchTerm.isEmpty) {
      loadInitialData();
    } else {
      loadSearchData();
    }
  }

  likePresentation(String PresID) async {
    //? Check if User is Logged in
    //? get UserUnique ID
    int index = presentations
        .indexWhere((pres) => pres.presentationId == int.parse(PresID));
    if (FirebaseAuth.instance.currentUser != null) {
      Like like = Like(
          userId: FirebaseAuth.instance.currentUser!.uid,
          likeId: DateTime.now().millisecondsSinceEpoch,
          createdAt: DateTime.now().millisecondsSinceEpoch);

      try {
        await FirestoreService().addLike(PresID, like);
        presentations[index].likesCount++;
        presentations[index].isLiked = true;
        notifyListeners();
      } on Exception catch (e) {
        // TODO
      }
    } else {
      developer.log("Singin to Like the content");
      ComFunction.showSignInRequire(Get.context!);

      //? Aske User to Login
    }
  }

  Future<UserData?> getUserFromID(String userID) async {
    UserData? user = await FirestoreService().getUserByID(userID);

    return user;
  }

  Future<bool> isPresentationLikedByUser(String presID) async {
    bool isLiked = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLiked = await FirestoreService()
          .isLikedByUser(FirebaseAuth.instance.currentUser!.uid, presID);
    }
    return isLiked;
  }

  getUpdatedLikesCount(int presentationId) {
    int index = presentations
        .indexWhere((pres) => pres.presentationId == presentationId);

    return presentations[index].likesCount;
  }

  Future<void> unlikePresentation(String PresID) async {
    int index = presentations
        .indexWhere((pres) => pres.presentationId == int.parse(PresID));
    if (FirebaseAuth.instance.currentUser != null) {
      Like like = Like(
          userId: FirebaseAuth.instance.currentUser!.uid,
          likeId: DateTime.now().millisecondsSinceEpoch,
          createdAt: DateTime.now().millisecondsSinceEpoch);

      try {
        await FirestoreService().removeLike(PresID, like);
        presentations[index].likesCount--;
        presentations[index].isLiked = false;
        notifyListeners();
      } on Exception catch (e) {
        // TODO
      }
    } else {
      developer.log("Singin to Like the content");
      ComFunction.showSignInRequire(Get.context!);

      //? Aske User to Login
    }
  }
}
