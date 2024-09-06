import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;

// import 'package:applovin_max/applovin_max.dart';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/utills/app_strings.dart';

// import '../modules/utills/AppStrings.dart';
import '../services/revenuecat_service.dart';

class AppLovinProvider {
  AppLovinProvider._privateConstructor();

  static final AppLovinProvider instance =
      AppLovinProvider._privateConstructor();

  final String _sdk_key = AppStrings.MAX_SDK;

  String _interstitial_ad_unit_id = AppStrings.MAX_INTER_ID;
  // final String _rewarded_ad_unit_id = "ANDROID_REWARDED_AD_UNIT_ID";
  String _banner_ad_unit_id = AppStrings.MAX_BANNER_ID;
  // final String _mrec_ad_unit_id = AppStrings.MAX_MREC_ID;

  // Create states
  RxBool isInitialized = false.obs;
  RxBool showMacBanner = false.obs;
  var interstitialLoadState = AdLoadState.notLoaded;
  var interstitialRetryAttempt = 0;
  var rewardedAdLoadState = AdLoadState.notLoaded;
  var rewardedAdRetryAttempt = 0;
  var isProgrammaticBannerCreated = false;
  var isProgrammaticBannerShowing = false;
  var isWidgetBannerShowing = false;
  var isProgrammaticMRecCreated = false;
  var isProgrammaticMRecShowing = false;
  var isWidgetMRecShowing = false;
  int interCounter = 2;

  // bool isAdsEnable = true;

  Future<void> init() async {
    _interstitial_ad_unit_id = Platform.isAndroid
        ? AppStrings.MAX_INTER_ID
        : AppStrings.IOS_MAX_INTER_ID;

    // isAdsEnable = kReleaseMode;
    // if(kReleaseMode){

    // initializePlugin();

    // }else{
    //   print("Debug Mode");
    // }
    // if (kReleaseMode) {

    final isAdRemoved = await RevenueCatService().CheckRemoveAdsForUser();

    // if (kDebugMode) {
    //   AppLovinMAX.setConsentFlowDebugUserGeography(
    //       ConsentFlowUserGeography.gdpr);
    //   AppLovinMAX.showMediationDebugger();
    //   print("Show Mediation Debugger called...");
    //   await initializePlugin();
    //   showAppLovinConsentFlow();
    // }

    if (!isAdRemoved && kReleaseMode) {
      await initializePlugin();
      showAppLovinConsentFlow();
    }
  }

  Future<void> initializePlugin() async {
    print("Initializing SDK...");

    MaxConfiguration? configuration = await AppLovinMAX.initialize(_sdk_key);
    if (configuration != null) {
      isInitialized.value = true;

      print("SDK Initialized: $configuration");
      // AppLovinMAX.setVerboseLogging(true);

      attachAdListeners();
      AppLovinMAX.loadInterstitial(Platform.isAndroid
          ? _interstitial_ad_unit_id
          : AppStrings.IOS_MAX_INTER_ID);
      AppLovinMAX.loadRewardedAd(Platform.isAndroid
          ? AppStrings.MAX_Reward_ID
          : AppStrings.IOS_MAX_Reward_ID);

      AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
      //  AppLovinMAX.createMRec(AppStrings.MAX_MREC_ID, AdViewPosition.centered);
      // AppLovinMAX.createBanner(
      //     AppStrings.MAX_BANNER_ID, AdViewPosition.bottomCenter);
      if (kDebugMode) AppLovinMAX.showMediationDebugger();
    } else {
      print("SDK null");
    }
  }

