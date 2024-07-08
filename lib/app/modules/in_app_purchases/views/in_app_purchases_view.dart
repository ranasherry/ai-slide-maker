import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:im_animations/im_animations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
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
          //     gradient: LinearGradient(colors: [
          //   Colors.black,
          //   Colors.indigo,
          //   // Colors.indigoAccent,
          //   const Color.fromARGB(150, 83, 109, 150),
          //   Colors.black,
          //   Colors.black,
          //   // Colors.black,
          // ], begin: Alignment.topLeft, end: Alignment.bottomRight)
          ),
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

                  final withoutDiscountPrice = controller.getOriginalPrice(
                      discountPercentage: RCVariables.discountPercentage,
                      discountedPrice: removeAdProduct.price);
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
                          height: SizeConfig.blockSizeVertical * 22,
                          width: SizeConfig.blockSizeHorizontal * 44,
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
                      remove_ads("Remove Ads", AppImages.no_ads, Colors.blue),
                      remove_ads("Remove Watermark", AppImages.remove_watermark,
                          Colors.blue),
                      remove_ads("Access All Templates",
                          AppImages.unlock_templates, Colors.amber),
                      remove_ads("Endless Prompts", AppImages.unlimited_promts,
                          Color(0xFF722158)),
                      remove_ads("Create your Own Ebook", AppImages.write_books,
                          Colors.green),
                      verticalSpace(SizeConfig.blockSizeVertical * 2),
                      Center(
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 12,
                          width: SizeConfig.screenWidth,
                          // color: Colors.amber,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: SizeConfig.blockSizeVertical * 10,
                                  width: SizeConfig.blockSizeHorizontal * 90,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.yellow
                                              .withOpacity(0.2), // Shadow color
                                          spreadRadius: 0, // Spread radius
                                          blurRadius: 2, // Blur radius
                                          offset: Offset(3,
                                              3), // Shadow position: x and y offset
                                        ),
                                      ],
                                      color: Color(0xFF07171D),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.blockSizeHorizontal * 2),
                                      border: Border.all(
                                          color: Colors.yellowAccent,
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  0.1)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.blockSizeHorizontal * 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: SizeConfig
                                                      .blockSizeHorizontal *
                                                  5),
                                          child: Text(
                                            // "\$1.00 USD / Lifetime Free Access",
                                            "${withoutDiscountPrice.toStringAsFixed(2)} ${removeAdProduct.currencyCode}",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    3,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Colors.white,
                                              highlightColor:
                                                  Colors.yellow.shade600,
                                              child: Text(
                                                // "\$1.00 USD / Lifetime Free Access",
                                                "${removeAdProduct.price} ${removeAdProduct.currencyCode} / Lifetime Free Access",
                                                style: TextStyle(
                                                    fontSize: SizeConfig
                                                            .blockSizeHorizontal *
                                                        4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            // Text(
                                            //   "Free",
                                            //   style: TextStyle(
                                            //       fontSize: SizeConfig.blockSizeHorizontal * 4,
                                            //       color: Colors.white),
                                            // ),
                                            Spacer(),
                                            Image.asset(
                                              AppImages.purchase,
                                              scale: 20,
                                            )
                                            // Transform.scale(
                                            //   scale: 1.3,
                                            //   child: Checkbox(
                                            //     value: true,
                                            //     shape: CircleBorder(),
                                            //     onChanged: null,
                                            //     checkColor: Colors.grey.shade900,
                                            //     // activeColor: Colors.amber,
                                            //     fillColor:
                                            //         MaterialStateProperty.all(Colors.amber),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: SizeConfig.blockSizeVertical * 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.blockSizeHorizontal *
                                              2),
                                      width:
                                          SizeConfig.blockSizeHorizontal * 12.5,
                                      height:
                                          SizeConfig.blockSizeHorizontal * 12.5,
                                      decoration: BoxDecoration(
                                          // color: Colors.amber,
                                          image: DecorationImage(
                                              image: AssetImage(
                                        AppImages.discount,
                                      ))),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.blockSizeVertical *
                                                1.1,
                                            left:
                                                SizeConfig.blockSizeHorizontal *
                                                    3),
                                        child: HeartBeat(
                                          child: Text(
                                            "${RCVariables.discountPercentage.toInt().toString()}% off",
                                            style: TextStyle(
                                                color: Color(0xFFFFE60A),
                                                height: 1,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: SizeConfig.blockSizeVertical * 1,
                                          right:
                                              SizeConfig.blockSizeHorizontal *
                                                  4.1),
                                      width:
                                          SizeConfig.blockSizeHorizontal * 28,
                                      height:
                                          SizeConfig.blockSizeHorizontal * 7.5,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                              AppImages.limited,
                                            ),
                                            fit: BoxFit.fill),
                                        // borderRadius: BorderRadius.only(
                                        //     topRight: Radius.circular(
                                        //         SizeConfig.blockSizeHorizontal *
                                        //             2)),
                                        // gradient: LinearGradient(
                                        //     colors: [
                                        //       Color(0xFFFF865C),
                                        //       Color(0xFFE03600),
                                        //     ],
                                        //     begin: Alignment.topCenter,
                                        //     end: Alignment.bottomCenter)
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: SizeConfig
                                                      .blockSizeHorizontal *
                                                  3.5,
                                              bottom:
                                                  SizeConfig.blockSizeVertical *
                                                      0.5),
                                          child: Text(
                                            "Limited Offer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
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
                          child: HeartBeat(
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.blockSizeVertical * 2),
                              height: SizeConfig.blockSizeVertical * 6,
                              width: SizeConfig.blockSizeHorizontal * 85,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      // color: Colors.indigoAccent
                                      //     .withOpacity(0.5), // Shadow color
                                      spreadRadius: 0, // Spread radius
                                      blurRadius: 2, // Blur radius
                                      offset: Offset(2,
                                          2), // Shadow position: x and y offset
                                    ),
                                  ],
                                  // border: Border.all(color: Colors.indigoAccent),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFE03600),
                                        Color(0xFFFF865C)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 8)),
                              child: Center(
                                child: Text(
                                  "Remove Ads",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
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

  Widget remove_ads(String text, String image, Color color) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 6,
          top: SizeConfig.blockSizeVertical * 1.5),
      child: Container(
        height: SizeConfig.blockSizeVertical * 6,
        width: SizeConfig.blockSizeHorizontal * 85,
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 3,
          right: SizeConfig.blockSizeHorizontal * 4,
        ),
        decoration: BoxDecoration(
            color: Color(0xFF07171D),
            boxShadow: [
              BoxShadow(
                // color: Colors.amber.withOpacity(0.2), // Shadow color
                spreadRadius: 0, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(2, 2), // Shadow position: x and y offset
              ),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 5),
                bottomRight: Radius.circular(
                  SizeConfig.blockSizeHorizontal * 5,
                ),
                topRight: Radius.circular(
                  SizeConfig.blockSizeHorizontal * 0.5,
                ),
                bottomLeft: Radius.circular(
                  SizeConfig.blockSizeHorizontal * 0.5,
                ))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.done,
            //   color: Colors.amber,
            // ),
            // horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
            Text(
              text,
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            ImageIcon(
              AssetImage(image),
              color: color,
            )
          ],
        ),
      ),
    );
  }
}
