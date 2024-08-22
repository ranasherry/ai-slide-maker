import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_open_ctl.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_helping_methods.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/title_slide.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

import '../controllers/presentation_home_controller.dart';

class PresentationOpenView extends GetView<PresentationOpenCtl> {
  const PresentationOpenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 55),
            // color: Colors.blue,
            // height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.menu_rounded,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                Obx(() => Text(
                      controller.presentationTitle.value,
                      style: TextStyle(fontSize: 20),
                    )),
                Spacer()
              ],
            ),
          ),
          Expanded(
            child: Container(
                width: SizeConfig.screenWidth,
                padding:
                    EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.03),
                decoration: BoxDecoration(
                    // color: AppColors.fragmantBGColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Obx(() => !controller.myPresentation.value.slides.isEmpty
                    ? Obx(() => ListView.builder(
                        itemCount:
                            controller.myPresentation.value.slides.length,
                        itemBuilder: (context, index) {
                          print("hello2");
                          return individualSlideMethod(
                              index, controller.myPresentation);
                        }))
                    : Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight * 0.5,
                        child: Center(child: CircularProgressIndicator()),
                      ))),
          ),
        ],
      ),
    );
  }
}
