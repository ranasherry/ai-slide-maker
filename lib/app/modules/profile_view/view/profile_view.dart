import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/profile_view/controller/profile_view_controller.dart';
import 'package:slide_maker/app/provider/userdata_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/slide_styles/slide_styles_helping_methods.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProfileView extends GetView<ProfileViewCTL> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
        child: Consumer<UserdataProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 10,
                      width: SizeConfig.blockSizeHorizontal * 20,
                      decoration: BoxDecoration(
                          // border: Border.all(color: AppColors.background_color),
                          shape: BoxShape.circle,
                          color: AppColors.textfieldcolor),
                      child: provider.userData != null
                          ? provider.userData!.profilePicUrl != null
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: provider.userData!.profilePicUrl!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, err, obj) {
                                      return Icon(
                                        CupertinoIcons.person_circle,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  CupertinoIcons.person_circle,
                                )
                          : Icon(
                              CupertinoIcons.person_circle,
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            provider.userData != null
                                ? provider.userData!.name ?? "Name"
                                : "Name",
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                        verticalSpace(SizeConfig.blockSizeVertical * 0.7),
                        // Text("UID:183209897091"),
                        verticalSpace(SizeConfig.blockSizeVertical * 0.7),
                        Text(provider.userData!.email.isEmpty
                            ? "No Email"
                            : provider.userData!.email),
                        verticalSpace(SizeConfig.blockSizeVertical * 0.7),
                        Row(
                          children: [
                            Text("${provider.userData!.gender}"),
                            horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                            Text("🎂 ${(provider.userData!.dob ?? 'DoB')}"),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Get.toNamed(Routes.EDITPROFILEVIEW,
                            arguments: [provider.userData]);
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 4,
                    vertical: SizeConfig.blockSizeVertical * 2,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        followers_method("Followers : 0"),
                        followers_method("Following : 0")
                      ]),
                ),
                Container(
                  height: SizeConfig.blockSizeVertical * 7,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                      // color: AppColors.textfieldcolor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 4),
                          topRight: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 4)),
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.mainColor, width: 1))),
                  child: Center(
                    child: Text(
                      "Your Creations",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor)),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<MyPresentation>?>(
                      future: FirestoreService()
                          .fetchPresentationHistoryByCreaterIdFirestore(
                              provider.userData!.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _gridViewShimmerLoader();
                          // Show loading indicator
                        } else if (snapshot.hasError) {
                          return _noPresentationsAvailable(); // Show error message
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return _noPresentationsAvailable(); // Show error message

                          // Handle case when user is not found
                        } else {
                          List<MyPresentation>? presentations = snapshot.data;
                          if (presentations != null &&
                              presentations.length > 0) {
                            return StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                // controller: controller
                                //     .scrollController, // Attach the ScrollController
                                crossAxisCount: 2,
                                itemCount: presentations
                                    .length, // Add extra space for the loader
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.blockSizeHorizontal * 4),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        SlidePallet pallet =
                                            ComFunction.getSlidePalletFromID(
                                                presentations[index]
                                                    .styleId
                                                    .value);

                                        Get.toNamed(Routes.PresentationOpenView,
                                            arguments: [
                                              presentations[index],
                                              pallet,
                                              true
                                            ]);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.blockSizeHorizontal * 4),
                                        child: individualSlideMethod(
                                            0,
                                            presentations[index].obs,
                                            Size(
                                                SizeConfig.blockSizeHorizontal *
                                                    46,
                                                SizeConfig.blockSizeVertical *
                                                    50)),
                                      ),
                                    ),
                                  );
                                },
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.count(
                                        1, index.isOdd ? 0.6 : 0.7),
                                mainAxisSpacing:
                                    SizeConfig.blockSizeHorizontal * 3,
                                crossAxisSpacing:
                                    SizeConfig.blockSizeVertical * 1,
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 2,
                                ));
                          } else {
                            return _noPresentationsAvailable();
                          }
                        }
                        // return Container();
                      }),
                ),

                // Expanded(
                //   child: ListView(
                //     padding: EdgeInsets.symmetric(
                //         horizontal: SizeConfig.blockSizeHorizontal * 2,
                //         vertical: SizeConfig.blockSizeVertical * 1),
                //     children: [
                //       Container(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: SizeConfig.blockSizeHorizontal * 4),
                //         height: SizeConfig.blockSizeVertical * 10,
                //         width: SizeConfig.blockSizeHorizontal * 60,
                //         decoration: BoxDecoration(
                //             color: AppColors.textfieldcolor,
                //             borderRadius: BorderRadius.circular(
                //                 SizeConfig.blockSizeHorizontal * 7)),
                //         child: Row(
                //           children: [
                //             Container(
                //                 height: SizeConfig.blockSizeVertical * 7,
                //                 width: SizeConfig.blockSizeHorizontal * 25,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(
                //                         SizeConfig.blockSizeHorizontal * 3)),
                //                 child: ClipRRect(
                //                   borderRadius: BorderRadius.circular(
                //                       SizeConfig.blockSizeHorizontal * 3),
                //                   child: Image.asset(
                //                     AppImages.slidy_style8[0],
                //                     fit: BoxFit.cover,
                //                   ),
                //                 )),
                //             horizontalSpace(SizeConfig.blockSizeHorizontal * 4),
                //             Column(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               children: [
                //                 Text(
                //                   "Solar Flair",
                //                   style: GoogleFonts.inter(
                //                       textStyle: TextStyle(
                //                           fontSize:
                //                               SizeConfig.blockSizeHorizontal *
                //                                   4,
                //                           fontWeight: FontWeight.bold,
                //                           color: AppColors.titles)),
                //                 ),
                //                 Text(
                //                   "Date/Time",
                //                   style: GoogleFonts.inter(
                //                       textStyle: TextStyle(
                //                           fontSize:
                //                               SizeConfig.blockSizeHorizontal *
                //                                   3,
                //                           color: AppColors.titles)),
                //                 ),
                //               ],
                //             ),
                //             Spacer(),
                //             GestureDetector(
                //                 onTap: () {}, child: Icon(Icons.more_vert))
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            );
          },
        ),
      ),
    );
  }

  Container _noPresentationsAvailable() {
    return Container(
        height: SizeConfig.screenHeight * .5,
        width: SizeConfig.screenWidth,
        child: Center(child: Text('No Creation Available')));
  }

  StaggeredGridView _gridViewShimmerLoader() {
    return StaggeredGridView.countBuilder(
        shrinkWrap: true,
        // controller: controller
        //     .scrollController, // Attach the ScrollController
        crossAxisCount: 2,
        itemCount: 6, // Add extra space for the loader
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
            ),
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
            ),
          );
        },
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(1, index.isOdd ? 0.6 : 0.7),
        mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3,
        crossAxisSpacing: SizeConfig.blockSizeVertical * 1,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2,
        ));
  }

  Container followers_method(String text) {
    return Container(
      height: SizeConfig.blockSizeVertical * 5,
      width: SizeConfig.blockSizeHorizontal * 37,
      decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4)),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: AppColors.textfieldcolor)),
        ),
      ),
    );
  }
}
