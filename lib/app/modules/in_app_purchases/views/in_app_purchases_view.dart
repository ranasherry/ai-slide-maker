import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/in_app_purchases_controller.dart';

class InAppPurchasesView extends GetView<InAppPurchasesController> {
  const InAppPurchasesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // height: SizeConfig.screenHeight,
      // width: SizeConfig.screenWidth,

      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 6),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.black,
        Colors.indigo,
        // Colors.indigoAccent,
        const Color.fromARGB(150, 83, 109, 150),
        Colors.black,
        Colors.black,
        // Colors.black,
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: FutureBuilder(
        future: RevenueCatService().getRemoveAdProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error); // Log the error for debugging
            Get.back();
            return Text('Error fetching product information');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  StoreProduct removeAdProduct = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 3),
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                            size: SizeConfig.blockSizeHorizontal * 7,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 30,
                          width: SizeConfig.blockSizeHorizontal * 60,
                          child: Image.asset(AppImages.inappPurchase),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Premium Access",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 6,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                      ),
                      verticalSpace(SizeConfig.blockSizeVertical * 2),
                      remove_ads("Remove Ads"),
                      remove_ads("Unlock All Templates"),
                      remove_ads("Unlimited Prompts"),
                      remove_ads("Write Books"),
                      verticalSpace(SizeConfig.blockSizeVertical * 5),
                      Center(
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 9,
                          width: SizeConfig.blockSizeHorizontal * 90,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.blockSizeHorizontal * 3),
                              border: Border.all(
                                  color: Colors.yellow,
                                  width: SizeConfig.blockSizeHorizontal * 0.6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                // "\$1.00 USD / Lifetime Free Access",
                                "${removeAdProduct.price} ${removeAdProduct.currencyCode} / Lifetime Free Access",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              // Text(
                              //   "Free",
                              //   style: TextStyle(
                              //       fontSize: SizeConfig.blockSizeHorizontal * 4,
                              //       color: Colors.white),
                              // ),

                              Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  value: true,
                                  shape: CircleBorder(),
                                  onChanged: null,
                                  checkColor: Colors.black,
                                  // activeColor: Colors.amber,
                                  fillColor:
                                      MaterialStateProperty.all(Colors.amber),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            controller.proceedToRemoveAd(removeAdProduct);
                            controller.recordInAppImpression();
                            // ComFunction.showInfoDialog(
                            //     title: "Coming Soon",
                            //     msg:
                            //         "In-app purchases are coming soon, offering exciting new features to enhance your experience. Stay tuned!");

                            FirebaseAnalytics.instance.logAddToWishlist(items: [
                              AnalyticsEventItem(itemName: "Remove ads")
                            ]);
                            FirebaseAnalytics.instance.logSelectContent(
                                contentType: "removeAds", itemId: "removeAds1");
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: SizeConfig.blockSizeVertical * 2),
                            height: SizeConfig.blockSizeVertical * 8,
                            width: SizeConfig.blockSizeHorizontal * 90,
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockSizeHorizontal * 4)),
                            child: Center(
                              child: Text(
                                "Remove Ads",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  // Handle the case where StoreProduct is null
                  Get.back();
                  return Text('Something Went Wrong');
                }
              } else {
                // Handle the case where the "remove_ads" offering is not available
                Get.back();
                return Text('Something Went Wrong');
              }
            default:
              Get.back();

              return Text(
                  'Something Went Wrong'); // Handle other unexpected states
          }
        },
      ),
    ));
  }

  Widget remove_ads(String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 6,
          top: SizeConfig.blockSizeVertical * 1.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.done,
            color: Colors.amber,
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.yellow.shade600,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
