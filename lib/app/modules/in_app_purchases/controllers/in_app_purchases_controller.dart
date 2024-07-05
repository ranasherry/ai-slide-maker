import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';

class InAppPurchasesController extends GetxController {
  //TODO: Implement InAppPurchasesController

  final count = 0.obs;

  // RxDouble discountPercentage

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

  Future<void> recordInAppImpression() async {
    final today = DateTime.now();
    final dateString =
        '${today.year}-${today.month}-${today.day}'; // YYYY-MM-DD format

    final firestore = FirebaseFirestore.instance;
    final impressionRef =
        firestore.collection('inAppPurchaseImpressions').doc(dateString);

    try {
      // Attempt to retrieve the document for the current date
      final docSnapshot = await impressionRef.get();

      if (docSnapshot.exists) {
        // Document exists, update the count
        final currentCount = docSnapshot.data()!['count'] as int;
        await impressionRef.update({'count': currentCount + 1});
      } else {
        // Document doesn't exist, create it with count 1
        await impressionRef.set({'count': 1});
      }
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions appropriately
      print('Error recording in-app impression: ${e.message}');
    } catch (e) {
      // Handle other exceptions more generally
      print('Unexpected error: $e');
    }
  }

  void proceedToRemoveAd(StoreProduct removeAdProduct) {
    RevenueCatService().purchaseSubscriptionWithProduct(removeAdProduct);
  }

  double getOriginalPrice(
      {required double discountPercentage, required double discountedPrice}) {
    // Convert discount percentage to a decimal value (e.g., 10% -> 0.1)
    final decimalDiscount = discountPercentage / 100.0;

    // Calculate the original price using the formula: originalPrice = discountedPrice / (1 - discount)
    final originalPrice = discountedPrice / (1 - decimalDiscount);

    return originalPrice;
  }
}
