import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/comment.dart';
import 'package:slide_maker/app/data/like.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/data/user.dart';

class FirestoreService {
  static final FirestoreService _instance =
      FirestoreService._internal(); // Singleton instance

  factory FirestoreService() {
    // Factory constructor for access
    return _instance;
  }
  FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final String userCollectionPath =
  //     kDebugMode ? 'testUser' : 'users'; // Customizable collection path

  final String userCollectionPath = 'users';

  final String _collectionPath = 'premiumUsers'; // Customizable collection path
  final String _historySubcollectionPath =
      'history'; // Customizable subcollection path

  String UserID = "temp";
  //added by rizwan
  // String presentationCollectionPath = "presentationTest"; // ? commented by jamal!
  String presentationCollectionPath = "presentation";
  String slidePalletCollectionPath = "slidePalletTest";
  String subcollectionLikes = 'likes';
  String subcollectionComments = 'comments';

  /// Creates a new user document with an empty history list, generationCount of 0, and tokensConsumed of 0.
  Future<void> createUser({required String uid}) async {
    final userExists = await _doesUserExist(uid);

    if (!userExists) {
      await _firestore.collection(_collectionPath).doc(uid).set({
        'generationCount': 0,
        'tokensConsumed': 0,
      });
      UserID =
          uid; // Assuming this is for internal tracking (avoid storing in client-side code)

      print(
          'User created successfully: $uid'); // Optional logging for debugging
    } else {
      print(
          'User already exists: $uid'); // Optional logging for informative messages
    }
    // UserID = uid;
  }

  Future<bool> _doesUserExist(String uid) async {
    final docRef = _firestore.collection(_collectionPath).doc(uid);
    final snapshot = await docRef.get();
    return snapshot.exists;
  }

  /// Retrieves a user document by its UID.
  Future<PremiumUser?> getUser({required String uid}) async {
    final docSnapshot =
        await _firestore.collection(_collectionPath).doc(uid).get();
    return docSnapshot.exists
        ? PremiumUser.fromMap(docSnapshot.data()!, uid)
        : null;
  }

  /// Increments the generationCount for the user with the given UID.
  Future<void> increaseGenerationCount({
    required String uid,
  }) async {
    await _firestore.runTransaction((transaction) async {
      final docRef = _firestore.collection(_collectionPath).doc(uid);
      final docSnapshot = await transaction.get(docRef);
      if (docSnapshot.exists) {
        final user = PremiumUser.fromMap(docSnapshot.data()!, uid);
        transaction
            .update(docRef, {'generationCount': user.generationCount + 1});
      }
    });
  }

  /// Increments the tokensConsumed for the user with the given UID.
  Future<void> increaseTokensConsumed(
      {required String uid, required int increament}) async {
    await _firestore.runTransaction((transaction) async {
      final docRef = _firestore.collection(_collectionPath).doc(uid);
      final docSnapshot = await transaction.get(docRef);
      if (docSnapshot.exists) {
        final user = PremiumUser.fromMap(docSnapshot.data()!, uid);
        transaction.update(
            docRef, {'tokensConsumed': user.tokensConsumed + increament});
      }
    });
  }

  // Add other necessary functions here, such as updating history list, etc.

  //? History Items
  /// Creates a new history item for the user with the given UID, with a unique ID based on current time in milliseconds since epoch.
  Future<void> addHistoryItem(String uid, SlideItem item) async {
    final docRef = _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection(_historySubcollectionPath)
        .doc(item.timestamp.toString());
    await docRef.set(item.toMap());
  }

  /// Retrieves a list of history items for the user with the given UID.
  Future<List<SlideItem>> getHistory(String uid) async {
    final querySnapshot = await _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection(_historySubcollectionPath)
        .get();
    return querySnapshot.docs
        .map((docSnapshot) => SlideItem.fromMap(docSnapshot.data()!))
        .toList();
  }

// Method below added by rizwan
  Future<void> insertPresentationHistory(
      MyPresentation presentationHistory, String presentationId) async {
    final docRef =
        _firestore.collection(presentationCollectionPath).doc(presentationId);
    await docRef.set(presentationHistory.toMapDatabase());
  }

  // Method below added by rizwan
  Future<void> insertSlidePallet(
      SlidePallet slidePallet, String slidePalletId) async {
    final docRef =
        _firestore.collection(slidePalletCollectionPath).doc(slidePalletId);
    await docRef.set(slidePallet.toMap());
  }

  // Method added by rizwan
  Future<List<MyPresentation>> fetchPresentationHistoryFirestore() async {
    final querySnapshot =
        await _firestore.collection(presentationCollectionPath).get();
    print(
        "these are presenatations ${querySnapshot.docs.map((docSnapshot) => MyPresentation.fromMapDatabase(docSnapshot.data()!)).toList()}");

    return querySnapshot.docs
        .map((docSnapshot) =>
            MyPresentation.fromMapDatabase(docSnapshot.data()!))
        .toList();
  }

