import 'dart:developer' as dp;
// import 'package:ai_chatbot/app/modules/routes/app_pages.dart';
// import 'package:flutter_gif/flutter_gif.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';

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

    // if (kDebugMode) {
    //   userID = "\$RCAnonymousID:22a7f8f7cd4f4080beb2e366ff3daaec";
    // }

    dp.log("Inititalizing Revenue cart: $userID");
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

  Future<List<StoreProduct>> getFilteredSubscriptionProducts() async {
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
      if (package.storeProduct.identifier !=
          'aislide_premium_1y:aislide-baseplan-yearly') {
        allProducts.add(package.storeProduct);
      } else {
        dp.log("removed: ${package.storeProduct.identifier}");
      }
    }

    return allProducts;
  }

  Future<StoreProduct?> getLifeTimeSubscription() async {
    // Get offerings
    final offerings = await Purchases.getOfferings();

    // Check if "premium_subscription" offering exists
    final premiumOffering = offerings.getOffering("premium_subscription");
    if (premiumOffering == null) {
      return null; // Return empty list if offering is not found
    }

    // Get available packages for the offering
    final packages = premiumOffering.availablePackages;

    // Extract products from each package and combine into a single list
    final List<StoreProduct> allProducts = [];
    for (var package in packages) {
      if (package.storeProduct.identifier == 'aislide_adremove_1') {
        return package.storeProduct;
      }
      allProducts.add(package.storeProduct);
    }

    return null;
  }

  void printWrapped(String text) =>
      RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

  Future<void> purchaseSubscription(Package package) async {
    // Purchases.purchaseProduct()
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
      EasyLoading.show(status: "Please wait...");
      // final purchaserInfo = await Purchases.purchaseStoreProduct(product);

      //? New Method
      // final purchaserInfo = await Purchases.getCustomerInfo();
      final purchaserInfo = await Purchases.purchaseStoreProduct(product);

      final entitelments = purchaserInfo.entitlements.active.values.toList();

      // entitlementInfos.active;
      dp.log("Active Entitlements: ${entitelments.first.identifier}");

      if (entitelments.first.identifier == entitlementID) {
        //? Unlock Premium Features
        await RemoveAdsForUser(true);
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
          await updateRevenueCatUserID(UserID);
          EasyLoading.showSuccess("Congratulation your are a Premium User now");
          Get.offAllNamed(Routes.HomeView);
        } else {
          // Get.toNamed(Routes.SING_IN);
          showSignInDialog();
        }
        EasyLoading.dismiss();
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
      EasyLoading.dismiss();
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
        await RemoveAdsForUser(true);
      } else {
        await RemoveAdsForUser(false);
      }

      print(
          "CheckSubscription: ${purchaserInfo.allPurchasedProductIdentifiers}");
      // if (purchaserInfo.allPurchasedProductIdentifiers
      //     .contains("aislide_adremove_1")) {}
    } catch (error) {
      await RemoveAdsForUser(false);

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

  int purchaseScreenCounter = 0;

  bool isPurchaseScreenOpen = false;

  void GoToPurchaseScreen() {
    if (currentEntitlement.value == Entitlement.paid) return;
    if (isPurchaseScreenOpen) {
      dp.log("Screen is Already Opened");
      return;
    }

    isPurchaseScreenOpen = true;
    if (RCVariables.showBothInApp.value) {
      if (purchaseScreenCounter % 2 == 0) {
        Get.toNamed(
          Routes.NEWINAPPPURCHASEVIEW,
        )!
            .then((value) {
          isPurchaseScreenOpen = false;
          dp.log("back from Purchase Screen");
        });
      } else {
        Get.toNamed(
          Routes.IN_APP_PURCHASES,
        )!
            .then((value) {
          isPurchaseScreenOpen = false;
          dp.log("back from Purchase Screen");
        });
      }
    } else {
      if (RCVariables.showNewInapp.value) {
        Get.toNamed(
          Routes.NEWINAPPPURCHASEVIEW,
        )!
            .then((value) {
          isPurchaseScreenOpen = false;
          dp.log("back from Purchase Screen");
        });
      } else {
        Get.toNamed(
          Routes.IN_APP_PURCHASES,
        )!
            .then((value) {
          isPurchaseScreenOpen = false;
          dp.log("back from Purchase Screen");
        });
      }
    }

    purchaseScreenCounter++;

    // Get.toNamed(
    //   Routes.IN_APP_PURCHASES,
    // );
  }

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> RemoveAdsForUser(bool isAdRemoved) async {
    final prefs = await getSharedPrefs();
    await prefs.setBool('isAdRemoved', isAdRemoved);

    if (isAdRemoved) {
      RevenueCatService().currentEntitlement.value = Entitlement.paid;
    } else {
      RevenueCatService().currentEntitlement.value = Entitlement.free;
    }
    dp.log("RemoveAdsForUser Called");
    await CheckRemoveAdsForUser();

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
    final docRef = FirebaseFirestore.instance
        .collection(FirestoreService().userCollectionPath)
        .doc(user.uid);
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

  void showSignInDialog() {
    Get.defaultDialog(
      title: "Subscription Successful",
      content: Column(
        children: [
          Text("You have successfully bought the subscription."),
          SizedBox(height: 10),
          Text(
              "Please sign in so that you can use the subscription on other devices as well."),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          // Navigate to the sign-in screen
          Get.toNamed(Routes.SING_IN);
        },
        child: Text("Sign In"),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          // Get.back();
          Get.offAllNamed(Routes.HOMEVIEW1);
        },
        child: Text("Later"),
      ),
    );
  }

  Future<void> signOut() async {
    // await Purchases.logOut();
    await initialize(null);
  }
}

enum Entitlement { free, paid }
