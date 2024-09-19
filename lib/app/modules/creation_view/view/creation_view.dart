import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_maker/app/data/my_firebase_user.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/modules/creation_view/controller/creation_view_ctl.dart';
import 'package:slide_maker/app/provider/creation_view_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_helping_methods.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class CreationView extends GetView<CreationViewCtl> {
  CreationView({super.key});

  // Rx<MyPresentation> dummyPres = MyPresentation(
  //         presentationId: 1,
  //         presentationTitle: "Dummy Title",
  //         slides: <MySlide>[
  //           MySlide(
  //               slideTitle: "Solar Flair",
  //               slideSections: [
  //                 SlideSection(sectionHeader: "Tile", sectionContent: "Solar")
  //               ],
  //               slideType: SlideType.title)
  //         ].obs,
  //         styleId: "1".obs,
  //         createrId: "12",
  //         timestamp: 122344,
  //         likesCount: 0,
  //         commentsCount: 0)
  //     .obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4),
              height: SizeConfig.blockSizeVertical * 6,
              width: SizeConfig.blockSizeHorizontal * 90,
              decoration: BoxDecoration(
                  color: AppColors.textfieldcolor,
                  borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 8)),
              child: Consumer<CreationViewProvider>(
                builder: (context, controller, child) {
                  return TextField(
                    onChanged: (value) {
                      // Trigger search on term change
                      // controller.searchPresentation(value);
                    },
                    onSubmitted: (value) {
                      controller.searchPresentation(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.grey.shade500)),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade500,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 8),
                          borderSide: BorderSide.none),
                    ),
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            color: AppColors.background_color)),
                  );
                },
              ),
            ),
          ),

          verticalSpace(SizeConfig.blockSizeVertical * 3),

          // Expanded(
          //   child: StaggeredGridView.countBuilder(
          //     crossAxisCount: 2,
          //     itemCount: 10,
          //     itemBuilder: (context, index) => Obx(() {
          //       return Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(
          //               SizeConfig.blockSizeHorizontal * 4),
          //         ),
          //         child: controller.isLoading.value
          //             ? Shimmer.fromColors(
          //                 baseColor: AppColors.textfieldcolor,
          //                 highlightColor: Colors.grey.shade200,
          //                 direction: ShimmerDirection.ltr,
          //                 child: Stack(
          //                   children: [
          //                     ClipRRect(
          //                       borderRadius: BorderRadius.circular(
          //                           SizeConfig.blockSizeHorizontal * 4),
          //                       child: Container(
          //                         color: AppColors.textfieldcolor,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             : Stack(
          //                 children: [
          //                   ClipRRect(
          //                     borderRadius: BorderRadius.circular(
          //                         SizeConfig.blockSizeHorizontal * 4),
          //                     child: individualSlideMethod(
          //                         0,
          //                         dummyPres,
          //                         Size(SizeConfig.blockSizeHorizontal * 46,
          //                             SizeConfig.blockSizeVertical * 50)),
          //                   ),
          //                   Positioned(
          //                     top: SizeConfig.blockSizeVertical * 0,
          //                     left: SizeConfig.blockSizeHorizontal * 2,
          //                     right: SizeConfig.blockSizeHorizontal * 2,
          //                     child: Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Image.asset(
          //                           AppImages.hot,
          //                           scale: 1.5,
          //                         ),
          //                         Column(
          //                           children: [
          //                             Icon(
          //                               Icons.favorite_sharp,
          //                               color: AppColors.textfieldcolor,
          //                             ),
          //                             Text("223",
          //                                 style: GoogleFonts.roboto(
          //                                   textStyle: TextStyle(
          //                                     fontSize: SizeConfig
          //                                             .blockSizeHorizontal *
          //                                         2.2,
          //                                     color: AppColors.background_color,
          //                                   ),
          //                                 )),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Positioned(
          //                     bottom: SizeConfig.blockSizeVertical * 0.1,
          //                     left: SizeConfig.blockSizeHorizontal * 2,
          //                     right: SizeConfig.blockSizeHorizontal * 3.5,
          //                     child: Row(
          //                       children: [
          //                         Container(
          //                           height: SizeConfig.blockSizeVertical * 5,
          //                           width: SizeConfig.blockSizeHorizontal * 10,
          //                           decoration: BoxDecoration(
          //                             shape: BoxShape.circle,
          //                             color: AppColors.textfieldcolor,
          //                             image: DecorationImage(
          //                               image:
          //                                   AssetImage(AppImages.professional),
          //                             ),
          //                           ),
          //                         ),
          //                         horizontalSpace(
          //                             SizeConfig.blockSizeHorizontal * 2),
          //                         Text(
          //                           "Name",
          //                           style: GoogleFonts.inter(
          //                             textStyle: TextStyle(
          //                               fontSize:
          //                                   SizeConfig.blockSizeHorizontal * 3,
          //                               fontWeight: FontWeight.bold,
          //                               color: AppColors.background_color,
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //       );
          //     }),
          //     staggeredTileBuilder: (int index) =>
          //         StaggeredTile.count(1, index.isOdd ? 0.6 : 0.7),
          //     mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
          //     crossAxisSpacing: SizeConfig.blockSizeVertical * 1,
          //     padding: EdgeInsets.symmetric(
          //       horizontal: SizeConfig.blockSizeHorizontal * 2,
          //     ),
          //   ),
          // )

          // Expanded(
          //   child: StaggeredGridView.countBuilder(
          //     crossAxisCount: 2,
          //     itemCount: 10,
          //     itemBuilder: (context, index) => Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(
          //           SizeConfig.blockSizeHorizontal * 4,
          //         ),
          //         image: DecorationImage(
          //           image: AssetImage(AppImages.PPT_BG1),
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //       child: Column(
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.symmetric(
          //               horizontal: SizeConfig.blockSizeHorizontal * 2.3,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Text(
          //                   "Topic Name",
          //                   style: GoogleFonts.inter(
          //                     textStyle: TextStyle(
          //                       fontSize: SizeConfig.blockSizeHorizontal * 4,
          //                       fontWeight: FontWeight.bold,
          //                       color: AppColors.background_color,
          //                     ),
          //                   ),
          //                 ),
          //                 Column(
          //                   children: [
          //                     Icon(
          //                       Icons.favorite_sharp,
          //                       // ? Change color when selected!
          //                       color: AppColors.textfieldcolor,
          //                     ),
          //                     Text("223",
          //                         style: GoogleFonts.roboto(
          //                           textStyle: TextStyle(
          //                             fontSize:
          //                                 SizeConfig.blockSizeHorizontal * 2.2,
          //                             color: AppColors.background_color,
          //                           ),
          //                         ))
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Spacer(),
          //           Padding(
          //             padding: EdgeInsets.only(
          //                 left: SizeConfig.blockSizeHorizontal * 1,
          //                 right: SizeConfig.blockSizeHorizontal * 3),
          //             child: Row(
          //               children: [
          //                 Container(
          //                   height: SizeConfig.blockSizeVertical * 5,
          //                   width: SizeConfig.blockSizeHorizontal * 10,
          //                   decoration: BoxDecoration(
          //                       shape: BoxShape.circle,
          //                       color: AppColors.textfieldcolor,
          //                       image: DecorationImage(
          //                           image: AssetImage(AppImages.professional))),
          //                 ),
          //                 horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
          //                 Text(
          //                   "Name",
          //                   style: GoogleFonts.inter(
          //                     textStyle: TextStyle(
          //                       fontSize: SizeConfig.blockSizeHorizontal * 3,
          //                       fontWeight: FontWeight.bold,
          //                       color: AppColors.background_color,
          //                     ),
          //                   ),
          //                 ),
          //                 Spacer(),
          //                 Image.asset(
          //                   AppImages.hot,
          //                   scale: 1.5,
          //                 )
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     staggeredTileBuilder: (int index) =>
          //         StaggeredTile.count(1, index.isOdd ? 0.6 : 0.7),
          //     mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
          //     crossAxisSpacing: SizeConfig.blockSizeVertical * 1,
          //     padding: EdgeInsets.symmetric(
          //       horizontal: SizeConfig.blockSizeHorizontal * 2,
          //     ),
          //   ),
          // )

          //? Provider Method below
          Expanded(
            child: Consumer<CreationViewProvider>(
              builder: (context, controller, child) {
                return StaggeredGridView.countBuilder(
                  controller: controller
                      .scrollController, // Attach the ScrollController
                  crossAxisCount: 2,
                  itemCount: controller.presentations.length +
                      1, // Add extra space for the loader
                  itemBuilder: (context, index) {
                    if (index == controller.presentations.length) {
                      // Show a loading indicator at the bottom
                      return controller.isMoreDataAvailable
                          ? Center(
                              child: Shimmer.fromColors(
                              baseColor: AppColors.textfieldcolor,
                              highlightColor: Colors.grey.shade200,
                              direction: ShimmerDirection.ltr,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 4),
                                    child: Container(
                                      color: AppColors.textfieldcolor,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          : SizedBox.shrink();
                    }

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 4),
                      ),
                      child: controller.isLoading
                          ? Shimmer.fromColors(
                              baseColor: AppColors.textfieldcolor,
                              highlightColor: Colors.grey.shade200,
                              direction: ShimmerDirection.ltr,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 4),
                                    child: Container(
                                      color: AppColors.textfieldcolor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.PresentationOpenView,
                                        arguments: [
                                          controller.presentations[index],
                                          true
                                        ]);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 4),
                                    child: individualSlideMethod(
                                        0,
                                        controller.presentations[index].obs,
                                        Size(
                                            SizeConfig.blockSizeHorizontal * 46,
                                            SizeConfig.blockSizeVertical * 50)),
                                  ),
                                ),
                                _userProfileBuilder(controller, index),
                                Positioned(
                                  top: SizeConfig.blockSizeVertical * 0,
                                  left: SizeConfig.blockSizeHorizontal * 2,
                                  right: SizeConfig.blockSizeHorizontal * 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        AppImages.hot,
                                        scale: 1.5,
                                      ),
                                      _LikedWidgetMethod(controller, index),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(1, index.isOdd ? 0.6 : 0.7),
                  mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
                  crossAxisSpacing: SizeConfig.blockSizeVertical * 1,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 2,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  FutureBuilder<UserData?> _userProfileBuilder(
      CreationViewProvider controller, int index) {
    return FutureBuilder<UserData?>(
        future: controller
            .getUserFromID(controller.presentations[index].createrId ?? "temp"),
        builder: (context, snapshot) {
          UserData user = UserData(
              id: "",
              name: "user1234567",
              email: "",
              revenueCatUserId: "",
              gender: "male");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(""); // Show loading indicator
          } else if (snapshot.hasError) {
            // return Text(''); // Show error message
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Handle case when user is not found
          } else {
            user = snapshot.data!;
          }

          return Positioned(
            bottom: SizeConfig.blockSizeVertical * 0.1,
            left: SizeConfig.blockSizeHorizontal * 2,
            right: SizeConfig.blockSizeHorizontal * 3.5,
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
                  user.name ?? "user1234567",
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

  Column _LikedWidgetMethod(CreationViewProvider controller, int index) {
    return Column(
      children: [
        FutureBuilder<bool?>(
            future: controller.isPresentationLikedByUser(
                controller.presentations[index].presentationId.toString()),
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
                color: controller.presentations[index].isLiked || isLiked
                    ? AppColors.mainColor
                    : AppColors.textfieldcolor,
              );
            }),
        Text(controller.presentations[index].likesCount.toString(),
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
