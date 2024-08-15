import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:slide_maker/app/modules/in_app_purchases/controllers/in_app_purchases_controller.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class InAppPurchasesView extends GetView<InAppPurchasesController> {
  const InAppPurchasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder<List<StoreProduct>>(
            future: RevenueCatService().getAllSubscriptionProducts(),
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
                      final products = snapshot.data!;
                      controller.selectedIndex.value = products.length - 1;
                      if (products[controller.selectedIndex.value].identifier ==
                          "aislide_adremove_1") {
                        controller.showTimer.value = true;
                      } else {
                        controller.showTimer.value = false;
                      }
                      // final withoutDiscountPrice = controller.getOriginalPrice(
                      //     discountPercentage: RCVariables.discountPercentage,
                      //     discountedPrice: removeAdProduct.price);

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 5,
                                  right: SizeConfig.blockSizeHorizontal * 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: SizeConfig.blockSizeHorizontal * 7,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "AI SLIDE MAKER",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 7,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6420)),
                              ),
                              horizontalSpace(
                                  SizeConfig.blockSizeHorizontal * 1),
                              Container(
                                height: SizeConfig.blockSizeVertical * 3.2,
                                width: SizeConfig.blockSizeHorizontal * 13,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFF6420),
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 1)),
                                child: Text(
                                  "PRO",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          verticalSpace(SizeConfig.blockSizeVertical * 2),
                          Center(
                            child: Text(
                              "Upgrade your plan to boost your productivity",
                              style: GoogleFonts.ibarraRealNova(
                                  textStyle: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.7,
                                      color: Colors.white)),
                            ),
                          ),
                          verticalSpace(SizeConfig.blockSizeVertical * 4),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    height: SizeConfig.blockSizeVertical * 15,
                                    width: SizeConfig.blockSizeHorizontal * 28,
                                    child: Image.asset(AppImages.no_ads)),
                                Container(
                                    height: SizeConfig.blockSizeVertical * 15,
                                    width: SizeConfig.blockSizeHorizontal * 28,
                                    child: Image.asset(
                                        AppImages.remove_watermark)),
                                Container(
                                    height: SizeConfig.blockSizeVertical * 15,
                                    width: SizeConfig.blockSizeHorizontal * 28,
                                    child: Image.asset(AppImages.write_books)),
                              ]),
                          verticalSpace(SizeConfig.blockSizeVertical * 1.5),

                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return premium_offers(products, index);
                              }),
                          // premium_offers("Weekly", "1000\$", "100\$/week", "90%"),
                          // premium_offers(
                          //     "Monthly", "1000\$", "100\$/week", "90%"),
                          // premium_offers(
                          //     "Pay Once", "1000\$", "100\$/week", "90%"),
                          verticalSpace(SizeConfig.blockSizeVertical * 4),
                          _BtnContinue(products),
                          Obx(() => controller.showTimer.value
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical),
                                  child: Center(
                                    child: Text(
                                      "Only ${RCVariables.slotLeft.value} Slots Left | Remianing Time ${controller.timeLeft.value}",
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  2.7),
                                    ),
                                  ),
                                )
                              : Container()),
                          Center(
                            child: Container(
                              height: SizeConfig.blockSizeVertical * 11,
                              width: SizeConfig.blockSizeHorizontal * 90,
                              color: Color(0xFF2B2B2B),
                              margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 5),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.blockSizeHorizontal * 4),
                                child: Text(
                                  "Your Subscription can be managed or canceled under your Google play store Account Profile > Payment and Subscription",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.5,
                                          // fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFFFFF))),
                                ),
                              ),
                            ),
                          ),
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
        ),
      ),
    );
  }

  Center _BtnContinue(List<StoreProduct> products) {
    return Center(
      child: Material(
        color:
            Colors.transparent, // Make the Material widget's color transparent
        child: Ink(
          decoration: BoxDecoration(
            color: Color(0xFFFF6420), // The same color as the container
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 0.5),
          ),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 0.5),
            onTap: () {
              // Handle tap

              RevenueCatService().purchaseSubscriptionWithProduct(
                  products[controller.selectedIndex.value]);
            },
            splashColor: Color.fromARGB(
                255, 109, 112, 122), // Ripple effect color with opacity
            child: Container(
              height: SizeConfig.blockSizeVertical * 6,
              width: SizeConfig.blockSizeHorizontal * 50,
              child: Center(
                child: Text(
                  "Continue",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget premium_offers(List<StoreProduct> products, index) {
    String text1 = "weekly";
    String text2 = "100\$";
    String text3 = "100\$/week";
    String text4 = "90%";
    // bool isSelected = true;
    bool isHot = false;
    bool isDiscounted = false;
    StoreProduct product = products[index];
    // isSelected = index == controller.selectedIndex.value ? true : false;
    // text1 = product.title;
    text1 = controller.getProductTitle(product);
    log("Produt ID: ${product.identifier}");
    double discountPercentage = 0.0;

    final pID = product.identifier;
    if (pID == "aislide_premium_1w:aislide-baseplan-weekly") {
      isDiscounted = false;
      product.productCategory;
      String productPeriod = controller.getProductPeriod(product);
      text3 = "${product.priceString}/${productPeriod}";
      final orignalPrice = controller
          .getOriginalPrice(
              discountPercentage: RCVariables.discountPercentage,
              discountedPrice: product.price)
          .toStringAsFixed(2);

      text2 = "${orignalPrice}${product.currencyCode}";

      isHot = controller.getIsHot(product);
      text4 = "${RCVariables.discountPercentage.toStringAsFixed(0)}%";
    } else if (pID == "aislide_premium_1m:aislide-baseplan-monthly") {
      isDiscounted = true;
      // final weeklyPrice = products
      //     .where((element) =>
      //         element.identifier ==
      //         "aislide_premium_1w:aislide-baseplan-weekly")
      //     .first
      //     .price;

      final perWeek = product.price / 4;
      final weeklyPrice = products
          .firstWhere(
              (element) =>
                  element.identifier ==
                  "aislide_premium_1w:aislide-baseplan-weekly",
              orElse: () => StoreProduct(
                  "aislide_premium_1w:aislide-baseplan-weekly",
                  "Weekly",
                  "Weekly",
                  perWeek * 2.7,
                  product.priceString,
                  product.currencyCode))
          .price;

      final originalPrice = weeklyPrice * 4;
      text2 = "${originalPrice.toStringAsFixed(1)}${product.currencyCode}";
      discountPercentage = 100 - ((product.price / originalPrice) * 100);
      String productPeriod = controller.getProductPeriod(product);

      text3 = "${product.priceString}/${productPeriod}";
      text4 = "${discountPercentage.toStringAsFixed(0)}%";
    } else if (pID == "aislide_premium_1y:aislide-baseplan-yearly") {
      isDiscounted = true;
      // final weeklyPrice = products
      //     .where((element) =>
      //         element.identifier ==
      //         "aislide_premium_1w:aislide-baseplan-weekly")
      //     .first
      //     .price;

      final perWeek = product.price / 4;
      final weeklyPrice = products
          .firstWhere(
              (element) =>
                  element.identifier ==
                  "aislide_premium_1w:aislide-baseplan-weekly",
              orElse: () => StoreProduct(
                  "aislide_premium_1w:aislide-baseplan-weekly",
                  "Weekly",
                  "Weekly",
                  perWeek * 40,
                  product.priceString,
                  product.currencyCode))
          .price;

      final originalPrice = weeklyPrice * 52;
      text2 = "${originalPrice.toStringAsFixed(1)}${product.currencyCode}";
      discountPercentage = 100 - ((product.price / originalPrice) * 100);
      String productPeriod = controller.getProductPeriod(product);

      text3 = "${product.priceString}/${productPeriod}";
      text4 = "${discountPercentage.toStringAsFixed(0)}%";
    } else if (pID == "aislide_adremove_1") {
      isDiscounted = true;
      product.productCategory;
      String productPeriod = controller.getProductPeriod(product);
      text3 = "${product.priceString}/${productPeriod}";
      final orignalPrice = controller
          .getOriginalPrice(
              discountPercentage: RCVariables.discountPercentage,
              discountedPrice: product.price)
          .toStringAsFixed(2);
      text2 = "${orignalPrice}${product.currencyCode}";

      isHot = controller.getIsHot(product);
      text4 = "${RCVariables.discountPercentage.toStringAsFixed(0)}%";
    }

    // product.productCategory;
    // String productPeriod = controller.getProductPeriod(product);
    // text3 = "${product.priceString}/${productPeriod}";
    // text4 = "${RCVariables.discountPercentage.toStringAsFixed(0)}%";
    // final orignalPrice = controller
    //     .getOriginalPrice(
    //         discountPercentage: RCVariables.discountPercentage,
    //         discountedPrice: product.price)
    //     .toStringAsFixed(2);
    // text2 = "${orignalPrice}${product.currencyCode}";

    // isHot = controller.getIsHot(product);
    return Stack(
      children: [
        Obx(() => Center(
              child: GestureDetector(
                onTap: () {
                  controller.selectedIndex.value = index;

                  if (pID == "aislide_adremove_1") {
                    controller.showTimer.value = true;
                  } else {
                    controller.showTimer.value = false;
                  }
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.5),
                  height: SizeConfig.blockSizeVertical * 8,
                  width: index == controller.selectedIndex.value
                      ? SizeConfig.blockSizeHorizontal * 94
                      : SizeConfig.blockSizeHorizontal * 92,
                  decoration: BoxDecoration(
                      color: Color(0xFF3B3B3B),
                      border: Border.all(
                          color: index == controller.selectedIndex.value
                              ? Color(0xFFFF6420)
                              : Color(0xFF868686),
                          width: SizeConfig.blockSizeHorizontal * 0.5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5),
                          topRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 1),
                          bottomLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 1),
                          bottomRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 5))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.blockSizeHorizontal * 0.6,
                        left: SizeConfig.blockSizeHorizontal * 2.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(text1,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.5,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        index == controller.selectedIndex.value
                                            ? Color(0xFFFF6420)
                                            : Color(0xFFFFFFFF)))),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text2,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      color: Color(0xFF868686),
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Color(0xFF868686))),
                            ),
                            Text(
                              text3,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      color: Color(0xFFFFFFFF))),
                            ),
                          ],
                        ),
                        isDiscounted
                            ? Container(
                                height: SizeConfig.blockSizeVertical * 7,
                                width: SizeConfig.blockSizeHorizontal * 16,
                                decoration: BoxDecoration(
                                    color:
                                        index == controller.selectedIndex.value
                                            ? Color(0xFFFF6420)
                                            : Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            SizeConfig.blockSizeHorizontal * 4),
                                        topRight: Radius.circular(
                                            SizeConfig.blockSizeHorizontal *
                                                0.3),
                                        bottomLeft: Radius.circular(
                                            SizeConfig.blockSizeHorizontal * 4),
                                        bottomRight: Radius.circular(
                                            SizeConfig.blockSizeHorizontal *
                                                4))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      text4,
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              color: index ==
                                                      controller
                                                          .selectedIndex.value
                                                  ? Color(0xFFFFFFFF)
                                                  : Color(0xFFFF6420),
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4.5,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Text(
                                      "off",
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              color: index ==
                                                      controller
                                                          .selectedIndex.value
                                                  ? Color(0xFFFFFFFF)
                                                  : Color(0xFFFF6420),
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4.5,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            )),
        isHot
            ? Positioned(
                top: SizeConfig.blockSizeVertical * 2.7,
                left: SizeConfig.blockSizeHorizontal * 8,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 2.2,
                  width: SizeConfig.blockSizeHorizontal * 27,
                  decoration: BoxDecoration(
                      color: Color(0xFFFF0000),
                      border: Border(
                        left: BorderSide(
                          color: Color(0xFF868686),
                          width: SizeConfig.blockSizeHorizontal * 0.5,
                        ),
                        right: BorderSide(
                          color: Color(0xFF868686),
                          width: SizeConfig.blockSizeHorizontal * 0.5,
                        ),
                        bottom: BorderSide(
                          color: Color(0xFF868686),
                          width: SizeConfig.blockSizeHorizontal * 0.5,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 2),
                          bottomRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 2))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Limited Slots ",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Image.asset(
                        AppImages.hot,
                        scale: 2,
                      )
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