  void attachAdListeners() {
    // AppLovinMAX.setRewardedAdListener(
    //     RewardedAdListener(onAdLoadedCallback: (ad) {
    //   rewardedAdLoadState = AdLoadState.loaded;

    //   // Rewarded ad is ready to be shown. AppLovinMAX.isRewardedAdReady(_rewarded_ad_unit_id) will now return 'true'
    //   print('Rewarded ad loaded from ${ad.networkName}');

    //   // Reset retry attempt
    //   rewardedAdRetryAttempt = 0;
    // }, onAdLoadFailedCallback: (adUnitId, error) {
    //   rewardedAdLoadState = AdLoadState.notLoaded;

    //   // Rewarded ad failed to load
    //   // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
    //   rewardedAdRetryAttempt = rewardedAdRetryAttempt + 1;

    //   int retryDelay = pow(2, min(6, rewardedAdRetryAttempt)).toInt();
    //   print(
    //       'Rewarded ad failed to load with code ${error.code} - retrying in ${retryDelay}s');

    //   Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
    //     AppLovinMAX.loadRewardedAd(AppStrings.MAX_Reward_ID);
    //   });
    // }, onAdDisplayedCallback: (ad) {
    //   print('Rewarded ad displayed');
    // }, onAdDisplayFailedCallback: (ad, error) {
    //   rewardedAdLoadState = AdLoadState.notLoaded;
    //   print(
    //       'Rewarded ad failed to display with code ${error.code} and message ${error.message}');
    // }, onAdClickedCallback: (ad) {
    //   print('Rewarded ad clicked');
    // }, onAdHiddenCallback: (ad) {
    //   rewardedAdLoadState = AdLoadState.notLoaded;
    //   print('Rewarded ad hidden');
    // }, onAdReceivedRewardCallback: (ad, reward) {
    //   print('Rewarded ad granted reward');
    // }, onAdRevenuePaidCallback: (ad) {
    //   print('Rewarded ad revenue paid: ${ad.revenue}');
    // }));

    /// Interstitial Ad Listeners
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        interstitialLoadState = AdLoadState.loaded;

        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialAdReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ' + ad.networkName);
        // showInterstitial(() {});
        // Reset retry attempt
        interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        interstitialLoadState = AdLoadState.notLoaded;

        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        interstitialRetryAttempt = interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, interstitialRetryAttempt)).toInt();
        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
      },
      onAdDisplayedCallback: (ad) {
        print('Interstitial ad displayed');
        // AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        //   Future.delayed(Duration(milliseconds: 2 * 1000), () {
        // print('Interstitial ad reloading after display');

        //   AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        // });
      },
      onAdDisplayFailedCallback: (ad, error) {
        interstitialLoadState = AdLoadState.notLoaded;
        print('Interstitial ad failed to display with code ' +
            error.code.toString() +
            ' and message ' +
            error.message);
      },
      onAdClickedCallback: (ad) {
        print('Interstitial ad clicked');
      },
      onAdHiddenCallback: (ad) {
        interstitialLoadState = AdLoadState.notLoaded;
        Future.delayed(Duration(milliseconds: 2 * 1000), () {
          print('Interstitial ad reloading after display');

          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
        print('Interstitial ad hidden');
      },
    ));

    /// Banner Ad Listeners
    AppLovinMAX.setBannerListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      print('Banner ad loaded from ' + ad.networkName);
      AppLovinMAX.showBanner(AppStrings.MAX_BANNER_ID);
    }, onAdLoadFailedCallback: (adUnitId, error) {
      print('Banner ad failed to load with error code ' +
          error.code.toString() +
          ' and message: ' +
          error.message);
    }, onAdClickedCallback: (ad) {
      print('Banner ad clicked');
    }, onAdExpandedCallback: (ad) {
      print('Banner ad expanded');
    }, onAdCollapsedCallback: (ad) {
      print('Banner ad collapsed');
    }));

    /// MREC Ad Listeners
    AppLovinMAX.setMRecListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      print('MREC ad loaded from ' + ad.networkName);
    }, onAdLoadFailedCallback: (adUnitId, error) {
      print('MREC ad failed to load with error code ' +
          error.code.toString() +
          ' and message: ' +
          error.message);
    }, onAdClickedCallback: (ad) {
      print('MREC ad clicked');
    }, onAdExpandedCallback: (ad) {
      print('MREC ad expanded');
    }, onAdCollapsedCallback: (ad) {
      print('MREC ad collapsed');
    }));

    AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
      onAdLoadedCallback: (ad) {},
      onAdLoadFailedCallback: (adUnitId, error) {},
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {
        AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
      },
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {
        AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
      },
      onAdRevenuePaidCallback: (ad) {},
    ));
  }

  Future<void> showAppOpenIfReady() async {
    return;
    if (RevenueCatService().currentEntitlement.value == Entitlement.paid)
      return;
    print("ShowAPPOpen Called..");
    if (!isInitialized.value) {
      return;
    }

    bool isReady =
        (await AppLovinMAX.isAppOpenAdReady(AppStrings.MAX_APPOPEN_ID))!;
    if (isReady) {
      AppLovinMAX.showAppOpenAd(AppStrings.MAX_APPOPEN_ID);
      print("AppOpen is Ready");
    } else {
      AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
      print("AppOpen is Not Ready");
    }
  }

  void showInterstitial(Function onInterAdWatched) async {
    // if(Platform.isIOS && isInitialized.value){
    //   print(object)
    //   return;
    // }
    print("Interstitial ad is show is called");

    // if (kDebugMode) return;
    print(
        "showInterstitial currentEntitlement  ${RevenueCatService().currentEntitlement.value}");

    if (RevenueCatService().currentEntitlement.value == Entitlement.paid) {
      return;
    }
    interCounter++;
    if (interCounter < 4 && Platform.isIOS) {
      return;
    }
    interCounter = 1;
    // if (RevenueCatService().currentEntitlement.value == Entitlement.free) {
    print("Interstitial ad is show is called 2");
    bool? isInterstitialReady =
        await AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id);
    print("return: $isInterstitialReady");
    // if (isInitialized.value && isInterstitialReady!) {

    // print("Interstitial ad ready to show");

    // }

    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        interstitialLoadState = AdLoadState.loaded;

        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialAdReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ' + ad.networkName);

        // Reset retry attempt
        interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        interstitialLoadState = AdLoadState.notLoaded;

        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        interstitialRetryAttempt = interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, interstitialRetryAttempt)).toInt();
        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
      },
      onAdDisplayedCallback: (ad) {
        FirebaseAnalytics.instance
            .logEvent(name: "AppLovin InterStital Displayed");
        print('Interstitial ad displayed');
        // AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        //   Future.delayed(Duration(milliseconds: 2 * 1000), () {
        // print('Interstitial ad reloading after display');

        //   AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        // });
      },
      onAdDisplayFailedCallback: (ad, error) {
        interstitialLoadState = AdLoadState.notLoaded;
        print('Interstitial ad failed to display with code ' +
            error.code.toString() +
            ' and message ' +
            error.message);
      },
      onAdClickedCallback: (ad) {
        print('Interstitial ad clicked');
      },
      onAdHiddenCallback: (ad) {
        interstitialLoadState = AdLoadState.notLoaded;
        AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);

        print('Interstitial ad hidden');
        onInterAdWatched();
      },
    ));

    AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
    // }
  }

  //reward AD

  Future<bool> canShowRewardedAd() async {
    bool isReady = await AppLovinMAX.isRewardedAdReady(Platform.isAndroid
            ? AppStrings.MAX_Reward_ID
            : AppStrings.IOS_MAX_Reward_ID) ??
        false;

    return isReady;
  }

  void showRewardedAd(Function onRewardedAdWatched) async {
    print("show rewared ads");
    // if (RevenueCatService().currentEntitlement.value == Entitlement.free) {
    bool isReady = await AppLovinMAX.isRewardedAdReady(Platform.isAndroid
            ? AppStrings.MAX_Reward_ID
            : AppStrings.IOS_MAX_Reward_ID) ??
        false;
    if (isReady) {
      try {
        AppLovinMAX.showRewardedAd(Platform.isAndroid
            ? AppStrings.MAX_Reward_ID
            : AppStrings.IOS_MAX_Reward_ID);
      } catch (e) {
        print('Error showing or loading rewarded ad: $e');
        rewardedAdLoadState = AdLoadState.loading;
        AppLovinMAX.loadRewardedAd(Platform.isAndroid
            ? AppStrings.MAX_Reward_ID
            : AppStrings.IOS_MAX_Reward_ID);
        // Handle the error as needed
      }
    } else {
      print('Loading rewarded ad...');
      rewardedAdLoadState = AdLoadState.loading;
      AppLovinMAX.loadRewardedAd(Platform.isAndroid
          ? AppStrings.MAX_Reward_ID
          : AppStrings.IOS_MAX_Reward_ID);
    }

    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
      onAdLoadedCallback: (ad) {
        rewardedAdLoadState = AdLoadState.loaded;
        print('Rewarded ad loaded from ${ad.networkName}');
        rewardedAdRetryAttempt = 0;
      },
      onAdDisplayedCallback: (ad) {
        print('Rewarded ad displayed');
        onRewardedAdWatched();
      },
      onAdHiddenCallback: (ad) {
        rewardedAdLoadState = AdLoadState.notLoaded;
        AppLovinMAX.loadRewardedAd(Platform.isAndroid
            ? AppStrings.MAX_Reward_ID
            : AppStrings.IOS_MAX_Reward_ID);

        print('Rewarded ad hidden');
        // Invoke the onRewardedAdWatched function when the rewarded ad is hidden
        // onRewardedAdWatched();
        // temp();
      },
      onAdLoadFailedCallback: (String adUnitId, MaxError error) {},
      onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {},
      onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {},
      onAdClickedCallback: (MaxAd ad) {},
    ));
    // }
  }

  temp() {
    print("Rewarded Temp");
  }

  void showAppLovinConsentFlow() async {
    if (kDebugMode)
      AppLovinMAX.setConsentFlowDebugUserGeography(
          ConsentFlowUserGeography.gdpr);
    MaxCMPError? error = await AppLovinMAX.showCmpForExistingUser();

    if (error == null) {
      developer.log("The CMP alert was shown successfully");
      // The CMP alert was shown successfully.
    } else {
      developer.log("CMP Error: ${error}");
    }
  }

  Obx MyBannerAdWidget() {
    return Obx(() =>
        RevenueCatService().currentEntitlement.value == Entitlement.paid
            ? Container(
                height: 0,
              )
            : MaxAdView(
                adUnitId: Platform.isAndroid
                    ? AppStrings.MAX_BANNER_ID
                    : AppStrings.IOS_MAX_BANNER_ID,
                adFormat: AdFormat.banner,
                listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                  FirebaseAnalytics.instance.logAdImpression(
                    adFormat: "banner",
                    adSource: ad.networkName,
                    value: ad.revenue,
                  );
                  print('Mrec widget ad loaded from ' + ad.networkName);
                }, onAdLoadFailedCallback: (adUnitId, error) {
                  print('Mrec widget ad failed to load with error code ' +
                      error.code.toString() +
                      ' and message: ' +
                      error.message);
                }, onAdClickedCallback: (ad) {
                  print('Mrec widget ad clicked');
                }, onAdExpandedCallback: (ad) {
                  print('Mrec widget ad expanded');
                }, onAdCollapsedCallback: (ad) {
                  print('Mrec widget ad collapsed');
                })));
  }
}

enum AdLoadState { notLoaded, loading, loaded }
