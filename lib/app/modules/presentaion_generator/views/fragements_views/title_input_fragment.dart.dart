// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/modules/presentaion_generator/controllers/presentaion_generator_controller.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class titleInputFragment extends GetView<PresentaionGeneratorController> {
  const titleInputFragment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: ,

      body: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: AppColors.headerContainerGradient)),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: AppColors.fragmantBGColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The topic of the Presentation',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Write down the short title of the topic of your presentation',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text("Input Field Here.........."),
                    Text(
                      'Number of slides',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'The more slides you choose the more time it will take to generate text and slides',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'drop Down List will appear here...',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Amount of text',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Choose the amount of text that will be generated for each slide',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            footerWidget()
          ],
        ),
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
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                      vertical: SizeConfig.blockSizeVertical),
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockSizeVertical * 6.5,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .buttonBGColor, // Button background color
                          foregroundColor: Colors.white),
                      onPressed: () {},
                      child: Text("Generate a plan")))
            ],
          ),
        ),
      ),
    );
  }
}
