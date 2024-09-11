import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';
import 'package:slide_maker/app/modules/in_app_purchases/controllers/new_in_app_purchase_controller.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_style.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helprer_widgets/main_header_bg.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class newInAppPurchaseView extends GetView<newInAppPurchaseCTL> {
  const newInAppPurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainHeaderBG(
            width: SizeConfig.screenWidth,
            height: SizeConfig.blockSizeVertical * 35,
          ),
          Container(
            margin: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 5,
              right: SizeConfig.blockSizeHorizontal * 8,
              top: SizeConfig.blockSizeVertical * 5,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        // left: SizeConfig.blockSizeHorizontal * 5,
                        // top: SizeConfig.blockSizeVertical * 4,
                        ),
                    // padding: EdgeInsets.all(3),
                    height: SizeConfig.blockSizeVertical * 3,
                    width: SizeConfig.blockSizeHorizontal * 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.textfieldcolor,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      // left: SizeConfig.blockSizeHorizontal * 20,
                      // top: SizeConfig.blockSizeVertical * 4,
                      ),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 4),
                  height: SizeConfig.blockSizeVertical * 4,
                  // width: SizeConfig.blockSizeHorizontal * 25,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                  child: Center(
                    child: Obx(() => Text(
                          "${RCVariables.AppName.value} Pro",
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textfieldcolor,
                            ),
                          ),
                        )),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Unlock the full Power",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 7,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textfieldcolor,
                    ),
                  ),
                ),
                Text(
                  "of AI with pro.",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 7,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textfieldcolor,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: SizeConfig.blockSizeVertical * 26,
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Container(
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 6,
                              ),
                              topRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 6,
                              ),
                            ),
                          ),
                          child: FutureBuilder<StoreProductsWithOffering>(
                              future: RevenueCatService()
                                  .getCurrentOfferingProducts(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot
                                      .error); // Log the error for debugging
                                  Get.back();
                                  return Text(
                                      'Error fetching product information');
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
                                  case ConnectionState.done:
                                    if (snapshot.hasData) {
                                      if (snapshot.data != null) {
                                        final offeringIdentifier =
                                            snapshot.data!.offeringID;
                                        debugPrint(
                                            "Current Offering Identifiers: ${offeringIdentifier}");
                                        final products =
                                            snapshot.data!.allProducts;
                                        // controller.selectedProduct.value =
                                        //     product;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          // products.removeWhere((p) =>
                                          //     p.identifier ==
                                          //     "aislide_premium_1y:aislide-baseplan-yearly");

                                          int index = products.length - 1;
                                          controller.selectedIndex.value =
                                              products.length - 1;
                                          if (products[index].identifier ==
                                              "aislide_adremove_1") {
                                            controller.showTimer.value = true;
                                          } else {
                                            controller.showTimer.value = false;
                                          }
                                          controller.selectedProduct.value =
                                              products[controller
                                                  .selectedIndex.value];
                                        });
                                        // final withoutDiscountPrice = controller.getOriginalPrice(
                                        //     discountPercentage: RCVariables.discountPercentage,
                                        //     discountedPrice: removeAdProduct.price);

                                        return _mainContent(
                                            products, offeringIdentifier);
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
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 53),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                        stops: [0.0, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Container(
                      height: 30.0, // Height of the fading effect
                      color: Colors.white,
                    ),
                  ),
                ),
                footerWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _mainContent(List<StoreProduct> products, String currentOfferingID) {
    return Column(
      children: [
        // ),
        currentOfferingID == "premimum_subscription_beta"
            ? premimum_subscription_beta_widget(products)
            : Container(
                width: SizeConfig.screenWidth,
                // color: Colors.red,
                child: Center(
                  child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        // if (products[index].identifier == "aislide_adremove_1") {
                        //   return _hotProductItem(products[index]);
                        // } else {
                        //   return _productItem(products[index]);
                        // }
                        return _productItem(products[index], products, index);
                      }),
                ),
              ),
        // _productItem(product),

        Obx(() => controller.showTimer.value
            ? Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.blockSizeVertical * 2,
                    top: SizeConfig.blockSizeVertical * 1),
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 60,
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.2), // Darker shadow for depth
                        spreadRadius: 2,
                        blurRadius:
                            10, // Larger blur radius for softer shadow edges
                        offset:
                            Offset(4, 4), // Slight offset to create a 3D effect
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(
                            0.1), // Highlight for the top-left edge
                        spreadRadius: -2,
                        blurRadius: 5,
                        offset: Offset(
                            -2, -2), // Opposite offset to simulate lighting
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 7)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Limited Slots",
                            style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textfieldcolor)),
                          ),
                          Image.asset(
                            AppImages.hot,
                            scale: 1.5,
                          )
                        ],
                      ),
                    ),
                    Text(
                      "Only ${RCVariables.slotLeft.value} slots left || Time left ${controller.timeLeft.value}",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 2,
                              color: Colors.amber)),
                    )
                  ],
                ),
              )
            : Container()),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 3,
                color: Colors.grey,
              ),
            ),
            children: [
              TextSpan(
                text: "Access all features instantly. You can cancel \n ",
              ),
              TextSpan(
                text: "your subscription at any time",
              ),
            ],
          ),
        ),
        verticalSpace(SizeConfig.blockSizeVertical * 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 4,
              width: SizeConfig.blockSizeHorizontal * 8,
              decoration: BoxDecoration(
                color: AppColors.textfieldcolor,
                borderRadius: BorderRadius.circular(
                  SizeConfig.blockSizeHorizontal * 3,
                ),
              ),
              child: Image.asset(
                AppImages.slide_beta,
                scale: 5,
              ),
            ),
            horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
            Obx(() => Text(
                  "${RCVariables.AppName.value} Pro includes",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                    ),
                  ),
                )),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 1.5,
              horizontal: SizeConfig.blockSizeHorizontal * 2),
          height: SizeConfig.blockSizeVertical * 10,
          width: SizeConfig.blockSizeHorizontal * 85,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "AI Generated Images",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titles,
                      ),
                    ),
                  ),
                  Text(
                    "Add the finishing touch with AI selected images",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 2,
                        color: AppColors.titles,
                      ),
                    ),
                  )
                ],
              ),
              Image.asset(
                AppImages.more_features,
                scale: 10,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
          ),
          height: SizeConfig.blockSizeVertical * 10,
          width: SizeConfig.blockSizeHorizontal * 85,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(
              SizeConfig.blockSizeHorizontal * 7,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "No Ad breaks",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titles,
                  ),
                ),
              ),
              Image.asset(
                AppImages.ads_purchase,
                scale: 4,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              slides_features(
                "AI Assistant",
                "Upto 200 commands",
                "per day",
              ),
              slides_features(
                "Presentation AI",
                "Upto 30 presentations per",
                "day",
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              slides_features(
                "Remove watermark",
                "Easily remove watermark",
                "from slides",
              ),
              slides_features(
                "Write E-book",
                "Create your own e-book with ease",
                "using AI assistant",
              ),
            ],
          ),
        ),
        verticalSpace(SizeConfig.blockSizeVertical * 1),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 14,
                width: SizeConfig.blockSizeHorizontal * 46,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7),
                  // image: DecorationImage(
                  //     image: AssetImage(
                  //         AppImages.intro_themes),
                  //     scale: 2)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          TextSpan(
                            text: "PRO ",
                            style: TextStyle(color: AppColors.mainColor),
                          ),
                          TextSpan(
                            text: "Styles",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical * 7,
                      width: SizeConfig.blockSizeHorizontal * 30,
                      child: Image.asset(
                        AppImages.intro_themes,
                        scale: 1,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                height: SizeConfig.blockSizeVertical * 14,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Enhanced Icon Container
                    Container(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.blockSizeHorizontal * 18,
                      decoration: BoxDecoration(
                        color: AppColors.textfieldcolor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 0,
                            spreadRadius: 17,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: AppColors.mainColor,
                            size: SizeConfig.blockSizeHorizontal * 7,
                          ),
                          Text(
                            ".PPTX",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainColor)),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 2.3,
                                  color: Colors.black,
                                  // fontWeight:
                                  //     FontWeight.bold,
                                ),
                              ),
                              children: [
                                TextSpan(
                                  text: "Format of files \n ",
                                  style: TextStyle(),
                                ),
                                TextSpan(
                                  text: "sharing",
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        verticalSpace(SizeConfig.blockSizeVertical * 2),
        Text(
          "Have more questions ?",
          style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 6,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titles)),
        ),
        verticalSpace(SizeConfig.blockSizeVertical * 2),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 3,
                color: AppColors.titles,
              ),
            ),
            children: [
              TextSpan(
                text: "If you have more questions, feel free to contact  \n ",
              ),
              TextSpan(
                text: "us by clicking the button below.",
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 3,
              bottom: SizeConfig.blockSizeVertical * 3),
          height: SizeConfig.blockSizeVertical * 6,
          width: SizeConfig.blockSizeHorizontal * 80,
          decoration: BoxDecoration(
              color: AppColors.textfieldcolor,
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7)),
          child: Center(
            child: Text(
              "Contact us",
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titles)),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              controller
                  .openURL("https://sites.google.com/view/appgeniusx/home");
            },
            child: privacy_policy(Icons.verified, "Terms of use")),
        Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 22),
          child: GestureDetector(
            onTap: () {
              controller
                  .openURL("https://sites.google.com/view/appgeniusx/home");
            },
            child: privacy_policy(Icons.privacy_tip, "Privacy Policy"),
          ),
        ),
      ],
    );
  }

  Widget premimum_subscription_beta_widget(List<StoreProduct> products) {
    StoreProduct removeAdProduct =
        products.where((p) => p.identifier == "aislide_adremove_1").first;
    int removeAdProductIndex = products.indexOf(removeAdProduct);
    // products.remove(removeAdProduct);
    return Column(
      children: [
        Container(
          width: SizeConfig.screenWidth,
          // padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 4,
              right: SizeConfig.blockSizeHorizontal * 4,
              top: SizeConfig.blockSizeHorizontal * 4,
              bottom: 0),
          // color: Colors.red,
          child: Center(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5 / 4,
                ),
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: products.length - 1,
                itemBuilder: (context, index) {
                  // if (products[index].identifier == "aislide_adremove_1") {
                  //   return _hotProductItem(products[index]);
                  // } else {
                  //   return _productItem(products[index]);
                  // }
                  return _gridProductItem(products[index], products, index);
                }),
          ),
        ),
        _productItem(
            products[removeAdProductIndex], products, removeAdProductIndex)
      ],
    );
  }

  Widget _productItem(
      StoreProduct product, List<StoreProduct> products, int index) {
    bool isDiscounted = false;

    var orignalPrice = controller
        .getOriginalPrice(
            discountPercentage: RCVariables.discountPercentage,
            discountedPrice: product.price)
        .toStringAsFixed(2);
    String productTitle = controller.getProductTitle(product);
    String productPeriod = controller.getProductPeriod(product);
    developer.log("ID: ${product.identifier}  period: $productPeriod");
    var OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    int discountPercentage = RCVariables.discountPercentage.toInt();

    final pID = product.identifier;

    if (pID == "aislide_premium_1w:aislide-baseplan-weekly") {
      isDiscounted = false;
      orignalPrice = controller
          .getOriginalPrice(
              discountPercentage: RCVariables.discountPercentage,
              discountedPrice: product.price)
          .toStringAsFixed(2);

      OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    } else if (pID == "aislide_premium_1m:aislide-baseplan-monthly") {
      isDiscounted = true;
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

      final orignalPrice = weeklyPrice * 4;
      OriginalPriceString = "${orignalPrice}${product.currencyCode}";
      discountPercentage =
          (100 - ((product.price / orignalPrice) * 100)).toInt();
      String productPeriod = controller.getProductPeriod(product);

      // text4 = "${discountPercentage.toStringAsFixed(0)}%";
    } else if (pID == "aislide_premium_1y:aislide-baseplan-yearly") {
      isDiscounted = true;
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

      final orignalPrice = weeklyPrice * 52;
      OriginalPriceString = "${orignalPrice}${product.currencyCode}";
      discountPercentage =
          (100 - ((product.price / orignalPrice) * 100)).toInt();
      String productPeriod = controller.getProductPeriod(product);
    } else if (pID == "aislide_adremove_1") {
      isDiscounted = true;
      final orignalPrice = controller
          .getOriginalPrice(
              discountPercentage: RCVariables.discountPercentage,
              discountedPrice: product.price)
          .toStringAsFixed(2);
      OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    }

    String saveText = "Save ${discountPercentage}%";

    return GestureDetector(
      onTap: () {
        controller.selectedIndex.value = index;
        controller.selectedProduct.value =
            products[controller.selectedIndex.value];
      },
      child: Container(
        // height: SizeConfig.blockSizeVertical * 10,
        // color: Colors.red,
        width: SizeConfig.screenWidth,
        child: Center(
          child: Stack(
            children: [
              Obx(() => Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 2,
                    ),
                    height: SizeConfig.blockSizeVertical * 7,
                    width: SizeConfig.blockSizeHorizontal * 85,
                    decoration: BoxDecoration(
                      color: AppColors.textfieldcolor,
                      borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 8,
                      ),
                      border: Border.all(
                        color: controller.selectedIndex.value == index
                            ? AppColors.mainColor
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 2,
                      ),
                      child: Row(
                        children: [
                          Obx(() => Radio(
                                toggleable: true,
                                value: controller.selectedIndex.value,
                                groupValue: index,
                                onChanged: (value) {
                                  // controller.selectedIndex.value = value ?? 0;
                                  //  controller.selectedProduct.value =
                                  //             products[controller.selectedIndex.value];
                                },
                                activeColor: AppColors.mainColor,
                                visualDensity: VisualDensity.compact,
                              )),
                          horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${OriginalPriceString}",
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.black26,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3,
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                // "${product.priceString}/ Life Time",
                                "${product.priceString}/ ${productPeriod}",
                                style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "$productTitle",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              if (isDiscounted)
                Positioned(
                  left: SizeConfig.blockSizeHorizontal * 60,
                  top: SizeConfig.blockSizeVertical * 0.7,
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 2.7,
                    width: SizeConfig.blockSizeHorizontal * 18,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 8,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "$saveText",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                            color: AppColors.textfieldcolor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridProductItem(
      StoreProduct product, List<StoreProduct> products, int index) {
    bool isDiscounted = false;

    var orignalPrice = controller
        .getOriginalPrice(
            discountPercentage: RCVariables.discountPercentage,
            discountedPrice: product.price)
        .toStringAsFixed(2);
    String productTitle = controller.getProductTitleBeta(product);
    String productPeriod = controller.getProductPeriodBeta(product);
    developer.log("ID: ${product.identifier}  period: $productPeriod");
    var OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    int discountPercentage = RCVariables.discountPercentage.toInt();

    String perMonthPriceStr = "";

    final pID = product.identifier;

    if (pID == "aislide_premium_1w:aislide-baseplan-weekly") {
      isDiscounted = false;
      orignalPrice = controller
          .getOriginalPrice(
              discountPercentage: RCVariables.discountPercentage,
              discountedPrice: product.price)
          .toStringAsFixed(2);

      OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    } else if (pID == "aislide_premium_1m:aislide-baseplan-monthly") {
      isDiscounted = false;

      OriginalPriceString = "${product.price}${product.currencyCode}";

      discountPercentage =
          (100 - ((product.price / product.price) * 100)).toInt();

      // text4 = "${discountPercentage.toStringAsFixed(0)}%";
    } else if (pID == "aislide_premium_1y:aislide-baseplan-yearly") {
      isDiscounted = true;
      final perMonth = product.price / 12;

      final monthlyPrice = products
          .firstWhere(
              (element) =>
                  element.identifier ==
                  "aislide_premium_1m:aislide-baseplan-monthly",
              orElse: () => StoreProduct(
                  "aislide_premium_1m:aislide-baseplan-monthly",
                  "Monthly",
                  "Monthly",
                  perMonth,
                  product.priceString,
                  product.currencyCode))
          .price;

      final orignalPrice = monthlyPrice * 12;

      OriginalPriceString =
          "${perMonth.toStringAsFixed(2)}${product.currencyCode}";
      perMonthPriceStr =
          "${monthlyPrice.toStringAsFixed(2)}${product.currencyCode}";

      discountPercentage =
          (100 - ((product.price / orignalPrice) * 100)).toInt();
      String productPeriod = controller.getProductPeriod(product);
    } else if (pID == "aislide_premium_6m:aislid-baseplan-bimonthly") {
      isDiscounted = true;
      final perMonth = product.price / 6;

      final monthlyPrice = products
          .firstWhere(
              (element) =>
                  element.identifier ==
                  "aislide_premium_1m:aislide-baseplan-monthly",
              orElse: () => StoreProduct(
                  "aislide_premium_1m:aislide-baseplan-monthly",
                  "Monthly",
                  "Monthly",
                  perMonth,
                  product.priceString,
                  product.currencyCode))
          .price;

      final orignalPrice = monthlyPrice * 6;

      OriginalPriceString =
          "${perMonth.toStringAsFixed(2)}${product.currencyCode}";
      perMonthPriceStr =
          "${monthlyPrice.toStringAsFixed(2)}${product.currencyCode}";

      discountPercentage =
          (100 - ((product.price / orignalPrice) * 100)).toInt();
      String productPeriod = controller.getProductPeriod(product);
    } else if (pID == "aislide_premium_3m:aislide-baseplan-trimonthly") {
      isDiscounted = true;
      final perMonth = product.price / 3;

      final monthlyPrice = products
          .firstWhere(
              (element) =>
                  element.identifier ==
                  "aislide_premium_1m:aislide-baseplan-monthly",
              orElse: () => StoreProduct(
                  "aislide_premium_1m:aislide-baseplan-monthly",
                  "Monthly",
                  "Monthly",
                  perMonth,
                  product.priceString,
                  product.currencyCode))
          .price;

      final orignalPrice = monthlyPrice * 3;

      OriginalPriceString =
          "${perMonth.toStringAsFixed(2)}${product.currencyCode}";
      perMonthPriceStr =
          "${monthlyPrice.toStringAsFixed(2)}${product.currencyCode}";

      discountPercentage =
          (100 - ((product.price / orignalPrice) * 100)).toInt();
      String productPeriod = controller.getProductPeriod(product);
    } else if (pID == "aislide_adremove_1") {
      isDiscounted = true;
      final orignalPrice = controller
          .getOriginalPrice(
              discountPercentage: RCVariables.discountPercentage,
              discountedPrice: product.price)
          .toStringAsFixed(2);
      OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    }

    String saveText = "Save ${discountPercentage}%";

    return GestureDetector(
      onTap: () {
        controller.selectedIndex.value = index;
        controller.selectedProduct.value =
            products[controller.selectedIndex.value];
      },
      child: Container(
        // height: SizeConfig.blockSizeVertical * 10,
        // width: SizeConfig.screenWidth,
        child: Center(
          child: Stack(children: [
            Obx(
              () => Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: controller.selectedIndex.value == index
                          ? AppColors.mainColor
                          : Colors.grey,
                      width: 2,
                    )),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(() => Radio(
                                onChanged: (value) {},
                                toggleable: true,
                                value: controller.selectedIndex.value,
                                groupValue: index,
                                visualDensity: VisualDensity.compact,
                                activeColor: Color(0xffD43D01),
                              )),
                          Text(
                            '$productTitle',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${perMonthPriceStr}',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.black38,
                            fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 24,
                            child: FittedBox(
                              child: Text(
                                '${OriginalPriceString}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Text(
                            '/Month',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          )
                        ],
                      ),

                      // Text(
                      //   'USD 35.99',
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     color: Colors.black54,
                      //   ),
                      // ),
                      Text(
                        '${productPeriod}',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isDiscounted
                ? Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      // height: 20,
                      // width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Text(
                        '$saveText',
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
                : Container()
          ]),
        ),
      ),
    );
  }

  Container _hotProductItem(StoreProduct product) {
    final orignalPrice = controller
        .getOriginalPrice(
            discountPercentage: RCVariables.discountPercentage,
            discountedPrice: product.price)
        .toStringAsFixed(2);

    final OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    return Container(
      height: SizeConfig.blockSizeVertical * 10,
      width: SizeConfig.screenWidth,
      child: Center(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 2,
              ),
              height: SizeConfig.blockSizeVertical * 7,
              width: SizeConfig.blockSizeHorizontal * 85,
              decoration: BoxDecoration(
                color: AppColors.textfieldcolor,
                borderRadius: BorderRadius.circular(
                  SizeConfig.blockSizeHorizontal * 8,
                ),
                border: Border.all(
                  color: AppColors.mainColor,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 2,
                ),
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: 1,
                      onChanged: (_) {},
                      activeColor: AppColors.mainColor,
                      visualDensity: VisualDensity.compact,
                    ),
                    horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${OriginalPriceString}",
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.black26,
                              fontSize: SizeConfig.blockSizeHorizontal * 3,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "${product.priceString}/ Life Time",
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      "Pay Once",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 3,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: SizeConfig.blockSizeHorizontal * 60,
              top: SizeConfig.blockSizeVertical * 0.7,
              child: Container(
                height: SizeConfig.blockSizeVertical * 2.7,
                width: SizeConfig.blockSizeHorizontal * 18,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(
                    SizeConfig.blockSizeHorizontal * 8,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Save ${RCVariables.discountPercentage.toInt()}%",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3,
                        color: AppColors.textfieldcolor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align footerWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => controller.showScroll.value
              ? GestureDetector(
                  onTap: () {
                    controller.scrollController.animateTo(
                      controller.scrollController.position.maxScrollExtent,
                      duration: Duration(
                          milliseconds: 500), // Adjust duration as needed
                      curve: Curves.easeOut, // You can use different curves
                    );
                  },
                  child: Container(
                      // width: SizeConfig.blockSizeHorizontal * 5,
                      height: SizeConfig.blockSizeVertical * 8,
                      child: Lottie.asset('assets/lottie/scroll_anim.json')),
                )
              : Container()),
          Card(
            // elevation: 5.0, // Set the elevation to the desired value
            margin: EdgeInsets.zero, // Remove default margins if needed
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.18,
              decoration: BoxDecoration(
                color: AppColors.footerContainerColor,
                // border: Border(
                //   top: BorderSide(
                //     color: const Color.fromARGB(
                //         255, 207, 207, 207), // Set the color to grey
                //     width: 1.0, // Set the width of the border
                //   ),
                // ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: SizeConfig.blockSizeVertical * 18,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          // border: Border.fromBorderSide(
                          //     BorderSide(color: Colors.grey.shade300, width: 2))
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2),
                        child: Center(
                          child: Obx(() => GestureDetector(
                                onTap: controller.selectedProduct.value != null
                                    ? () {
                                        // controller.switchToSlidesOutlines();
                                        RevenueCatService()
                                            .purchaseSubscriptionWithProduct(
                                                controller
                                                    .selectedProduct.value!);
                                      }
                                    : null,
                                child: Container(
                                  height: SizeConfig.blockSizeVertical * 7,
                                  width: SizeConfig.blockSizeHorizontal * 85,
                                  decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.blockSizeHorizontal * 8)),
                                  child: Center(
                                    child: Text("Start Subscription",
                                        style: AppStyle.button),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Positioned(
                        top: SizeConfig.blockSizeVertical * 11,
                        // left: SizeConfig.blockSizeHorizontal * 30,
                        child: Container(
                          width: SizeConfig.screenWidth,
                          child: Center(
                            child: Container(
                              height: SizeConfig.blockSizeVertical * 4,
                              width: SizeConfig.blockSizeHorizontal * 50,
                              decoration: BoxDecoration(
                                  color: AppColors.textfieldcolor,
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 8)),
                              child: Center(
                                child: Obx(() =>
                                    controller.selectedProduct.value != null
                                        ? Text(
                                            "${controller.selectedProduct.value!.priceString} / ${controller.getProductPeriod(controller.selectedProduct.value!)}",
                                            style: AppStyle.subHeadingText,
                                          )
                                        : Container()),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget privacy_policy(
    IconData icon,
    String text,
  ) {
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 1,
      ),
      height: SizeConfig.blockSizeVertical * 6,
      width: SizeConfig.blockSizeHorizontal * 80,
      decoration: BoxDecoration(
          color: AppColors.textfieldcolor,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7)),
      child: Row(
        children: [
          horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
          Icon(icon),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 20),
          Text(
            text,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 3.6,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titles)),
          ),
        ],
      ),
    );
  }

  Stack slides_features(
    String text1,
    String text2,
    String text3,
  ) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
          ),
          height: SizeConfig.blockSizeVertical * 13,
          width: SizeConfig.blockSizeHorizontal * 40,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7)),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 3,
          left: SizeConfig.blockSizeHorizontal * 3,
          child: SvgPicture.asset(
            AppImages.star_3,
            height: SizeConfig.blockSizeVertical * 2,
            width: SizeConfig.blockSizeHorizontal * 6,
          ),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 10,
          left: SizeConfig.blockSizeHorizontal * 7,
          child: SvgPicture.asset(
            AppImages.star_2,
            height: SizeConfig.blockSizeVertical * 3,
            width: SizeConfig.blockSizeHorizontal * 6,
          ),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 2,
          left: SizeConfig.blockSizeHorizontal * 27,
          child: SvgPicture.asset(
            AppImages.star_2,
            height: SizeConfig.blockSizeVertical * 3,
            width: SizeConfig.blockSizeHorizontal * 6,
          ),
        ),
        Positioned(
          top: SizeConfig.blockSizeVertical * 10,
          left: SizeConfig.blockSizeHorizontal * 26,
          child: SvgPicture.asset(
            AppImages.star_3,
            height: SizeConfig.blockSizeVertical * 1.5,
            width: SizeConfig.blockSizeHorizontal * 6,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 35,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 2.5,
                      color: AppColors.titles,
                    ),
                  ),
                  children: [
                    TextSpan(
                        text: "$text1 \n ",
                        style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor))),
                    TextSpan(
                      text: "$text2 \n",
                    ),
                    TextSpan(
                      text: text3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
