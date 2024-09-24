import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/modules/profile_view/controller/profile_view_controller.dart';
import 'package:slide_maker/app/provider/userdata_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

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
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 2,
                        vertical: SizeConfig.blockSizeVertical * 1),
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 4),
                        height: SizeConfig.blockSizeVertical * 10,
                        width: SizeConfig.blockSizeHorizontal * 60,
                        decoration: BoxDecoration(
                            color: AppColors.textfieldcolor,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 7)),
                        child: Row(
                          children: [
                            Container(
                                height: SizeConfig.blockSizeVertical * 7,
                                width: SizeConfig.blockSizeHorizontal * 25,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 3)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 3),
                                  child: Image.asset(
                                    AppImages.slidy_style8[0],
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            horizontalSpace(SizeConfig.blockSizeHorizontal * 4),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Solar Flair",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  4,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titles)),
                                ),
                                Text(
                                  "Date/Time",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3,
                                          color: AppColors.titles)),
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {}, child: Icon(Icons.more_vert))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
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
