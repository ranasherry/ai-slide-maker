import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:url_launcher/url_launcher.dart';

class newInAppPurchaseCTL extends GetxController {
  RxString timeLeft = "".obs;

  RxBool showTimer = true.obs;
  Rx<int> selectedIndex = 0.obs;

  Rx<StoreProduct?> selectedProduct = Rx<StoreProduct?>(null);

  ScrollController scrollController = ScrollController();

  RxBool showScroll = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    initDiscountTimer();

    scrollController.addListener(() {
      debugPrint("Scroll Position: ${scrollController.position}");
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        showScroll.value = false;
        debugPrint("reach the bottom ${showScroll.value}");
      } else {
        showScroll.value = true;
      }
      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        debugPrint("reach the top");
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future openURL(ur) async {
    final Uri _url = Uri.parse(ur);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

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
    } else if (product.identifier ==
        "aislide_premium_3m:aislide-baseplan-trimonthly") {
      return "every 3 Months";
    } else if (product.identifier ==
        "aislide_premium_6m:aislid-baseplan-bimonthly") {
      return "every 6 Months";
    } else {
      log("Product ID: ${product.identifier}");
      return product.title;
    }
  }

  String getProductPeriod(StoreProduct product) {
    log("Product ID: ${product.identifier}");

    if (product.identifier == "aislide_adremove_1") {
      log("Matched: Life Time");
      return "Life Time";
    } else if (product.identifier ==
        "aislide_premium_1w:aislide-baseplan-weekly") {
      log("Matched: Week");
      return "Week";
    } else if (product.identifier ==
        "aislide_premium_1m:aislide-baseplan-monthly") {
      log("Matched: Month");
      return "Month";
    } else if (product.identifier ==
        "aislide_premium_1y:aislide-baseplan-yearly") {
      log("Matched: Year");
      return "Year";
    } else if (product.identifier ==
        "aislide_premium_3m:aislide-baseplan-trimonthly") {
      log("Matched: Year");
      return "3 Months";
    } else if (product.identifier ==
        "aislide_premium_6m:aislid-baseplan-bimonthly") {
      log("Matched: Year");
      return "6 Months";
    } else {
      log("Unknown Product ID: ${product.identifier}");
      return product.description;
    }
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

  String getProductTitleBeta(StoreProduct product) {
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
    } else if (product.identifier ==
        "aislide_premium_3m:aislide-baseplan-trimonthly") {
      return "3 Months";
    } else if (product.identifier ==
        "aislide_premium_6m:aislid-baseplan-bimonthly") {
      return "6 Months";
    } else {
      log("Product ID: ${product.identifier}");
      return product.title;
    }
  }

  String getProductPeriodBeta(StoreProduct product) {
    if (product.identifier == "aislide_adremove_1") {
      return "Pay Once";
    } else if (product.identifier ==
        "aislide_premium_1w:aislide-baseplan-weekly") {
      return "Billed Weekly";
    } else if (product.identifier ==
        "aislide_premium_1m:aislide-baseplan-monthly") {
      return "Billed Monthly";
    } else if (product.identifier ==
        "aislide_premium_1y:aislide-baseplan-yearly") {
      return "Billed Annually";
    } else if (product.identifier ==
        "aislide_premium_3m:aislide-baseplan-trimonthly") {
      return "Billed every 3 months";
    } else if (product.identifier ==
        "aislide_premium_6m:aislid-baseplan-bimonthly") {
      return "Billed every 6 months";
    } else {
      log("Product ID: ${product.identifier}");
      return product.title;
    }
  }
}
