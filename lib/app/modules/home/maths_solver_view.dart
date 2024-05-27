import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latext/latext.dart';
import 'package:launch_review/launch_review.dart';

import 'package:shimmer/shimmer.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'package:slide_maker/app/utills/images.dart';
import '../../data/response_state.dart';
import '../../routes/app_pages.dart';

import '../../utills/Gems_rates.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
import '../../utills/style.dart';
import '../controllers/maths_solver_controller.dart';

class MathsSolverView extends GetView<MathsSolverController> {
  MathsSolverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async {
        log("backed");

        return true;
      },
      child: Scaffold(
          // backgroundColor: Color(0xFFE7EBFA), // ? Commented by jamal
          appBar: AppBar(
            title: Text(
              'AI Maths Solver',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
                child: Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 3,
                      left: SizeConfig.blockSizeHorizontal * 3),
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.5,
                ),
                preferredSize: Size.fromHeight(6.0)),
            // backgroundColor: Color(0xFFE7EBFA), // ? Commented by jamal
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )),
            actions: [
              // Obx(() =>
              //     // RevenueCatService().currentEntitlement.value == Entitlement.paid?
              //     //     Container()
              //     //     :
              //     GestureDetector(
              //       onTap: () {
              //         Get.toNamed(Routes.GemsView);
              //       },
              //       child: Row(
              //         children: [
              //           Image.asset(
              //             AppImages.gems,
              //             scale: 30,
              //           ),
              //           Text(
              //             " ${controller.gems.value}",
              //             style: TextStyle(color: Colors.black),
              //           ),
              //           SizedBox(
              //             width: SizeConfig.screenWidth * 0.03,
              //           )
              //         ],
              //       ),
              //     ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   // height: 60,
                //   // color: Colors.amber,
                //   child: Center(
                //     child: MaxAdView(
                //         adUnitId: AppStrings.MAX_BANNER_ID,
                //         adFormat: AdFormat.banner,
                //         listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                //           print(
                //               'Banner widget ad loaded from ' + ad.networkName);
                //         }, onAdLoadFailedCallback: (adUnitId, error) {
                //           print(
                //               'Banner widget ad failed to load with error code ' +
                //                   error.code.toString() +
                //                   ' and message: ' +
                //                   error.message);
                //         }, onAdClickedCallback: (ad) {
                //           print('Banner widget ad clicked');
                //         }, onAdExpandedCallback: (ad) {
                //           print('Banner widget ad expanded');
                //         }, onAdCollapsedCallback: (ad) {
                //           print('Banner widget ad collapsed');
                //         })),
                //   ),
                // ),

                // Obx(() {
                //   if (RevenueCatService().currentEntitlement.value ==
                //       Entitlement.paid) {
                //     return Container(); // Return an empty container for paid users
                //   } else {
                //     return Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: MaxAdView(
                //         adUnitId: Platform.isAndroid
                //             ? AppStrings.MAX_BANNER_ID
                //             : AppStrings.IOS_MAX_BANNER_ID,
                //         adFormat: AdFormat.banner,
                //         listener: AdViewAdListener(
                //           onAdLoadedCallback: (ad) {
                //             print('Banner widget ad loaded from ' +
                //                 ad.networkName);
                //           },
                //           onAdLoadFailedCallback: (adUnitId, error) {
                //             print(
                //                 'Banner widget ad failed to load with error code ' +
                //                     error.code.toString() +
                //                     ' and message: ' +
                //                     error.message);
                //           },
                //           onAdClickedCallback: (ad) {
                //             print('Banner widget ad clicked');
                //           },
                //           onAdExpandedCallback: (ad) {
                //             print('Banner widget ad expanded');
                //           },
                //           onAdCollapsedCallback: (ad) {
                //             print('Banner widget ad collapsed');
                //           },
                //         ),
                //       ),
                //     );
                //   }
                // }),

                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  child: SingleChildScrollView(
                      child:
                          // controller.responseState.value == ResponseState.idle
                          _imagePickerView(context)),
                ),
              ],
            ),
          )),
    );
  }

  Column _questionSolvedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.screenHeight * 0.02,
        ),
        // Image.file(
        //   // File(controller.selectedImage!.path),
        //   File(controller.selectedImagePath.value),
        //   // controller.selectedImage!,
        //   height: 200,
        //   width: 200,
        //   fit: BoxFit.cover,
        // ),

        // SizedBox(
        //   height: SizeConfig.screenHeight * 0.02,
        // ),
        Container(
            // padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2,vertical: SizeConfig.blockSizeVertical),
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 2,
                vertical: SizeConfig.blockSizeVertical),
            child: DottedBorder(
              borderType: BorderType.RRect,
              strokeCap: StrokeCap.round,
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
              color: Color(0xFF0049C8),
              // dashPattern: [19, 2, 6, 3],
              dashPattern: [6, 1, 8, 11],
              radius: Radius.circular(SizeConfig.blockSizeHorizontal * 4),
              strokeWidth: 2,

              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 2,
                    vertical: SizeConfig.blockSizeVertical),

                // margin: EdgeInsets.only(
                //   top: SizeConfig.blockSizeVertical * 2,
                // ),
                // height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 92,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: AppColors.icon_color),
                ),
                // decoration: BoxDecoration(
                //     color: AppColors.buttonColor,
                //     borderRadius:
                //         BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3),
                //     border: Border.all(color: Color(0xFF05284B))),
                child: Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 1),
                        child: Icon(
                          Icons.chrome_reader_mode,
                          size: SizeConfig.blockSizeHorizontal * 6,
                          color: Color(0xFF202F55),
                        ),
                      ),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                      Text(
                        "Solution",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0051E3)),
                      ),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 50),
                      GestureDetector(
                        onTap: () {
                          // controller.reshuffle(context);
                          controller.responseState.value = ResponseState.idle;
                        },
                        child: Icon(
                          Icons.repeat,
                          size: SizeConfig.blockSizeHorizontal * 7,
                          color: Color(0xFF202F55),
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                    child: Obx(() => controller.responseState.value !=
                            ResponseState.waiting
                        // controller.shimmerEffect.value
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: LaTexT(
                              laTeXCode: Text(
                                controller.output.value,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        // TeXView(
                        //     child: TeXViewColumn(children: [
                        //       // TeXViewDocument("5y^2+\frac{7}{5} + 5y^2-\frac{48}{5} - 2\sqrt{(5y^2+\frac{7}{5})(5y^2-\frac{48}{5})} = 1")
                        //       // TeXViewDocument(r"\[5y^2 + \frac{7}{5} + 5y^2 - \frac{48}{5} - 2\sqrt{(5y^2 + \frac{7}{5})(5y^2 - \frac{48}{5})} = 1\]")
                        //       TeXViewDocument("${controller.output.value}",
                        //           style: TeXViewStyle(contentColor: Colors.white))
                        //     ]),
                        //     loadingWidgetBuilder: (context) => ShimmerLoader(),
                        //   )
                        // Text(
                        //     "${controller.output.value}",
                        //     style: TextStyle(
                        //         fontSize:
                        //             SizeConfig.blockSizeHorizontal *
                        //                 4,
                        //         color: Colors.white),
                        //   )
                        : ShimmerLoader()),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     right: SizeConfig.blockSizeHorizontal * 2,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       // GestureDetector(
                  //       //   onTap: () {
                  //       //     // controller.copyText();
                  //       //   },
                  //       //   child: Icon(
                  //       //     Icons.copy,
                  //       //     size:
                  //       //         SizeConfig.blockSizeHorizontal * 7,
                  //       //     color: Colors.white,
                  //       //   ),
                  //       // ),
                  //       // horizontalSpace(
                  //       //     SizeConfig.blockSizeHorizontal * 4),
                  //       // GestureDetector(
                  //       //   onTap: () {
                  //       //     // controller.shareText();
                  //       //   },
                  //       //   child: Icon(
                  //       //     Icons.ios_share,
                  //       //     size:
                  //       //         SizeConfig.blockSizeHorizontal * 7,
                  //       //     color: Colors.white,
                  //       //   ),
                  //       // ),
                  //       horizontalSpace(
                  //           SizeConfig.blockSizeHorizontal * 4),
                  //       GestureDetector(
                  //         onTap: () {
                  //           // controller.reshuffle(context);
                  //           controller.responseState.value=ResponseState.idle;
                  //         },
                  //         child: Icon(
                  //           Icons.repeat,
                  //           size:
                  //               SizeConfig.blockSizeHorizontal * 7,
                  //           color: Colors.white,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )
                  GestureDetector(
                    onTap: () {
                      // controller.reshuffle(context);
                      // controller.responseState.value=ResponseState.idle;
                      // FlutterClipboard.copy(controller.output.value)
                      //     .then((value) => print('copied'));
                      FlutterClipboard.copy(controller.output.value)
                          .then((value) {
                        controller.Toster("Copied!", AppColors.Green_color);
                      });
                    },
                    child: Container(
                      //         decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //    border: Border.all(color: AppColors.icon_color)
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.copy,
                            size: SizeConfig.blockSizeHorizontal * 7,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.02,
                          ),
                          Text(
                            "Copy",
                            style: StyleSheet.Intro_Sub_heading,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            )),
      ],
    );
  }

  Shimmer ShimmerLoader() {
    return Shimmer.fromColors(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 65),
            preview_effect(SizeConfig.blockSizeHorizontal * 30),
          ],
        ),
        baseColor: Colors.grey.shade600,
        highlightColor: Colors.white);
  }

  Column _imagePickerView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   margin: EdgeInsets.symmetric(
        //       horizontal: SizeConfig.blockSizeHorizontal * 3),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       border: Border.all(color: AppColors.icon_color)),
        //   // child: Padding(
        //   //   padding: EdgeInsets.symmetric(
        //   //       horizontal: SizeConfig.blockSizeHorizontal * 5,
        //   //       vertical: SizeConfig.blockSizeHorizontal * 2),
        //   //   // child: Text(
        //   //   //   "Please select an image of a math problem to get the solution.",
        //   //   //   style: TextStyle(
        //   //   //     color: Colors.white,
        //   //   //     fontSize: 20,
        //   //   //   ),
        //   //   //   textAlign: TextAlign.center,
        //   //   // ),
        //   // ),
        // ),

        // SizedBox(
        //   height: SizeConfig.screenHeight * 0.05,
        // ), // ? Commented by jamal
        // Show the selected image preview if available
        Obx(() =>
            // controller.selectedImage != null &&
            controller.isImageSelected.value
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    strokeCap: StrokeCap.round,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 4),
                    color: Theme.of(context).colorScheme.primary,
                    // Color(0xFF0049C8),
                    // dashPattern: [19, 2, 6, 3],
                    dashPattern: [6, 1, 8, 11],
                    radius: Radius.circular(SizeConfig.blockSizeHorizontal * 4),
                    strokeWidth: 2,
                    child: Image.file(
                      // File(controller.selectedImage!.path),
                      File(controller.selectedImagePath.value),
                      // controller.selectedImage!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container()),

        SizedBox(
          height: SizeConfig.screenHeight * 0.03,
        ),
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 6),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Quick Access",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 6,
              bottom: SizeConfig.blockSizeVertical * 2),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Convenient to solve more exercise",
                style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                controller.valid(ImageSource.camera);
              },
              child: card_widgets(Color(0xFFD6F5FF), Color(0xFFA2E2FE),
                  AppImages.scan, "Scan & Solve"),
            ),
            GestureDetector(
              onTap: () {
                controller.getImage(ImageSource.gallery);
                controller.valid(ImageSource.gallery);
              },
              child: card_widgets(Color(0xFFF8EDFE), Color(0xFFEAC0FF),
                  AppImages.gallery, "Gallery"),
            )
            // GestureDetector(
            //   onTap: () {
            //     // controller.getImage(ImageSource.camera);
            //     controller.valid(ImageSource.camera);
            //   },
            //   child: Container(
            //     height: SizeConfig.blockSizeVertical * 20,
            //     width: SizeConfig.blockSizeHorizontal * 40,
            //     decoration: BoxDecoration(
            //       borderRadius:
            //           BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
            //       color: Color(0xFF85C0EB),
            //     ),
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(
            //           horizontal: SizeConfig.blockSizeHorizontal * 2,
            //           vertical: SizeConfig.blockSizeVertical * 1),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Image.asset(
            //             AppImages.scan,
            //             scale: 10,
            //           ),
            //           Text(
            //             "Scan & Solve",
            //             style: TextStyle(
            //                 fontSize: SizeConfig.blockSizeHorizontal * 4.5,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //           Text(
            //             "Scan the text to solve the question",
            //             style: TextStyle(
            //                 fontSize: SizeConfig.blockSizeHorizontal * 3),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     controller.getImage(ImageSource.gallery);
            //     controller.valid(ImageSource.gallery);
            //   },
            //   child: Container(
            //     height: SizeConfig.blockSizeVertical * 20,
            //     width: SizeConfig.blockSizeHorizontal * 40,
            //     decoration: BoxDecoration(
            //       borderRadius:
            //           BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
            //       color: Color(0xFFFBAE8B),
            //     ),
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(
            //           horizontal: SizeConfig.blockSizeHorizontal * 2,
            //           vertical: SizeConfig.blockSizeVertical * 1),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Image.asset(
            //             AppImages.gallery,
            //             scale: 10,
            //           ),
            //           Text(
            //             "Gallery",
            //             style: TextStyle(
            //                 fontSize: SizeConfig.blockSizeHorizontal * 4.5,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //           Text(
            //             "Pick image from gallery",
            //             style: TextStyle(
            //                 fontSize: SizeConfig.blockSizeHorizontal * 3),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.03,
        ),

        GestureDetector(
          onTap: () {
            controller.showDialogBox(context);
          },
          child: DottedBorder(
              borderType: BorderType.RRect,
              strokeCap: StrokeCap.round,
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
              color: Theme.of(context).colorScheme.primary,
              // Color(0xFF91B6D8),
              // dashPattern: [19, 2, 6, 3],
              dashPattern: [6, 1, 8, 11],
              radius: Radius.circular(SizeConfig.blockSizeHorizontal * 4),
              strokeWidth: 2,
              child: Container(
                height: SizeConfig.blockSizeVertical * 18,
                width: SizeConfig.blockSizeHorizontal * 85,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 4)),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 3,
                      top: SizeConfig.blockSizeVertical * 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Short Question",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            // Color(0xFF202965),
                            fontSize: SizeConfig.blockSizeHorizontal * 5,
                            fontWeight: FontWeight.bold),
                      ),
                      verticalSpace(SizeConfig.blockSizeVertical * 4),
                      Row(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Container(
                                  height: 1.5,
                                  width: SizeConfig.blockSizeHorizontal * 66,
                                  color: Theme.of(context).colorScheme.primary,
                                  // Color(0xFFCBCCDB),
                                ),
                              ),
                              verticalSpace(SizeConfig.blockSizeVertical * 3),
                              Center(
                                child: Container(
                                  height: 1.5,
                                  width: SizeConfig.blockSizeHorizontal * 60,
                                  color: Theme.of(context).colorScheme.primary,
                                  // Color(0xFFCBCCDB),
                                ),
                              )
                            ],
                          ),
                          Image.asset(
                            AppImages.pencil,
                            scale: 10,
                            color: Theme.of(context).colorScheme.primary,
                            // Color(0xFF00598D),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ),
        verticalSpace(SizeConfig.blockSizeVertical * 2),
        Obx(() =>
            // controller.selectedImage != null &&
            controller.isImageSelected.value
                ? GestureDetector(
                    onTap: () async {
                      // if (controller.gems.value > 0) {
                      Get.toNamed(Routes.ShortQuestionView);
                      // controller.sendMessage(controller.res.value);
                      // if (controller.gems.value < GEMS_RATE.MATH_GEMS_RATE) {
                      //   //TODO: Route to Coins Page
                      //   Get.toNamed(Routes.GemsView);

                      //   controller.Toster("You Dont have enough Gems",
                      //       AppColors.Electric_Blue_color);
                      // } else {
                      //   controller
                      //       .uploadImageToFirebase(controller.selectedImage!);
                      // }
                      controller
                          .uploadImageToFirebase(controller.selectedImage!);
                      // } else {
                      //   controller.Toster("No More Gems Available",
                      //       AppColors.Electric_Blue_color);
                      // }
                      // AppLovinProvider.instance.showRewardedAd((){});

                      // }else{
                      //   controller.showNoRewarded();
                      // }
                    },
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 7,
                      width: SizeConfig.blockSizeHorizontal * 70,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.indigoAccent, Colors.indigo],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //     width: SizeConfig.blockSizeHorizontal *
                          //         16), // Add some spacing between the icon and text
                          Text(
                            "Solve This Problem",
                            style: TextStyle(fontSize: 16),
                          ),
                          // Row(
                          //   children: [
                          //     Image.asset(
                          //       AppImages.gems,
                          //       scale: 30,
                          //     ),
                          //     Text(
                          //       " ${GEMS_RATE.MATH_GEMS_RATE} )",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     SizedBox(
                          //       width: SizeConfig.screenWidth * 0.03,
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  )
                : Container()),
        verticalSpace(SizeConfig.blockSizeVertical * 2)
      ],
    );
  }

  // Column _imagePickerView() {
  //   return Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [

  //               Padding(
  //                 padding:  EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5),
  //                 child: Text(
  //                 "Please select an image of a math problem to get the solution.",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 20,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               ),

  //               SizedBox(height: SizeConfig.screenHeight *0.05,),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton(
  //         onPressed: () {
  //           controller.getImage(ImageSource.gallery);
  //         },
  //         style: ElevatedButton.styleFrom(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //           ),
  //           elevation: 5.0,
  //           shadowColor: Colors.grey,
  //         ),
  //         child:
  //         Padding(
  //           padding: EdgeInsets.all(SizeConfig.screenWidth * 0.03),
  //           child: Column(
  //             children: [
  //               Icon(Icons.image),
  //               Text('Gallery'),
  //             ],
  //           ),
  //         ),
  //         // Text('Gallery'),
  //       ),
  //                   ElevatedButton(
  //         onPressed: () {
  //           controller.getImage(ImageSource.camera);
  //         },
  //         style: ElevatedButton.styleFrom(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //           ),
  //           elevation: 5.0,
  //           shadowColor: Colors.grey,
  //         ),
  //         child:
  //         Padding(
  //           padding: EdgeInsets.all(SizeConfig.screenWidth * 0.03),
  //           child: Column(
  //             children: [
  //               Icon(Icons.camera_alt_rounded),
  //               Text('Camera'),
  //             ],
  //           ),
  //         ),
  //         // Text('Camera'),
  //       ),
  //                 ],
  //               ),
  //               SizedBox(height: SizeConfig.screenHeight *0.03,),

  //           ],
  //         );
  // }

  Container preview_effect(double width) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 0.5,
          bottom: SizeConfig.blockSizeVertical * 0.5),
      height: SizeConfig.blockSizeVertical * 1,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3)),
    );
  }

  Container _slidingImages() {
    return Container(
        // color: Colors.orange,
        child: CarouselSlider(
      options: CarouselOptions(
          height: SizeConfig.screenHeight * 0.4,
          aspectRatio: 16 / 9,
          // viewportFraction: 1,
          autoPlay: true), // width: SizeConfig.blockSizeHorizontal * 100,
      // height: SizeConfig.blockSizeVertical * 20,
      items: controller.imgList
          .map((item) => Container(
                // padding: EdgeInsets.symmetric(
                //     horizontal: SizeConfig.blockSizeHorizontal * 2),
                width: SizeConfig.blockSizeHorizontal * 90,
                child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(item)
                        // CachedNetworkImage(
                        //   imageUrl: item,
                        //   // width: SizeConfig.blockSizeHorizontal * 90,
                        //   placeholder: (context, url) => CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) => Icon(Icons.error),
                        // ),

                        // Image.network(
                        //   item,
                        //   fit: BoxFit.cover,
                        //   // height: SizeConfig.blockSizeVertical * 20,
                        //   width: SizeConfig.blockSizeHorizontal * 90,
                        // ),
                        )),
              ))
          .toList(),
    ));
  }

  Padding drawer_widget(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 5,
          top: SizeConfig.blockSizeVertical * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: SizeConfig.blockSizeHorizontal * 7,
            color: Color(0xFF00C3EC),
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 12),
          Text(
            text,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
