import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/presentaion_generator_controller.dart';

class PresentaionGeneratorView extends GetView<PresentaionGeneratorController> {
  const PresentaionGeneratorView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('PresentaionGeneratorView'),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          headerWidget(),
          Obx(() => Expanded(
                child: IndexedStack(
                  index: controller.currentIndex.value,
                  children: controller.mainFragments,
                ),
              ))
        ],
      ),
    );
  }

  Align footerWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 5.0, // Set the elevation to the desired value
        margin: EdgeInsets.zero, // Remove default margins if needed
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.15,
          decoration: BoxDecoration(
            color: AppColors.footerContainerColor,
            border: Border(
              top: BorderSide(
                color: const Color.fromARGB(
                    255, 207, 207, 207), // Set the color to grey
                width: 1.0, // Set the width of the border
              ),
            ),
          ),
          child: Column(),
        ),
      ),
    );
  }

  Container headerWidget() {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.30,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.headerContainerGradient)),
    );
  }
}
