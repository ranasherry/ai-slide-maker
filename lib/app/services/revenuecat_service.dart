import 'dart:developer' as dp;
// import 'package:ai_chatbot/app/modules/routes/app_pages.dart';
// import 'package:flutter_gif/flutter_gif.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';

// import '../modules/home/controllers/nav_view_ctl.dart';
// import '../modules/utills/Gems_rates.dart';

// class RevenueCatIDs {
//   // static const idGems10 = '10_gems';
//   static const removeAdID = 'aislide_adremove_1';

//   static const allids = [
//     // idGems10,
//     removeAdID
//   ];
// }

class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();

  factory RevenueCatService() {
    // Purchases.setEmail(email)
    return _instance;
  }
  String UserID = "";

  RevenueCatService._internal();

  Rx<Entitlement> currentEntitlement = Entitlement.free.obs;

  final List<String> _productIds = [
    // Add your product identifiers here
    'aislide_adremove_1',
    // 'lifetime_premium',
  ];

  final entitlementID = "remove_ads";
  static const _apiKey = 'goog_hAsleyJthCfUtAQlmqdSbKVtLOv';

  Future<String> initialize(String? userID) async {
    // String customerID="ranasherry94@gmail.com";
    await Purchases.setLogLevel(LogLevel.debug);
    if (userID != null) {
      await Purchases.configure(PurchasesConfiguration(
        _apiKey,
      )..appUserID = userID);
    } else {
      await Purchases.configure(PurchasesConfiguration(
        _apiKey,
      ));
    }

    //     .then((value) async {
    //   getRemoveAdProduct();
    //   await checkSubscriptionStatus();
    //   FirestoreService().UserID = await Purchases.appUserID;
    //   if (currentEntitlement.value == Entitlement.paid) {
    //     try {
    //       CreateFirebaseUser();
    //     } catch (e) {
    //       dp.log("Firebase Error: $e");
    //     }
    //   }
    // });

    // getRemoveAdProduct();
    await checkSubscriptionStatus();
    FirestoreService().UserID = await Purchases.appUserID;
    UserID = await Purchases.appUserID;
    if (currentEntitlement.value == Entitlement.paid) {
      try {
        CreateFirebaseUser();
      } catch (e) {
        dp.log("Firebase Error: $e");
      }
    }

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      updatePurchaseStatus();
    });

    return UserID;
  }

  Future<StoreProduct?> getRemoveAdProduct() async {
    final offerings = await Purchases.getOfferings();
    final packages = offerings.getOffering("remove_ads")?.availablePackages;
    if (packages != null) {
      StoreProduct storeProduct = packages.first.storeProduct;
      print("StoreProduct : ${storeProduct}");

      return storeProduct;
    }

    return null;
  }

  Future<List<StoreProduct>> getAllSubscriptionProducts() async {
    // Get offerings
    final offerings = await Purchases.getOfferings();

    // Check if "premium_subscription" offering exists
    final premiumOffering = offerings.getOffering("premium_subscription");
    if (premiumOffering == null) {
      return []; // Return empty list if offering is not found
    }

    // Get available packages for the offering
    final packages = premiumOffering.availablePackages;

    // Extract products from each package and combine into a single list
    final List<StoreProduct> allProducts = [];
    for (var package in packages) {
      allProducts.add(package.storeProduct);
    }

    return allProducts;
  }

  void printWrapped(String text) =>
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

  Future<void> purchaseSubscription(Package package) async {
    try {
      final purchaserInfo =
          await Purchases.purchasePackage(package).then((value) {});

      dp.log("Purchased ${purchaserInfo}");
      // Handle successful purchase
    } catch (error) {
      print("Purchase Error");
      // Handle purchase error
    }
  }

  Future<void> purchaseSubscriptionWithProduct(StoreProduct product) async {
    try {
      // final purchaserInfo = await Purchases.purchaseStoreProduct(product);

      //? New Method
      // final purchaserInfo = await Purchases.getCustomerInfo();
      final purchaserInfo = await Purchases.purchaseStoreProduct(product);

      final entitelments = purchaserInfo.entitlements.active.values.toList();

      // entitlementInfos.active;
      dp.log("Active Entitlements: ${entitelments.first.identifier}");

      if (entitelments.first.identifier == entitlementID) {
        //? Unlock Premium Features
        RemoveAdsForUser();
        CreateFirebaseUser();
        if (kReleaseMode) {
          FirebaseAnalytics.instance.logPurchase(
              currency: product.currencyCode,
              value: product.price,
              items: [
                AnalyticsEventItem(
                    itemId: product.identifier, price: product.price)
              ]);
        }

        // TODO: Check if user is logged in or not. if logged in, update Revenue Cat User ID else Goto Signin Page

        bool isLoggedIn = FirebaseAuth.instance.currentUser != null
            ? true
            : false; // check user logged in or not
        if (isLoggedIn) {
          updateRevenueCatUserID(UserID);
        } else {
          Get.toNamed(Routes.SING_IN);
        }
      }

      print("PurchaseInfo: ${purchaserInfo.allPurchasedProductIdentifiers}");
      // if (purchaserInfo.allPurchasedProductIdentifiers
      //     .contains("aislide_adremove_1")) {
      //   RemoveAdsForUser();
      //   CreateFirebaseUser();
      //   if (kReleaseMode) {
      //     FirebaseAnalytics.instance.logPurchase(
      //         currency: product.currencyCode,
      //         value: product.price,
      //         items: [
      //           AnalyticsEventItem(
      //               itemId: product.identifier, price: product.price)
      //         ]);
      //   }
      // }
      // Handle successful purchase
    } catch (error) {
      // Handle purchase error
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      final entitelments = purchaserInfo.entitlements.active.values.toList();

      // entitlementInfos.active;
      dp.log("Active Entitlements: ${entitelments.first.identifier}");

      if (entitelments.first.identifier == entitlementID) {
        //? Unlock Premium Features
        RemoveAdsForUser();
      }

      print(
          "CheckSubscription: ${purchaserInfo.allPurchasedProductIdentifiers}");
      // if (purchaserInfo.allPurchasedProductIdentifiers
      //     .contains("aislide_adremove_1")) {}
    } catch (error) {
      // Error occurred while fetching the subscription status
      print('Error: $error');
    }
  }

  Future updatePurchaseStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      print("Purchase info: $purchaserInfo");
      // if (purchaserInfo.entitlements.active.isNotEmpty) {
      //   currentEntitlement.value = Entitlement.paid;
      //   // User is subscribed
      //   print('User is subscribed');
      // } else {
      //   currentEntitlement.value = Entitlement.free;

      //   // User is not subscribed
      //   print('User is not subscribed');
      // }
    } catch (error) {
      // Error occurred while fetching the subscription status
      print('Error: $error');
    }
  }

  void GoToPurchaseScreen() {
    if (currentEntitlement.value == Entitlement.paid) return;
    Get.toNamed(
      Routes.IN_APP_PURCHASES,
    );
  }

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  RemoveAdsForUser() async {
    final prefs = await getSharedPrefs();
    await prefs.setBool('isAdRemoved', true);

    RevenueCatService().currentEntitlement.value = Entitlement.paid;
    dp.log("RemoveAdsForUser Called");
    CheckRemoveAdsForUser();

    // Get.back();
    // Get.offAllNamed(Routes.HomeView);
  }

  Future<bool> CheckRemoveAdsForUser() async {
    final prefs = await getSharedPrefs();
    final isAdRemoved = prefs.getBool('isAdRemoved') ?? false;

    if (isAdRemoved) {
      RevenueCatService().currentEntitlement.value = Entitlement.paid;
    } else {
      RevenueCatService().currentEntitlement.value = Entitlement.free;
    }
    dp.log("IsAdRemoved: $isAdRemoved");
    dp.log(
        "CurrentEntitlement: ${RevenueCatService().currentEntitlement.value}");

    return isAdRemoved;
  }

  void CreateFirebaseUser() {
    FirestoreService().createUser(uid: FirestoreService().UserID);
  }

  Future<void> updateRevenueCatUserID(String userID) async {
    dp.log("Updating RevenueCatUserID: $userID");
    User user = FirebaseAuth.instance.currentUser!;
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      // User exists, handle existing user data
      final userMap = docSnapshot.data() as Map<String, dynamic>;
      UserData userData = UserData.fromMap(userMap);
      // Perform actions with existing user data (e.g., print name)

      userData.revenueCatUserId = userID;

      docRef.update(userData.toMap());
      print('User found: ${userData.email}');
    }
  }
}

enum Entitlement { free, paid }
