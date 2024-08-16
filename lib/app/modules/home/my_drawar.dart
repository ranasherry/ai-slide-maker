// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
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
          GestureDetector(
              onTap: () {
                controller
                    .openURL("https://sites.google.com/view/appgeniusx/home");
              },
              child: drawer_widgets(Icons.verified, "Rights")),
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

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(25),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.privacy_tip_outlined,
          //             color: Colors.black,
          //             size: 25,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 15),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           padding: EdgeInsets.all(8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "   Privacy Policy",
          //                 style: TextStyle(color: Colors.black, fontSize: 20),
          //               ),
          //               Icon(
          //                 Icons.arrow_forward_ios_outlined,
          //                 color: Colors.black,
          //                 size: 25,
          //               )
          //             ],
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(25),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.running_with_errors_outlined,
          //             color: Colors.black,
          //             size: 25,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 15),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           padding: EdgeInsets.all(8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "   Rights",
          //                 style: TextStyle(color: Colors.black, fontSize: 20),
          //               ),
          //               Icon(
          //                 Icons.arrow_forward_ios_outlined,
          //                 color: Colors.black,
          //                 size: 25,
          //               )
          //             ],
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(25),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.share,
          //             color: Colors.black,
          //             size: 25,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 15),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           padding: EdgeInsets.all(8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "   Share",
          //                 style: TextStyle(color: Colors.black, fontSize: 20),
          //               ),
          //               Icon(
          //                 Icons.arrow_forward_ios_outlined,
          //                 color: Colors.black,
          //                 size: 25,
          //               )
          //             ],
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(25),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.mail_outlined,
          //             color: Colors.black,
          //             size: 25,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 15),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           padding: EdgeInsets.all(8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "   Contact us",
          //                 style: TextStyle(color: Colors.black, fontSize: 20),
          //               ),
          //               Icon(
          //                 Icons.arrow_forward_ios_outlined,
          //                 color: Colors.black,
          //                 size: 25,
          //               )
          //             ],
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(25),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.star_rate_sharp,
          //             color: Colors.black,
          //             size: 25,
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 15),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           padding: EdgeInsets.all(8.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "   Rate us",
          //                 style: TextStyle(color: Colors.black, fontSize: 20),
          //               ),
          //               Icon(
          //                 Icons.arrow_forward_ios_outlined,
          //                 color: Colors.black,
          //                 size: 25,
          //               )
          //             ],
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),

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
          // Padding(
          //   padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Row(
          //       children: [
          //         Container(
          //           height: SizeConfig.blockSizeVertical * 5,
          //           width: SizeConfig.blockSizeHorizontal * 10,
          //           decoration: BoxDecoration(
          //               color: Colors.white, shape: BoxShape.circle),
          //           child: Icon(
          //             Icons.login,
          //             color: Colors.black,
          //           ),
          //         ),
          //         SizedBox(width: SizeConfig.blockSizeHorizontal * 4),
          //         Expanded(
          //           child: Container(
          //             height: SizeConfig.blockSizeVertical * 6,
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(
          //                   SizeConfig.blockSizeHorizontal * 7),
          //             ),
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: SizeConfig.blockSizeHorizontal * 3),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   "Sign in",
          //                   style: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: SizeConfig.blockSizeHorizontal * 5),
          //                 ),
          //                 Icon(
          //                   Icons.arrow_forward_ios_outlined,
          //                   color: Colors.black,
          //                 )
          //               ],
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Container _myHeader() {
    String name = "Name";
    String userEmail = "user email";
    if (FirebaseAuth.instance.currentUser != null) {
      name = FirebaseAuth.instance.currentUser!.displayName ?? "Name";
      userEmail = FirebaseAuth.instance.currentUser!.email ?? "user email";
    }

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5),
      height: SizeConfig.screenHeight * 0.2,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 7,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titles),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: SizeConfig.blockSizeVertical * 4,
                  width: SizeConfig.blockSizeHorizontal * 20,
                  decoration: BoxDecoration(
                      color: AppColors.textfieldcolor,
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
                              color: AppColors.titles),
                        )),
                  ),
                ),
              )
            ],
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          Text(
            userEmail,
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
                color: AppColors.titles),
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
