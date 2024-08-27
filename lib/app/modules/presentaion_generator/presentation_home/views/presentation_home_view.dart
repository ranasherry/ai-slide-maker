import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/home/my_drawar.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/remoteconfig_services.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/title_slide.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

import '../controllers/presentation_home_controller.dart';

class PresentationHomeView extends GetView<PresentationHomeController> {
  PresentationHomeView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      key: _scaffoldKey,
      // backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.PRESENTAION_GENERATOR);
        },
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          size: SizeConfig.blockSizeHorizontal * 7,
          color: AppColors.textfieldcolor,
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 4,
                vertical: SizeConfig.blockSizeVertical * 6),
            // color: Colors.blue,
            // height: 120,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 5,
                    width: SizeConfig.blockSizeHorizontal * 10,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      Icons.notes,
                      color: Colors.black,
                      size: SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 27),
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                    ),
                  ),
                ),
                // Container(
                //   height: SizeConfig.blockSizeVertical * 5,
                //   width: SizeConfig.blockSizeHorizontal * 10,
                //   decoration: BoxDecoration(
                //       color: Colors.white, shape: BoxShape.circle),
                //   child: Icon(
                //     Icons.search,
                //     size: SizeConfig.blockSizeHorizontal * 8,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 14,
                    width: SizeConfig.blockSizeHorizontal * 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 5),
                      color: AppColors.textfieldcolor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: SizeConfig.blockSizeVertical * 8,
                          width: SizeConfig.blockSizeHorizontal * 16,
                          decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.filter_alt_outlined,
                            color: AppColors.mainColor,
                            size: SizeConfig.blockSizeHorizontal * 10,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Text(
                                  "Unlock ${RCVariables.AppName.value} pro",
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 5,
                                        color: AppColors.mainColor),
                                  )),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 0.5),
                                width: SizeConfig.blockSizeHorizontal * 55,
                                // color: Colors.red,
                                child: Text(
                                    "Up to 30 AI generation per day, up to 12 AI generation slides, Pro styles and much more",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3),
                                    )))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() => controller.presentations.isEmpty
                    ? _noPreviousSlideAvailable()
                    : Container(
                        child: Expanded(
                          child: ListView.builder(
                              itemCount: controller.presentations.length,
                              itemBuilder: (context, index) {
                                return _histroySlideItem(index);
                              }),
                        ),
                      )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _histroySlideItem(int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.PresentationOpenView,
            arguments: [controller.presentations[index]]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical * 0.5,
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 4),
        height: SizeConfig.blockSizeVertical * 10,
        width: SizeConfig.blockSizeHorizontal * 60,
        decoration: BoxDecoration(
            color: AppColors.textfieldcolor,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 7)),
        child: Row(
          children: [
            Container(
                height: SizeConfig.blockSizeVertical * 7,
                width: SizeConfig.blockSizeHorizontal * 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 3)),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3),
                  child: TitleSlide1(
                    mySlide: controller.presentations[index].slides[0],
                    slidePallet: palletList[palletList.indexWhere((element) =>
                                    int.parse(controller
                                        .presentations[index].styleId) ==
                                    element.id) !=
                                -1
                            ? palletList.indexWhere((element) =>
                                int.parse(
                                    controller.presentations[index].styleId) ==
                                element.id)
                            : 0 // Return 0 if not found
                        ],
                    size: Size(SizeConfig.blockSizeHorizontal * 25,
                        SizeConfig.blockSizeVertical * 7),
                  ),
                )),
            horizontalSpace(SizeConfig.blockSizeHorizontal * 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${controller.presentations[index].presentationTitle}",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titles)),
                ),
                verticalSpace(SizeConfig.blockSizeVertical * 0.5),
                Text(
                  controller.formatDate(DateTime.fromMillisecondsSinceEpoch(
                      controller.presentations[index].timestamp)),
                  // "${controller.presentations[index].timestamp}",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 3,
                          color: AppColors.titles)),
                ),
                verticalSpace(SizeConfig.blockSizeVertical * 0.75),
              ],
            ),
            Spacer(),
            GestureDetector(onTap: () {}, child: Icon(Icons.more_vert))
          ],
        ),
      ),
    );
  }

  Column _noPreviousSlideAvailable() {
    return Column(
      children: [
        verticalSpace(SizeConfig.blockSizeVertical * 20),
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
            child: Column(
              children: [
                Container(
                  child: Text("Create your first presentation",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 10,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  child: Text(
                      "Press plus button to create your first project. it wont take too much time Just Select the template, personalize it and fill the content",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5,
                            color: Colors.grey.shade600),
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
