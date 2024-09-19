import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/nav_bar_view/controller/nav_view_ctl.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class NavView extends GetView<NavCTL> {
  const NavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => Container(
              child: controller.screens[controller.current_index.value],
            )),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            currentIndex: controller.current_index.value,
            selectedLabelStyle: GoogleFonts.aBeeZee(
                textStyle:
                    TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3)),
            unselectedLabelStyle: GoogleFonts.aBeeZee(
                textStyle:
                    TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 2)),
            selectedItemColor: AppColors.mainColor,
            onTap: (index) {
              controller.current_index.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_fill),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                label: 'Explore',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(CupertinoIcons.person_circle),
              //   label: 'Profile',
              // ),
            ],
          );
        }));
  }
}
