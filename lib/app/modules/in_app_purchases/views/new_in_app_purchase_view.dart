import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 5,
                    top: SizeConfig.blockSizeVertical * 4,
                  ),
                  height: SizeConfig.blockSizeVertical * 6,
                  width: SizeConfig.blockSizeHorizontal * 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.textfieldcolor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 15,
                  top: SizeConfig.blockSizeVertical * 4,
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
                  child: Text(
                    "${RCVariables.AppName} Pro",
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textfieldcolor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                  child: Container(
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
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
                          child: FutureBuilder<StoreProduct?>(
                              future:
                                  RevenueCatService().getLifeTimeSubscription(),
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
                                        final product = snapshot.data!;
                                        // controller.selectedProduct.value =
                                        //     product;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          controller.selectedProduct.value =
                                              product;
                                        });
                                        // final withoutDiscountPrice = controller.getOriginalPrice(
                                        //     discountPercentage: RCVariables.discountPercentage,
                                        //     discountedPrice: removeAdProduct.price);

                                        return _mainContent(product);
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

  Column _mainContent(StoreProduct product) {
    final orignalPrice = controller
        .getOriginalPrice(
            discountPercentage: RCVariables.discountPercentage,
            discountedPrice: product.price)
        .toStringAsFixed(2);

    final OriginalPriceString = "${orignalPrice}${product.currencyCode}";
    return Column(
      children: [
        verticalSpace(SizeConfig.blockSizeVertical * 3),
        Text(
          "Up to 30 AI generation per day, up to 12 AI",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 3.5,
              color: AppColors.titles,
            ),
          ),
        ),
        Text(
          "generation slides, pro styles and much more",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 3.5,
              color: AppColors.titles,
            ),
          ),
        ),
        Container(
          height: SizeConfig.blockSizeVertical * 10,
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
        Obx(() => controller.showTimer.value
            ? Container(
                margin:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
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
                text:
                    "Get instant access to all features. You will be able to \n ",
              ),
              TextSpan(
                text: "cancel your subscription at any time",
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
            Text(
              "${RCVariables.AppName} Pro includes",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                ),
              ),
            ),
          ],
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
                "No ad breaks",
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
                    Image.asset(
                      AppImages.intro_themes,
                      scale: 2,
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
                text:
                    "If you have any further questions, feel free to email \n ",
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

  Align footerWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
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
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    child: Center(
                      child: Obx(() => GestureDetector(
                            onTap: controller.selectedProduct.value != null
                                ? () {
                                    // controller.switchToSlidesOutlines();
                                    RevenueCatService()
                                        .purchaseSubscriptionWithProduct(
                                            controller.selectedProduct.value!);
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
                            child: Obx(
                                () => controller.selectedProduct.value != null
                                    ? Text(
                                        "${controller.selectedProduct.value!.priceString} / Life Time",
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
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
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
        Positioned(
          top: SizeConfig.blockSizeVertical * 5,
          left: SizeConfig.blockSizeHorizontal * 5,
          child: Column(
            children: [
              Text(
                text1,
                style: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor)),
              ),
              RichText(
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
                      text: "$text2 \n",
                    ),
                    TextSpan(
                      text: text3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
