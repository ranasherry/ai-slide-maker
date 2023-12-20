import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class HomeView extends GetView<HomeViewCtl> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7EBFA),
      key: controller.scaffoldKey,
      drawer: Drawer(
        width: SizeConfig.blockSizeHorizontal * 75,
        child: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 30,
              color: AppColors.neonBorder,
              child: Image.asset(
                AppImages.drawer,
                scale: 5,
              ),
            ),
            GestureDetector(
                onTap: () {
                  LaunchReview.launch(
                    androidAppId: "com.genius.aislides.generator",
                  );
                },
                child: drawer_widget(Icons.thumb_up, "Rate Us")),
            GestureDetector(
                onTap: () {
                  controller.ShareApp();
                },
                child: drawer_widget(Icons.share, "Share")),
            GestureDetector(
                onTap: () {
                  controller
                      .openURL("https://sites.google.com/view/appgeniusx/home");
                },
                child: drawer_widget(Icons.privacy_tip, "Privacy Policy"))
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFE7EBFA),
        title: Text(
          'Slide Maker',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.MathsSolverView);
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 4),
                      color: Color(0xFF85C0EB),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.scan,
                            scale: 10,
                          ),
                          Text(
                            "Scan & Solve",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Scan the text to solve the question",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.SlideMakerView);
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 20,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 4),
                      color: Color(0xFFFBAE8B),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 2,
                          vertical: SizeConfig.blockSizeVertical * 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.drawer,
                            scale: 8,
                          ),
                          Text(
                            "Slide Maker",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Create slides instantly",
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 3),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
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
            color: AppColors.neonBorder,
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
