import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/style.dart';

import '../controllers/pdf_permission_controller.dart';

class PdfPermissionView extends GetView<PdfPermissionController> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Documents Reader",
              style: StyleSheet.Intro_heading_black,
            ),
            Lottie.asset('assets/lottie/77323-profile-lock.json'),
            Container(
                width: SizeConfig.screenWidth * 0.8,
                child: Text(
                  "Find & open any PDF on your device. Grant file access.",
                  style: TextStyle(
                      color: AppColors.black_color,
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.checkPermission();
                  },
                  child: Container(
                      width: SizeConfig.screenWidth * 0.8,
                      height: SizeConfig.screenWidth * 0.15,
                      child: Center(
                          child: Text(
                        'Allow',
                        style: StyleSheet.Subscription_heading,
                      ))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC20000),
                    // color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }
}
