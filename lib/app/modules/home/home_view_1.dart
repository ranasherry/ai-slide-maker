import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/home/my_drawar.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'package:slide_maker/app/utills/helprer_widgets/main_header_bg.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class HomeView1 extends GetView<HomeViewCtl> {
  const HomeView1({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      bottomNavigationBar: AppLovinProvider.instance.MyBannerAdWidget(),
      drawer: MyDrawer(),
      key: _scaffoldKey,
      // backgroundColor: AppColors.mainColor,
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Stack(
          children: [
            MainHeaderBG(
              height: SizeConfig.blockSizeVertical * 35,
              width: SizeConfig.screenWidth,
            ),
            Positioned(
              top: SizeConfig.blockSizeVertical * 4,
              left: SizeConfig.blockSizeHorizontal * 4,
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: Container(
                    height: SizeConfig.blockSizeVertical * 5,
                    width: SizeConfig.blockSizeHorizontal * 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notes,
                      color: AppColors.textfieldcolor,
                    )),
              ),
            ),
            Positioned(
              top: SizeConfig.blockSizeVertical * 4,
              left: SizeConfig.blockSizeHorizontal * 76,
              child: Row(
                children: [
                  Obx(() => RevenueCatService().currentEntitlement.value ==
                          Entitlement.free
                      ? Container(
                          height: SizeConfig.blockSizeVertical * 4,
                          width: SizeConfig.blockSizeHorizontal * 8,
                          child: GestureDetector(
                              onTap: () {
                                if (RevenueCatService()
                                        .currentEntitlement
                                        .value ==
                                    Entitlement.free) {
                                  // Get.toNamed(
                                  //   Routes.NEWINAPPPURCHASEVIEW,
                                  // );
                                  RevenueCatService().GoToPurchaseScreen();
                                }
                              },
                              child: Image.asset(
                                AppImages.vip,
                                // scale: 1.8,
                              )))
                      : Container()),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.SettingsView);
                    },
                    child: Container(
                        height: SizeConfig.blockSizeVertical * 4,
                        width: SizeConfig.blockSizeHorizontal * 8,
                        child: Image.asset(AppImages.setting)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 10),
              child: slide_header_name(),
            ),
            Positioned(
              top: SizeConfig.blockSizeVertical *
                  20, // Position for the first line
              left: SizeConfig.blockSizeHorizontal * 23,
              child: RichText(
                textAlign: TextAlign.center, // Center align the text block
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Your Presentation is\n", // First line
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 6,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textfieldcolor,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: "a Click Ahead", // Second line
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 6,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textfieldcolor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.blockSizeVertical * 33,
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(SizeConfig.blockSizeHorizontal * 4),
                        topRight: Radius.circular(
                            SizeConfig.blockSizeHorizontal * 4))),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 2),
                  child: Column(
                    children: [
                      verticalSpace(SizeConfig.blockSizeVertical * 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Slide beta Screen
                                  Get.toNamed(Routes.PRESENTAION_GENERATOR);
                                },
                                child: Container(
                                  height: SizeConfig.blockSizeVertical * 22.5,
                                  width: SizeConfig.blockSizeHorizontal * 45,
                                  decoration: BoxDecoration(
                                      color: AppColors.textfieldcolor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.2), // Shadow color
                                          spreadRadius:
                                              2, // How much the shadow spreads
                                          blurRadius:
                                              10, // How soft the shadow is
                                          offset: Offset(4,
                                              4), // Position of the shadow (x, y)
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.blockSizeHorizontal * 3)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        AppImages.slide_beta,
                                        scale: 1.3,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            SizeConfig.blockSizeHorizontal * 40,
                                        child: Text(
                                          "Presentation AI 2.0",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      3.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF585858))),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: SizeConfig.blockSizeHorizontal * 25.3,
                                bottom: SizeConfig.blockSizeVertical * 13.3,
                                child: Container(
                                    child: Image.asset(AppImages.new_version)),
                              )
                            ],
                          ),
                          // modules(
                          //     AppImages.slide_beta, "AI Slider Maker GEN 2.0"),
                          GestureDetector(
                              onTap: () {
                                // AI Assistant Screen
                                Get.toNamed(Routes.AiSlideAssistant);
                              },
                              child: modules(
                                  AppImages.magic_stick, "AI Assistant")),
                        ],
                      ),
                      verticalSpace(SizeConfig.blockSizeVertical * 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () {
                                // Book Writer Screen
                                if (RevenueCatService()
                                        .currentEntitlement
                                        .value ==
                                    Entitlement.paid) {
                                  Get.toNamed(Routes.BOOK_WRITER);
                                } else {
                                  RevenueCatService().GoToPurchaseScreen();
                                }
                              },
                              child: modules(AppImages.book, "Book Writer",
                                  isPremium: true)),
                          GestureDetector(
                              onTap: () {
                                // AI Slide Maker Screen
                                Get.toNamed(Routes.NEWSLIDE_GENERATOR);
                              },
                              child:
                                  modules(AppImages.slide, "Presentation AI")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container modules(String image, String text, {bool isPremium = false}) {
    return Container(
      height: SizeConfig.blockSizeVertical * 22.5,
      width: SizeConfig.blockSizeHorizontal * 45,
      decoration: BoxDecoration(
          color: AppColors.textfieldcolor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color
              // color: Colors.orange.withOpacity(0.3), // Shadow color
              spreadRadius: 2, // How much the shadow spreads
              blurRadius: 10, // How soft the shadow is
              offset: Offset(4, 4), // Position of the shadow (x, y)
            ),
          ],
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3)),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  image,
                  scale: 1.3,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: SizeConfig.blockSizeHorizontal * 40,
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF585858))),
                ),
              ),
            ],
          ),
          isPremium
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      width: SizeConfig.blockSizeHorizontal * 5.5,
                      height: SizeConfig.blockSizeHorizontal * 5.5,
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 1,
                          vertical: SizeConfig.blockSizeHorizontal * 1),
                      child: Image.asset(AppImages.vip)),
                )
              : Container(),
        ],
      ),
    );
  }
}
