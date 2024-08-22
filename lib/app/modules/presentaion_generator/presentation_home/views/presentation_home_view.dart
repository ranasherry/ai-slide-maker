import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/title_slide1.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/title_slide.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

import '../controllers/presentation_home_controller.dart';

class PresentationHomeView extends GetView<PresentationHomeController> {
  const PresentationHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.PRESENTAION_GENERATOR);
        },
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
      ),
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
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.search,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    height: 100,
                    width: 400,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 235, 232, 232),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.deepPurple,
                              size: 65,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  // color: Colors.black87,
                                  child: Text(
                                    "Unlock Slidey Pro",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.deepPurple),
                                  ),
                                ),
                                Container(
                                    width: 200,
                                    // color: Colors.red,
                                    child: Text(
                                      "Up to 30 AI generation per day, up to 12 AI generation slides, Pro styles and much more",
                                      style: TextStyle(color: Colors.grey),
                                    ))
                              ],
                            ),
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
        margin:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 0.5),
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
        SizedBox(
          height: 150,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.all(30),
                  child: Text(
                    "Create your first presentation",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(1),
                  child: Text(
                    "Press plus button to create your first project. it wont take too much time Just Select the template, personalize it and fill the content",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
