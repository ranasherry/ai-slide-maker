// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:slide_maker/app/modules/controllers/settings_view_ctl.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/home_view_ctl.dart';

class MyDrawer extends GetView<SettingsViewCTL> {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        children: [
          _myHeader(),
          GestureDetector(
              onTap: () {
                controller.OpenManageSubscription();
              },
              child:
                  drawer_widgets(Icons.subscriptions_outlined, "Subscription")),
          GestureDetector(
              onTap: () {
                controller
                    .openURL("https://sites.google.com/view/appgeniusx/home");
              },
              child: drawer_widgets(Icons.privacy_tip, "Privacy Policy")),
          kDebugMode
              ? GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.POLLSCREENVIEW);
                  },
                  child: drawer_widgets(Icons.privacy_tip, "Testing"))
              : Container(),
          kDebugMode
              ? GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.PROFILEVIEW);
                  },
                  child: drawer_widgets(
                      Icons.radio_button_checked, "Profle view testing "))
              : Container(),
          // GestureDetector(
          //     onTap: () {
          //       controller
          //           .openURL("https://sites.google.com/view/appgeniusx/home");
          //     },
          //     child: drawer_widgets(Icons.verified, "Rights")),
          GestureDetector(
              onTap: () {
                controller.ShareApp();
              },
              child: drawer_widgets(Icons.share, "Share")),
          GestureDetector(
              onTap: () {
                controller.contactUs();
              },
              child: drawer_widgets(Icons.send, "Contact us")),
          GestureDetector(
              onTap: () {
                HomeViewCtl homeViewCtl = Get.find();
                homeViewCtl.showReviewDialogue(context, isSettings: true);
              },
              child: drawer_widgets(Icons.star, "Rate us")),

          Divider(),

          FirebaseAuth.instance.currentUser != null
              ? GestureDetector(
                  onTap: () {
                    controller.deleteAccount();
                  },
                  child: drawer_widgets(
                    Icons.delete,
                    "Delete Account",
                  ))
              : Container(),
          // verticalSpace(SizeConfig.blockSizeVertical * 1),
          FirebaseAuth.instance.currentUser != null
              // true
              ? GestureDetector(
                  onTap: () {
                    controller.signOut();
                  },
                  child: drawer_widgets(
                    Icons.logout,
                    "Logout",
                  ))
              : GestureDetector(
                  onTap: () {
                    Get.offNamed(Routes.SING_IN);
                  },
                  child: drawer_widgets(
                    Icons.login,
                    "Sign In",
                  )),
        ],
      ),
    );
  }

  Container _myHeader() {
    String name = "Name";
    String userEmail = "user email";
    if (FirebaseAuth.instance.currentUser != null) {
      name = FirebaseAuth.instance.currentUser!.displayName ?? "Name";
      if (name == "") {
        name = 'Name';
      }
      userEmail = FirebaseAuth.instance.currentUser!.email ?? "user email";
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 5,
      ),
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
      height: SizeConfig.screenHeight * 0.15,
      decoration: BoxDecoration(
        // color: AppColors.mainColor,
        gradient: AppColors.mainHeaderGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4), // Shadow color
            spreadRadius: 2, // How much the shadow spreads
            blurRadius: 5, // How soft the shadow is
            offset: Offset(5, 5), // Position of the shadow (x, y)
          ),
        ],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.3,
                child: FittedBox(
                  child: Text(
                    name,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 7,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textfieldcolor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 1.5),
                  height: SizeConfig.blockSizeVertical * 3,
                  // width: SizeConfig.blockSizeHorizontal * 20,
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 7)),
                  child: Center(
                    child: Obx(() => Text(
                          RevenueCatService().currentEntitlement.value ==
                                  Entitlement.free
                              ? "Free Plan"
                              : "Paid Plan",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.grey.shade700),
                        )),
                  ),
                ),
              )
            ],
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 1),
          Text(
            userEmail,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
                color: AppColors.textfieldcolor),
          ),
        ],
      ),
      // padding: EdgeInsets.zero,
      // child: UserAccountsDrawerHeader(
      //   accountName: Text(
      //     "Anonymous",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   accountEmail: Text("muazzamking30@gmail.com"),
      //   // currentAccountPicture: CircleAvatar(
      //   //   backgroundImage: AssetImage('assets/images/user2.png'),
      //   // ),
      //   decoration: BoxDecoration(color: AppColors.textfieldcolor),
      // ),
    );
  }

  Padding drawer_widgets(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Row(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 5,
            width: SizeConfig.blockSizeHorizontal * 10,
            decoration: BoxDecoration(
                color: AppColors.textfieldcolor, shape: BoxShape.circle),
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
          SizedBox(width: SizeConfig.blockSizeHorizontal * 4),
          Expanded(
            child: Container(
              height: SizeConfig.blockSizeVertical * 6,
              decoration: BoxDecoration(
                color: AppColors.textfieldcolor,
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.blockSizeHorizontal * 5),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
