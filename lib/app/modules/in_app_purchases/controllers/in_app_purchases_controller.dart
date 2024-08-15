import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';

class InAppPurchasesController extends GetxController {
  //TODO: Implement InAppPurchasesController

  final count = 0.obs;
  RxString timeLeft = "".obs;
  Rx<int> selectedIndex = 0.obs;

  RxBool showTimer = false.obs;

  // RxDouble discountPercentage

  @override
  void onInit() {
    super.onInit();

    initDiscountTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

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

  String timeUntil(int millisecondsSinceEpoch) {
    // Get current time in milliseconds
    final now = DateTime.now().millisecondsSinceEpoch;

    // Calculate difference in milliseconds
    final difference = millisecondsSinceEpoch - now;

    // Check if target date has already passed
    if (difference <= 0) {
      return "Time has passed";
    }

    // Calculate remaining days, hours, minutes, and seconds
    final days = (difference / Duration.millisecondsPerDay).floor();
    final hours = ((difference % Duration.millisecondsPerDay) /
            Duration.millisecondsPerHour)
        .floor();
    final minutes = ((difference % Duration.millisecondsPerHour) /
            Duration.millisecondsPerMinute)
        .floor();
    final seconds = ((difference % Duration.millisecondsPerMinute) /
            Duration.millisecondsPerSecond)
        .floor();

    // Calculate total hours
    final totalHours = (days * 24) + hours;

    // Build the string representation
    final String hourString = totalHours > 0 ? "${totalHours}h" : "";
    final String minuteString =
        minutes > 0 ? " : ${minutes.toString().padLeft(2, '0')}m" : "";
    final String secondString =
        seconds > 0 ? " : ${seconds.toString().padLeft(2, '0')}s" : "";

    return "$hourString$minuteString$secondString".trim();
  }

  // String timeUntil(int millisecondsSinceEpoch) {
  //   // Get current time in milliseconds
  //   final now = DateTime.now().millisecondsSinceEpoch;
  //   final temp = DateTime.now().add(Duration(days: 4)).millisecondsSinceEpoch;

  //   log("Time: $temp");
  //   // Calculate difference in milliseconds
  //   final difference = millisecondsSinceEpoch - now;

  //   // Check if target date has already passed
  //   if (difference <= 0) {
  //     return "Time has passed";
  //   }

  //   // Calculate remaining days, hours, minutes, and seconds
  //   final days = (difference / Duration.millisecondsPerDay).floor();
  //   final hours = ((difference % Duration.millisecondsPerDay) /
  //           Duration.millisecondsPerHour)
  //       .floor();
  //   final minutes = ((difference % Duration.millisecondsPerHour) /
  //           Duration.millisecondsPerMinute)
  //       .floor();
  //   final seconds = ((difference % Duration.millisecondsPerMinute) /
  //           Duration.millisecondsPerSecond)
  //       .floor();

  //   // Build the string representation
  //   final String dayString = days > 0 ? "$days day${days > 1 ? 's' : ''} " : "";
  //   final String hourString =
  //       hours > 0 ? "${hours.toString().padLeft(2, '0')}h " : "";
  //   final String minuteString =
  //       minutes > 0 ? "${minutes.toString().padLeft(2, '0')}m " : "";
  //   final String secondString =
  //       seconds > 0 ? "${seconds.toString().padLeft(2, '0')}s" : "";

  //   return "$dayString$hourString$minuteString$secondString".trim();
  // }

  void initDiscountTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft.value = timeUntil(RCVariables.discountTimeLeft);
      // log("TimeLeft: ${timeLeft.value}");
    });
  }

  String removeParentheses(String input) {
    // Regular expression to match parentheses and everything inside them
    final RegExp regExp = RegExp(r'\(.*?\)');

    // Replace all matches with an empty string
    return input.replaceAll(regExp, '');
  }

  String getProductTitle(StoreProduct product) {
    if (product.identifier == "aislide_adremove_1") {
      return "Pay Once";
    } else if (product.identifier ==
        "aislide_premium_1w:aislide-baseplan-weekly") {
      return "Weekly";
    } else if (product.identifier ==
        "aislide_premium_1m:aislide-baseplan-monthly") {
      return "Monthly";
    } else if (product.identifier ==
        "aislide_premium_1y:aislide-baseplan-yearly") {
      return "Annually";
    } else {
      log("Product ID: ${product.identifier}");
      return product.title;
    }
  }

  String getProductPeriod(StoreProduct product) {
    if (product.identifier == "aislide_adremove_1") {
      return "Life Time";
    } else if (product.identifier ==
        "aislide_premium_1w:aislide-baseplan-weekly") {
      return "Week";
    } else if (product.identifier ==
        "aislide_premium_1m:aislide-baseplan-monthly") {
      return "Month";
    } else if (product.identifier ==
        "aislide_premium_1y:aislide-baseplan-yearly") {
      return "Month";
    } else {
      log("Product ID: ${product.identifier}");
      return product.description;
    }
  }

  bool getIsHot(StoreProduct product) {
    if (product.identifier == "aislide_adremove_1") {
      return true;
    } else {
      return false;
    }
  }
}
