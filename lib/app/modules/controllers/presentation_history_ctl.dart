// //file added by rizwan 

// import 'package:get/get.dart';
// import 'package:slide_maker/app/data/my_presentation.dart';
// import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
// import 'package:slide_maker/app/services/firebaseFunctions.dart';

// class PresentationHistoryCTL extends GetxController{

//   var presentations = <MyPresentation>[].obs;
//   FirestoreService firestoreService = FirestoreService();

//   @override
//   void onInit(){
//     super.onInit();
//     fetchPresentationHistory();
//     firestoreService.fetchPresentationHistoryFirestore();
    
//   }

//   @override
//   void onClose(){
//     super.onClose();
//   }

//   Future<void> fetchPresentationHistory() async{
//     presentations.value = await PresentationHistoryDatabaseHandler.db.fetchAllPresentationHistory();
//   }

//   Future<void> insertPresentation(MyPresentation myPresentation)async{
//     String presentationId = myPresentation.presentationId.toString();
//    await PresentationHistoryDatabaseHandler.db.insertPresentationHistory(myPresentation);
//    await firestoreService.insertPresentationHistory(myPresentation, presentationId);
//    fetchPresentationHistory();
//   }
// }