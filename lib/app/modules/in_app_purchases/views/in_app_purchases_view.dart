import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/in_app_purchases/controllers/in_app_purchases_controller.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class InAppPurchasesView extends GetView<InAppPurchasesController> {
  const InAppPurchasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    fontSize: SizeConfig.blockSizeHorizontal * 7,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6420)),
              ),
              horizontalSpace(SizeConfig.blockSizeHorizontal * 1),
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
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
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
                      fontSize: SizeConfig.blockSizeHorizontal * 3.7,
                      color: Colors.white)),
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
                height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 28,
                child: Image.asset(AppImages.no_ads)),
            Container(
                height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 28,
                child: Image.asset(AppImages.remove_watermark)),
            Container(
                height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 28,
                child: Image.asset(AppImages.write_books)),
          ]),
          verticalSpace(SizeConfig.blockSizeVertical * 1.5),
          premium_offers("Weekly", "1000\$", "100\$/week", "90%"),
          premium_offers("Monthly", "1000\$", "100\$/week", "90%"),
          premium_offers("Pay Once", "1000\$", "100\$/week", "90%"),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4),
              height: SizeConfig.blockSizeVertical * 6,
              width: SizeConfig.blockSizeHorizontal * 50,
              decoration: BoxDecoration(
                  color: Color(0xFFFF6420),
                  borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 0.5)),
              child: Center(
                child: Text("Continue",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 6,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
            ),
          ),
          Center(
            child: Container(
              height: SizeConfig.blockSizeVertical * 11,
              width: SizeConfig.blockSizeHorizontal * 90,
              color: Color(0xFF2B2B2B),
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
                child: Text(
                  "Your Subscription can be managed or canceled under your Google play store Account Profile > Payment and Subscription",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                          // fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget premium_offers(
      String text1, String text2, String text3, String text4) {
    bool isSelected = true;
    bool isHot = true;

    return Stack(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2.5),
            height: SizeConfig.blockSizeVertical * 8,
            width: SizeConfig.blockSizeHorizontal * 92,
            decoration: BoxDecoration(
                color: Color(0xFF3B3B3B),
                border: Border.all(
                    color: isSelected ? Color(0xFFFF6420) : Color(0xFF868686),
                    width: SizeConfig.blockSizeHorizontal * 0.5),
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 5),
                    topRight:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 1),
                    bottomLeft:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 1),
                    bottomRight:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 5))),
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
                              fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Color(0xFFFF6420)
                                  : Color(0xFFFFFFFF)))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text2,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color: Color(0xFF868686),
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Color(0xFF868686))),
                      ),
                      Text(
                        text3,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color: Color(0xFFFFFFFF))),
                      ),
                    ],
                  ),
                  Container(
                    height: SizeConfig.blockSizeVertical * 7,
                    width: SizeConfig.blockSizeHorizontal * 16,
                    decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xFFFF6420) : Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 4),
                            topRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 0.3),
                            bottomLeft: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 4),
                            bottomRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 4))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          text4,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: isSelected
                                      ? Color(0xFFFFFFFF)
                                      : Color(0xFFFF6420),
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text(
                          "off",
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: isSelected
                                      ? Color(0xFFFFFFFF)
                                      : Color(0xFFFF6420),
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.5,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        isHot
            ? Positioned(
                top: SizeConfig.blockSizeVertical * 2.7,
                left: SizeConfig.blockSizeHorizontal * 8,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 2.2,
                  width: SizeConfig.blockSizeHorizontal * 11,
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
                        "Hot",
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

// class InAppPurchasesView extends GetView<InAppPurchasesController> {
//   const InAppPurchasesView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: customePayWall());
//   }

//   Container customePayWall() {
//     return Container(
//       // height: SizeConfig.screenHeight,
//       // width: SizeConfig.screenWidth,

//       padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 6),
//       decoration: BoxDecoration(
//           //     gradient: LinearGradient(colors: [
//           //   Colors.black,
//           //   Colors.indigo,
//           //   // Colors.indigoAccent,
//           //   const Color.fromARGB(150, 83, 109, 150),
//           //   Colors.black,
//           //   Colors.black,
//           //   // Colors.black,
//           // ], begin: Alignment.topLeft, end: Alignment.bottomRight)
//           ),
//       child: FutureBuilder<List<StoreProduct>>(
//         future: RevenueCatService().getAllSubscriptionProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             print(snapshot.error); // Log the error for debugging
//             Get.back();
//             return Text('Error fetching product information');
//           }

//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(child: CircularProgressIndicator());
//             case ConnectionState.done:
//               if (snapshot.hasData) {
//                 if (snapshot.data != null) {
//                   final products = snapshot.data!;

//                   // final withoutDiscountPrice = controller.getOriginalPrice(
//                   //     discountPercentage: RCVariables.discountPercentage,
//                   //     discountedPrice: removeAdProduct.price);

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               left: SizeConfig.blockSizeHorizontal * 3),
//                           child: Icon(
//                             Icons.cancel_outlined,
//                             color: Colors.white,
//                             size: SizeConfig.blockSizeHorizontal * 7,
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: Container(
//                           height: SizeConfig.blockSizeVertical * 22,
//                           width: SizeConfig.blockSizeHorizontal * 44,
//                           child: Image.asset(AppImages.inappPurchase),
//                         ),
//                       ),
//                       Center(
//                         child: Text(
//                           "Premium Access",
//                           style: TextStyle(
//                               fontSize: SizeConfig.blockSizeHorizontal * 6,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange),
//                         ),
//                       ),
//                       verticalSpace(SizeConfig.blockSizeVertical * 2),
//                       remove_ads("Remove Ads", AppImages.no_ads, Colors.blue),
//                       remove_ads("Remove Watermark", AppImages.remove_watermark,
//                           Colors.blue),
//                       remove_ads("Access All Templates",
//                           AppImages.unlock_templates, Colors.amber),
//                       // remove_ads("Endless Prompts", AppImages.unlimited_promts,
//                       //     Color(0xFF722158)),
//                       remove_ads("Create your Own Ebook", AppImages.write_books,
//                           Colors.green),
//                       // verticalSpace(SizeConfig.blockSizeVertical * 4),

//                       ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: products.length,
//                         itemBuilder: (context, index) {
//                           final product = products[index];
//                           log("ProductName: ${product.title}");
//                           return Obx(() => RadioListTile<int>(
//                                 title: Text(controller
//                                     .removeParentheses(product.title)),
//                                 subtitle: Text(product.description),
//                                 value: index,
//                                 groupValue: controller.selectedIndex.value,
//                                 onChanged: (value) {
//                                   controller.selectedIndex.value = value!;
//                                 },
//                               ));
//                         },
//                       ),
//                       Spacer(),

//                       Center(
//                         child: GestureDetector(
//                           onTap: () {
//                             controller.proceedToRemoveAd(
//                                 products[controller.selectedIndex.value]);
//                             controller.recordInAppImpression();
//                             // ComFunction.showInfoDialog(
//                             //     title: "Coming Soon",
//                             //     msg:
//                             //         "In-app purchases are coming soon, offering exciting new features to enhance your experience. Stay tuned!");

//                             FirebaseAnalytics.instance.logAddToWishlist(items: [
//                               AnalyticsEventItem(itemName: "Remove ads")
//                             ]);
//                             FirebaseAnalytics.instance.logSelectContent(
//                                 contentType: "removeAds", itemId: "removeAds1");
//                           },
//                           child: HeartBeat(
//                             child: Container(
//                               margin: EdgeInsets.only(
//                                   bottom: SizeConfig.blockSizeVertical * 2),
//                               height: SizeConfig.blockSizeVertical * 6,
//                               width: SizeConfig.blockSizeHorizontal * 85,
//                               decoration: BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                       // color: Colors.indigoAccent
//                                       //     .withOpacity(0.5), // Shadow color
//                                       spreadRadius: 0, // Spread radius
//                                       blurRadius: 2, // Blur radius
//                                       offset: Offset(2,
//                                           2), // Shadow position: x and y offset
//                                     ),
//                                   ],
//                                   // border: Border.all(color: Colors.indigoAccent),
//                                   gradient: LinearGradient(
//                                       colors: [
//                                         Color(0xFFE03600),
//                                         Color(0xFFFF865C)
//                                       ],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter),
//                                   borderRadius: BorderRadius.circular(
//                                       SizeConfig.blockSizeHorizontal * 8)),
//                               child: Center(
//                                 child: Text(
//                                   "Remove Ads",
//                                   style: TextStyle(
//                                       fontSize:
//                                           SizeConfig.blockSizeHorizontal * 5,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                 } else {
//                   // Handle the case where StoreProduct is null
//                   Get.back();
//                   return Text('Something Went Wrong');
//                 }
//               } else {
//                 // Handle the case where the "remove_ads" offering is not available
//                 Get.back();
//                 return Text('Something Went Wrong');
//               }
//             default:
//               Get.back();

//               return Text(
//                   'Something Went Wrong'); // Handle other unexpected states
//           }
//         },
//       ),
//     );
//   }

//   Widget remove_ads(String text, String image, Color color) {
//     return Padding(
//       padding: EdgeInsets.only(
//           left: SizeConfig.blockSizeHorizontal * 6,
//           top: SizeConfig.blockSizeVertical * 1.5),
//       child: Container(
//         height: SizeConfig.blockSizeVertical * 6,
//         width: SizeConfig.blockSizeHorizontal * 85,
//         padding: EdgeInsets.only(
//           left: SizeConfig.blockSizeHorizontal * 3,
//           right: SizeConfig.blockSizeHorizontal * 4,
//         ),
//         decoration: BoxDecoration(
//             color: Color(0xFF07171D),
//             boxShadow: [
//               BoxShadow(
//                 // color: Colors.amber.withOpacity(0.2), // Shadow color
//                 spreadRadius: 0, // Spread radius
//                 blurRadius: 5, // Blur radius
//                 offset: Offset(2, 2), // Shadow position: x and y offset
//               ),
//             ],
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 5),
//                 bottomRight: Radius.circular(
//                   SizeConfig.blockSizeHorizontal * 5,
//                 ),
//                 topRight: Radius.circular(
//                   SizeConfig.blockSizeHorizontal * 0.5,
//                 ),
//                 bottomLeft: Radius.circular(
//                   SizeConfig.blockSizeHorizontal * 0.5,
//                 ))),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Icon(
//             //   Icons.done,
//             //   color: Colors.amber,
//             // ),
//             // horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
//             Text(
//               text,
//               style: TextStyle(
//                   fontSize: SizeConfig.blockSizeHorizontal * 4,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//             ImageIcon(
//               AssetImage(image),
//               color: color,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
