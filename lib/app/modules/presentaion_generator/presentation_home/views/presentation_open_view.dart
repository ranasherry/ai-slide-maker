import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/views/presentation_edit_view.dart';
import 'package:slide_maker/app/modules/home/my_drawar.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_open_ctl.dart';
import 'package:slide_maker/app/provider/creation_view_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_editing_methods.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_helping_methods.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class PresentationOpenView extends GetView<PresentationOpenCtl> {
  PresentationOpenView({super.key});
  PresentationEditCtl presEditCtl = Get.find();
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
// presEditCtl.initializeSlidesFontList();
// presEditCtl.initializeSlidesTextController();
    return Scaffold(
      // drawer: MyDrawer(),
      // key: _scaffoldKey,
      bottomNavigationBar: Container(
        height: SizeConfig.blockSizeVertical * 7,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            color: AppColors.textfieldcolor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                topRight: Radius.circular(SizeConfig.blockSizeHorizontal * 3))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 1),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // bottom_navi_bar_items(Icons.copy, "Dupicate", () {}),
              bottom_navi_bar_items(Icons.share, "Share", () {
                controller.createPresentation();
              }),
              Obx(() => controller.isOtherUser.value
                  ? Container()
                  : bottom_navi_bar_items(Icons.edit, "Edit", () {
                        presEditCtl.selectTitleOnInit();
                      Get.toNamed(Routes.PresentationEditIndividualSlideView,
                          arguments: [controller.myPresentation.value]);
                      // Get.toNamed(Routes.PresentationEditView,
                      //     arguments: [controller.myPresentation.value]);
                    })),
              // bottom_navi_bar_items(Icons.delete, "Delete", () {
              //   controller.deleteSlide(controller.currentSelectedIndex.value);
              // }),
              // bottom_navi_bar_items(
              //     Icons.published_with_changes_outlined, "Change Template", () {
              //   controller.changePallet();
              // }),
            ],
          ),
        ),
      ),

      // backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 6,
                vertical: SizeConfig.blockSizeVertical * 0),
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            // color: Colors.blue,
            // height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // _scaffoldKey.currentState!.openDrawer();
                    Get.back();
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 5,
                    width: SizeConfig.blockSizeHorizontal * 10,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ),
                Spacer(),
                Obx(() => Container(
                      width: SizeConfig.blockSizeHorizontal * 60,
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 5),
                      child: Text(
                        controller.presentationTitle.value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5),
                      ),
                    )),
                Spacer()
              ],
            ),
          ),
          Container(
              width: SizeConfig.screenWidth,
              // padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.03),
              decoration: BoxDecoration(
                  // color: AppColors.fragmantBGColor,
                  borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(SizeConfig.blockSizeHorizontal * 4),
                      topRight:
                          Radius.circular(SizeConfig.blockSizeHorizontal * 4))),
              child: Obx(() => !controller.myPresentation.value.slides.isEmpty
                  ? Column(
                      children: [
                        Obx(() => controller.isOtherUser.value
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 70,
                                      child: _userProfileBuilder(controller
                                              .myPresentation.value.createrId ??
                                          ""),
                                    ),
                                    _LikedWidgetMethod(
                                        controller.myPresentation.value)
                                  ],
                                ),
                              )
                            : Container()),
                        Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight * 0.45,
                          child: Center(
                            child: Container(
                              // width: SizeConfig.screenWidth * 0.92,
                              height: SizeConfig.screenWidth * 0.5,
                              child: GestureDetector(
                                onTap: (){
                                 presEditCtl.selectTitleOnInit();
                                  Get.toNamed(Routes.PresentationEditIndividualSlideView,
                                  arguments: [controller.myPresentation.value]);
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Obx(
                                      () => individualSlideEditorMethod(
                                          controller.currentSelectedIndex.value,
                                          controller.myPresentation,
                                          Size(SizeConfig.screenWidth * 0.9,
                                              SizeConfig.screenWidth * 0.5),
                                          false,
                                          controller.slidePallet),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Obx(() => Container(
                              height: SizeConfig.blockSizeVertical * 33,
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 2,
                                  bottom: SizeConfig.blockSizeVertical * 2),
                              decoration: BoxDecoration(
                                  color: AppColors.textfieldcolor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          SizeConfig.blockSizeHorizontal * 4),
                                      topLeft: Radius.circular(
                                          SizeConfig.blockSizeHorizontal * 4))),
                              child: GridView.builder(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.blockSizeHorizontal * 5,
                                      right:
                                          SizeConfig.blockSizeHorizontal * 5),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        3, // Number of children in each row
                                    crossAxisSpacing:
                                        10.0, // Spacing between columns
                                    mainAxisSpacing:
                                        10.0, // Spacing between rows
                                    childAspectRatio: (SizeConfig
                                                .blockSizeHorizontal *
                                            85) /
                                        (SizeConfig.blockSizeHorizontal *
                                            45), // Adjust based on the size you want for the items
                                  ),
                                  itemCount: controller
                                      .myPresentation.value.slides.length,
                                  itemBuilder: (context, index) {
                                    Size size = Size(
                                        (SizeConfig.blockSizeHorizontal * 85) /
                                            3, // Width of each grid item
                                        (SizeConfig.blockSizeHorizontal *
                                            45) // Height of each grid item
                                        );
                                    print("hello2");
                                    return GestureDetector(
                                      onTap: () {
                                        presEditCtl.currentSelectedIndex.value =
                                            index;
                                        controller.currentSelectedIndex.value =
                                            index;
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.blockSizeHorizontal * 2),
                                        clipBehavior: Clip.hardEdge,
                                        child: SizedBox(
                                          width: size.width,
                                          height: size.height,
                                          child: Obx(() =>Stack(
                                            children: [
                                              (individualSlideEditorMethod(
                                                  index,
                                                  controller.myPresentation,
                                                  size,
                                                  false,
                                                  controller.slidePallet)),
                                               controller
                                                          .currentSelectedIndex
                                                          .value ==
                                                      index
                                                  ? Container(
                                                      width: size.width,
                                                      height: size.height,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.1)),
                                                      child: Center(
                                                        child:
                                                            Icon(Icons.check),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          )),
                                        ),
                                      ),
                                    );
                                  }),
                            )),
                      ],
                    )
                  : Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.5,
                      child: Center(child: CircularProgressIndicator()),
                    ))),
        ],
      ),
    );
  }

  Widget bottom_navi_bar_items(IconData icon, String text, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            size: SizeConfig.blockSizeHorizontal * 6,
            color: AppColors.mainColor,
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 16,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3,
                        color: AppColors.titles)),
              ),
            ),
          )
        ],
      ),
    );
  }

  FutureBuilder<UserData?> _userProfileBuilder(String userID) {
    log("Opening User: $userID");
    final provider =
        Provider.of<CreationViewProvider>(Get.context!, listen: false);
    return FutureBuilder<UserData?>(
        future: provider.getUserFromID(userID),
        builder: (context, snapshot) {
          UserData user = UserData(
              id: "",
              name: "user1234567",
              email: "",
              revenueCatUserId: "",
              gender: "male",
              joinDate: Timestamp.fromDate(DateTime(2024, 9, 23)));
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Text(""); // Show loading indicator
          } else if (snapshot.hasError) {
            log("Opening User Error: ${snapshot.error}");

            // return Text('error'); // Show error message
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Handle case when user is not found
          } else {
            user = snapshot.data!;
          }

          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.USERPROFILEVIEW, arguments: [user]);
            },
            child: Row(
              children: [
                Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textfieldcolor,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(user.profilePicUrl ??
                            "https://www.strasys.uk/wp-content/uploads/2022/02/Depositphotos_484354208_S.jpg")

                        //  AssetImage(
                        //     AppImages.professional),
                        ),
                  ),
                ),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                Text(
                  // "",
                  "Generated By: ${(user.name ?? 'Anonymous')}",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 3,
                      fontWeight: FontWeight.bold,
                      color: AppColors.background_color,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _LikedWidgetMethod(MyPresentation myPresentation) {
    final provider = Provider.of<CreationViewProvider>(
      Get.context!,
    );

    return Column(
      children: [
        FutureBuilder<bool?>(
            future: provider.isPresentationLikedByUser(
                myPresentation.presentationId.toString()),
            builder: (context, snapshot) {
              bool isLiked = false;
              if (snapshot.connectionState == ConnectionState.waiting) {
                isLiked = false; // Show loading indicator
              } else if (snapshot.hasError) {
                isLiked = false; // Show error message
              } else if (!snapshot.hasData || snapshot.data == null) {
                isLiked = false; // Handle case when user is not found
              } else {
                isLiked = snapshot.data!;
              }
              return Icon(
                Icons.favorite_sharp,
                color: myPresentation.isLiked || isLiked
                    ? AppColors.mainColor
                    : AppColors.textfieldcolor,
              );
            }),
        Text(myPresentation.likesCount.toString(),
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 2.2,
                color: AppColors.background_color,
              ),
            )),
      ],
    );
  }
}