  Future<Map<String, Object?>> fetchPresentationHistoryFirestorePagenation(
      {DocumentSnapshot? lastDoc, String searchTerm = ''}) async {
    log("Entered Firebase History fecth");
    // Query query =
    //     FirebaseFirestore.instance.collection('presentations').limit(10);

    try {
      Query query = _firestore
          .collection(presentationCollectionPath)
          .orderBy('likesCount',
              descending: true) // Adjust the order based on your requirement
          .limit(10);

      // if (searchTerm.isNotEmpty) {
      //   query = query
      //       .where('fieldName', isGreaterThanOrEqualTo: searchTerm)
      //       .where('fieldName',
      //           isLessThanOrEqualTo:
      //               searchTerm + '\uf8ff'); // For text matching
      // }

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
        log("Fetch Query: ${query.parameters}");
      }
      log("Fetch Query2: ${query.parameters}");

      final querySnapshot = await query.get();

      final presentations = querySnapshot.docs
          .map((docSnapshot) => MyPresentation.fromMapDatabase(
              docSnapshot.data()! as Map<String, dynamic>))
          .toList();

      log("Fetched Presentations: ${presentations.toList()}");

      return {
        'presentations': presentations,
        'lastDoc':
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
      };
    } on Exception catch (e) {
      log("Fetched Presentations Error: ${e}");

      // TODO
      return {
        'presentations': <MyPresentation>[],
        'lastDoc': null,
      };
    }
  }

  Future<Map<String, Object?>> fetchPresentationHistoryFirestoreSearch(
      {DocumentSnapshot? lastDoc, String searchTerm = ''}) async {
    log("Entered Firebase History fecth");
    Query query = FirebaseFirestore.instance
        .collection(presentationCollectionPath)
        .limit(10);

    try {
      if (searchTerm.isNotEmpty) {
        // Improved search using lowercased searchTerm and field values
        query = query
            .where('presentationTitle', isGreaterThanOrEqualTo: searchTerm)
            .where('presentationTitle',
                isLessThanOrEqualTo: searchTerm + '\uf8ff')
            .orderBy(
                'presentationTitle'); // Order by the same field used in the where clause
      } else {
        query = query.orderBy('timestamp'); // Default ordering
      }
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
        log("Fetch Query: ${query.parameters}");
      }
      log("Fetch Query2: ${query.parameters}");

      final querySnapshot = await query.get();

      final presentations = querySnapshot.docs
          .map((docSnapshot) => MyPresentation.fromMapDatabase(
              docSnapshot.data()! as Map<String, dynamic>))
          .toList();

      log("Fetched Presentations: ${presentations.toList()}");

      return {
        'presentations': presentations,
        'lastDoc':
            querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null,
      };
    } on Exception catch (e) {
      log("Fetched Presentations Error: ${e}");

      // TODO
      return {
        'presentations': <MyPresentation>[],
        'lastDoc': null,
      };
    }
  }

  // Method added by Rizwan
  Future<List<MyPresentation>> fetchPresentationHistoryByCreaterIdFirestore(
      String createrId) async {
    final querySnapshot = await _firestore
        .collection(presentationCollectionPath)
        .where("createrId", isEqualTo: createrId)
        .get();
    print(
        "these are presenatations by creater id ${querySnapshot.docs.map((docSnapshot) => MyPresentation.fromMapDatabase(docSnapshot.data()!)).toList()}");
    return querySnapshot.docs
        .map((docSnapshot) =>
            MyPresentation.fromMapDatabase(docSnapshot.data()!))
        .toList();
  }

  // Method below added by rizwan
  Future<void> updatePresentationHistory(
      MyPresentation presentationHistory, String presentationId) async {
    final docRef =
        _firestore.collection(presentationCollectionPath).doc(presentationId);
    await docRef.set(
        presentationHistory.toMapDatabase(), SetOptions(merge: false));
  }
  // Method below added by rizwan

  Future<void> updateSlidePallet(
      SlidePallet slidePallet, String slidePalletId) async {
    final docRef =
        _firestore.collection(slidePalletCollectionPath).doc(slidePalletId);
    await docRef.set(slidePallet.toMap(), SetOptions(merge: false));
  }

  // Method added by rizwan
  Future<void> updateCommentsCount(String presentationId, int change) async {
    final docRef =
        _firestore.collection(presentationCollectionPath).doc(presentationId);
    // Update the comments count
    await docRef.update({'commentsCount': FieldValue.increment(change)});
  }

  // Method added by rizwan
  Future<void> addComment(String presentationId, Comment userData) async {
    final docRef = _firestore
        .collection(presentationCollectionPath)
        .doc(presentationId)
        .collection(subcollectionComments)
        .doc(userData.userId.toString());
    // Add the comment
    await docRef.set(userData.toMapDatabase());

    //Update the comments count
    await updateCommentsCount(presentationId, 1);
  }

  // Method added by rizwan
  Future<void> updateLikesCount(String presentationId, int change) async {
    final docRef =
        _firestore.collection(presentationCollectionPath).doc(presentationId);
    // Update the likes count
    await docRef.update({'likesCount': FieldValue.increment(change)});
  }

  Future<void> decreaseLikesCount(String presentationId, int change) async {
    final docRef =
        _firestore.collection(presentationCollectionPath).doc(presentationId);
    // Update the likes count
    await docRef.update({'likesCount': FieldValue.increment(change)});
  }

  // Method added by rizwan
  Future<void> addLike(String presentationId, Like userData) async {
    final docRef = _firestore
        .collection(presentationCollectionPath)
        .doc(presentationId)
        .collection(subcollectionLikes)
        .doc(userData.userId.toString());
    // .doc("5");
    DocumentSnapshot doc = await docRef.get();
    print("${doc.exists} user id ${userData.userId}");
    // Add the comment
    if (doc.exists) {
    } else {
      await docRef.set(userData.toMapDatabase());
      // Update the likes count
      await updateLikesCount(presentationId, 1);
    }
  }

  Future<void> removeLike(String presentationId, Like userData) async {
    final docRef = _firestore
        .collection(presentationCollectionPath)
        .doc(presentationId)
        .collection(subcollectionLikes)
        .doc(userData.userId.toString());

    // Check if the user has liked the presentation
    DocumentSnapshot doc = await docRef.get();
    print("${doc.exists} user id ${userData.userId}");

    // If the like exists, remove it
    if (doc.exists) {
      await docRef.delete(); // Remove the like from Firestore
      // Update the likes count by decrementing it
      await updateLikesCount(presentationId, -1);
    } else {
      print("Like not found for user: ${userData.userId}");
    }
  }

  Future<bool> isLikedByUser(String userID, String presID) async {
    final docRef = _firestore
        .collection(presentationCollectionPath)
        .doc(presID)
        .collection(subcollectionLikes)
        .doc(userID);
    // .doc("5");
    DocumentSnapshot doc = await docRef.get();
    // print("${doc.exists} user id ${userData.userId}");
    // Add the comment
    if (doc.exists) {
      // debugPrintStack(
      //     label: "UserID: $userID \nPresID: $presID \nisLiked: true",
      //     stackTrace: StackTrace.fromString(""));
      return true;
    } else {
      // debugPrintStack(
      //     label: "isLikedBy",
      //     stackTrace: StackTrace.fromString(
      //         "UserID: $userID \nPresID: $presID \nisLiked: true"));
      return false;
    }
  }

  // Method added by rizwan
  Future<int> fetchLikesCount(String presentationId) async {
    final querySnapshot = await _firestore
        .collection(presentationCollectionPath)
        .doc(presentationId)
        .get();
    int likesCount = await querySnapshot.data()?['likesCount'] as int ?? 0;
    return likesCount;
  }

  // Method added by rizwan
  Future<int> fetchCommentsCount(String presentationId) async {
    final querySnapshot = await _firestore
        .collection(presentationCollectionPath)
        .doc(presentationId)
        .get();
    int commentsCount =
        await querySnapshot.data()?['commentsCount'] as int ?? 0;
    return commentsCount;
  }

  // Method added by rizwan
  Future<List<Comment>> fetchComments(String presentationId) async {
    final querySnapshot = await _firestore
        .collection(presentationCollectionPath)
        .doc(presentationId)
        .collection(subcollectionComments)
        .get();
    List<Comment> allComments = querySnapshot.docs
        .map((e) => Comment.fromMapDatabase(e.data()!))
        .toList();
    return allComments;
  }

  // Method added by rizwan
  Future<List<Like>> fetchLikes(String presentationId) async {
    final querySnapshot = await _firestore
        .collection(presentationCollectionPath)
        .doc(presentationId)
        .collection(subcollectionLikes)
        .get();
    List<Like> allLikes =
        querySnapshot.docs.map((e) => Like.fromMapDatabase(e.data()!)).toList();
    return allLikes;
  }

  Future<UserData?> getUserByID(String userID) async {
    final docRef = FirebaseFirestore.instance
        .collection(FirestoreService().userCollectionPath)
        .doc(userID);

    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // User exists, handle existing user data
      final userMap = docSnapshot.data() as Map<String, dynamic>;
      UserData userData = UserData.fromMap(userMap);
      // Perform actions with existing user data (e.g., print name)
      // print('User found: ${userData.email}');
      return userData;
    } else {
      // User doesn't exist, create a new user
      return null;
    }
  }

  // Function to update user profile in Firestore
  Future<bool> updateUserProfile(String uid, UserData userData) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection(userCollectionPath).doc(uid);
      await docRef.update(
          userData.toMap()); // Assuming you have a toJson() in UserData model
      return true;
    } catch (e) {
      // Handle Firestore update error
      print("Error updating user profile: $e");
      return false;
    }
  }
}
