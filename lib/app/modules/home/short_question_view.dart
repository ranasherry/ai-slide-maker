import 'package:clipboard/clipboard.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latext/latext.dart';

import 'package:shimmer/shimmer.dart';
import 'package:slide_maker/app/modules/controllers/maths_solver_controller.dart';

import '../../data/response_state.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';

class ShortQuestionView extends GetView<MathsSolverController> {
  ShortQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFE7EBFA),
      appBar: AppBar(
        title: Text(
          'Solved Question',
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

        // backgroundColor: Color(0xFF85C0EB),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              // AppLovinProvider.instance.showInterstitial(() {});
              controller.responseState.value = ResponseState.idle;
              controller.isImageSelected.value = false;
              controller.output.value = "";
              controller.questionText.value = "";

              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
              // height: SizeConfig.blockSizeVertical * 31,
              width: SizeConfig.blockSizeHorizontal * 90,
              child: DottedBorder(
                borderType: BorderType.RRect,
                strokeCap: StrokeCap.round,
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                color: Theme.of(context).colorScheme.primary,
                // dashPattern: [19, 2, 6, 3],
                dashPattern: [6, 1, 8, 11],
                radius: Radius.circular(SizeConfig.blockSizeHorizontal * 4),
                strokeWidth: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.blockSizeHorizontal * 85,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 2,
                                top: SizeConfig.blockSizeVertical * 0.5),
                            child: Text(
                              "Question",
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 6,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                // Color(0xFF202F55)
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 4),
                            child: Obx(() =>
                                    // controller.responseState.value !=
                                    //         ResponseState.waiting
                                    // controller.shimmerEffect.value
                                    // ?
                                    LaTexT(
                                      laTeXCode: Text(
                                        controller.questionText.value,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    )
                                // : ShimmerLoader()
                                ),
                          )
                        ],
                      ),
                    ),
                    verticalSpace(SizeConfig.blockSizeVertical * 2),
                    Container(
                      // height: SizeConfig.blockSizeVertical * 15,
                      width: SizeConfig.blockSizeHorizontal * 85,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.blockSizeHorizontal * 2,
                                    top: SizeConfig.blockSizeVertical * 2),
                                child: Text(
                                  "Answers",
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 6,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    // Color(0xFF0051E3)
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(controller.output.value)
                                      .then((value) {
                                    controller.Toster(
                                        "Copied!", AppColors.Green_color);
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: SizeConfig.blockSizeHorizontal * 2,
                                      top: SizeConfig.blockSizeVertical * 2),
                                  child: Icon(
                                    Icons.copy,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.blockSizeVertical * 2,
                                left: SizeConfig.blockSizeHorizontal * 4),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  )
                                : ShimmerLoader()),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // AppLovinProvider.instance.showInterstitial(() {});
              controller.responseState.value = ResponseState.idle;
              controller.isImageSelected.value = false;
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 15),
              child: Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.blockSizeVertical * 1,
                    top: SizeConfig.blockSizeVertical * 2),
                height: SizeConfig.blockSizeVertical * 6,
                width: SizeConfig.blockSizeHorizontal * 80,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.indigoAccent, Colors.indigo],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 7)),
                child: Center(
                  child: Text(
                    "Other question",
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
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
