import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/profile_view/controller/edit_profile_controller.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3.5),
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // ? Cancel Changes
                      },
                      child: Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          width: SizeConfig.blockSizeHorizontal * 10,
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textfieldcolor,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        // ? Save Changes
                        controller.SaveData();
                      },
                      child: Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          width: SizeConfig.blockSizeHorizontal * 10,
                          decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.done,
                            color: AppColors.textfieldcolor,
                          )),
                    ),
                  ],
                ),
              ),
              Text("Edit Profile",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                  ))),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              GestureDetector(
                onTap: () {
                  controller.pickImageFromGallery();
                },
                child: Obx(() {
                  // Check if an image is picked; if so, display it, otherwise show the icon
                  return Container(
                    height: SizeConfig.blockSizeVertical * 15,
                    width: SizeConfig.blockSizeHorizontal * 30,
                    decoration: BoxDecoration(
                      color: AppColors.textfieldcolor,
                      shape: BoxShape.circle,
                      image: controller.pickedImage.value != null
                          ? DecorationImage(
                              image: FileImage(controller.pickedImage.value!),
                              fit: BoxFit.cover,
                            )
                          : controller.networkImageLink.value.isNotEmpty
                              ? DecorationImage(
                                  // Use CachedNetworkImage for network images
                                  image: CachedNetworkImageProvider(
                                      controller.networkImageLink.value),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: controller.pickedImage.value == null
                        ? Icon(Icons.add_a_photo)
                        : null, // If no image is selected, show the icon
                  );
                }),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                  child: Row(
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            fontWeight: FontWeight.bold),
                      ),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                      Icon(Icons.edit_outlined)
                    ],
                  ),
                ),
              ),
              edit_profile_inputfield("Name", controller.profileName),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                  child: Row(
                    children: [
                      Text(
                        "Date of birth",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            fontWeight: FontWeight.bold),
                      ),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                      Icon(Icons.edit_outlined),
                    ],
                  ),
                ),
              ),
              // edit_profile_inputfield(
              //   "Date of Birth",
              // ),
              GestureDetector(
                onTap: () {
                  controller.selectDate(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1,
                      bottom: SizeConfig.blockSizeVertical * 1),
                  height: SizeConfig.blockSizeVertical * 7,
                  width: SizeConfig.blockSizeHorizontal * 80,
                  decoration: BoxDecoration(
                      color: AppColors.textfieldcolor,
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 3)),
                  child: Obx(() {
                    return Center(
                      child: Text(
                        "DOB: ${controller.selectedDate.value.toLocal().toString().split(' ')[0]} 🎂",
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin:
                      EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
                  child: Row(
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            fontWeight: FontWeight.bold),
                      ),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                      Icon(Icons.edit_outlined),
                    ],
                  ),
                ),
              ),
              Center(
                child: Obx(() {
                  return Wrap(
                    spacing: 8.0,
                    children: controller.chipOptions.map((option) {
                      return ChoiceChip(
                        elevation: 2,
                        label: Text(option,
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                color: controller.selectedChoice.value == option
                                    ? AppColors.mainColor
                                    : Colors.black,
                              ),
                            )),
                        selected: controller.selectedChoice.value == option,
                        onSelected: (selected) {
                          if (selected) {
                            controller.selectChoice(option);
                          }
                        },
                        backgroundColor: AppColors.textfieldcolor,
                        selectedColor: AppColors.textfieldcolor,
                        side: BorderSide(
                          color: controller.selectedChoice.value == option
                              ? AppColors.mainColor
                              : Colors.transparent,
                        ),
                        showCheckmark: false,
                        shadowColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 8)),
                      );
                    }).toList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget edit_profile_inputfield(
      String hintText, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 1,
          bottom: SizeConfig.blockSizeVertical * 1),
      height: SizeConfig.blockSizeVertical * 7,
      width: SizeConfig.blockSizeHorizontal * 80,
      decoration: BoxDecoration(
          color: AppColors.textfieldcolor,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3)),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.start,
        cursorColor: AppColors.titles,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.robotoFlex(
              textStyle: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400)),
          filled: true,
          fillColor: AppColors.textfieldcolor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.blockSizeHorizontal * 3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.blockSizeHorizontal * 3)),
          ),
        ),
      ),
    );
  }
}
