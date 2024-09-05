import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/comment.dart';
import 'package:slide_maker/app/data/like.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
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
  final String userCollectionPath =
      kDebugMode ? 'testUser' : 'users'; // Customizable collection path

  final String _collectionPath = 'premiumUsers'; // Customizable collection path
  final String _historySubcollectionPath =
      'history'; // Customizable subcollection path

  String UserID = "temp";
  //added by rizwan
  String presentationCollectionPath = "presentationTest";
  String subcollectionLikes = 'likesTest';
  String subcollectionComments = 'commentsTest';

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
  Future<void> insertPresentationHistory(MyPresentation presentationHistory, String presentationId) async{
    final docRef = _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId);
   await docRef.set(presentationHistory.toMapDatabase());
  }

  // Method added by rizwan
  Future <List<MyPresentation>> fetchPresentationHistoryFirestore() async{
    final querySnapshot = await _firestore
    .collection(presentationCollectionPath)
    .get();
    print("these are presenatations ${querySnapshot.docs
    .map((docSnapshot) =>MyPresentation.fromMapDatabase(docSnapshot.data()!))
    .toList()}");
    return querySnapshot.docs
    .map((docSnapshot) =>MyPresentation.fromMapDatabase(docSnapshot.data()!))
    .toList();
  }

  // Method added by Rizwan
  Future <List<MyPresentation>> fetchPresentationHistoryByCreaterIdFirestore(String createrId) async{
    final querySnapshot = await _firestore
    .collection(presentationCollectionPath)
    .where("createrId", isEqualTo: createrId)
    .get();
    print("these are presenatations by creater id ${querySnapshot.docs
    .map((docSnapshot) =>MyPresentation.fromMapDatabase(docSnapshot.data()!))
    .toList()}");
    return querySnapshot.docs
    .map((docSnapshot) =>MyPresentation.fromMapDatabase(docSnapshot.data()!))
    .toList();
  }
  // Method below added by rizwan
  Future<void> updatePresentationHistory(MyPresentation presentationHistory, String presentationId) async{
    final docRef = _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId);
   await docRef.set(presentationHistory.toMapDatabase(), SetOptions(merge: false));
  }
  // Method added by rizwan
  Future<void> updateCommentsCount(String presentationId, int change) async{
    final docRef = _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId);
    // Update the comments count
    await docRef.update({
      'commentsCount': FieldValue.increment(change)
    });
  }
  // Method added by rizwan
  Future<void> addComment(String presentationId, Comment userData) async{
    final docRef = _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId)
    .collection(subcollectionComments)
    .doc(userData.userId.toString());
    // Add the comment
    await docRef.set(userData.toMapDatabase());

    //Update the comments count
    await updateCommentsCount(presentationId,1);
  }
  // Method added by rizwan
  Future<void> updateLikesCount(String presentationId, int change) async{
    final docRef = _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId);
    // Update the likes count
    await docRef.update({
      'likesCount': FieldValue.increment(change)
    });
  }
  // Method added by rizwan
  Future<void> addLike(String presentationId, Like userData) async{
    final docRef = _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId)
    .collection(subcollectionLikes)
    .doc(userData.userId.toString());
    // .doc("5");
    DocumentSnapshot doc = await docRef.get();
    print("${doc.exists} user id ${userData.userId}");
    // Add the comment
    if(doc.exists){

    }
    else{
    await docRef.set(userData.toMapDatabase());
    // Update the likes count
    await updateLikesCount(presentationId,1);
    }
   
  }

  // Method added by rizwan
  Future <int> fetchLikesCount (String presentationId) async{
    final querySnapshot = await _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId)
    .get();
    int likesCount = await querySnapshot.data()?['likesCount'] as int ?? 0 ;
    return likesCount;
  }

  // Method added by rizwan
  Future <int> fetchCommentsCount (String presentationId) async{
    final querySnapshot = await _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId)
    .get();
    int commentsCount = await querySnapshot.data()?['commentsCount']  as int ?? 0;
    return commentsCount ; 
  }

  // Method added by rizwan
  Future <List<Comment>> fetchComments(String presentationId) async{
    final querySnapshot = await _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId)
    .collection(subcollectionComments)
    .get();
    List<Comment> allComments = querySnapshot.docs
    .map((e)=> Comment.fromMapDatabase(e.data()!)).toList();
    return allComments;
    
  }

  // Method added by rizwan
  Future <List<Like>> fetchLikes(String presentationId) async{
    final querySnapshot = await _firestore
    .collection(presentationCollectionPath)
    .doc(presentationId)
    .collection(subcollectionLikes)
    .get();
    List<Like> allLikes = querySnapshot.docs
    .map((e)=> Like.fromMapDatabase(e.data()!)).toList();
    return allLikes;
    
  }
}
