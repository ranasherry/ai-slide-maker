import 'package:applovin_max/applovin_max.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:slide_maker/app/modules/invitation_maker/controllers/weddinginvitation_controller.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/templates/tamplate1.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/templates/template2.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/templates/template3.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/templates/template4.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/templates/template5.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/templates/template6.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:widget_screenshot/widget_screenshot.dart';

class WeddingInvitationView extends GetView<WeddingInvitationController> {
  const WeddingInvitationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (controller.isOnTemplates.value) {
          controller.isOnTemplates.value = false;
        } else {
          print("Back");
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFE7EBFA),
        appBar: AppBar(
          title: Text('Wedding Invitation Maker'),
          backgroundColor: Color(0xFFE7EBFA),
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios_new_rounded)),

          // backgroundColor: Colors.lightBlueAccent,
        ),
        floatingActionButton: Obx(() => controller.isOnTemplates.value
            ? Container()
            : FloatingActionButton.extended(
                onPressed: () {
                  // Perform validation before submission

                  controller.onNext();
                },
                label: Row(
                  children: [
                    Text("Next"),
                    horizontalSpace(SizeConfig.blockSizeHorizontal),
                    Icon(
                      Icons.arrow_forward,
                      size: 20,
                    )
                  ],
                ))),
        body: Obx(() => controller.isOnTemplates.value
            ? Container(
                child: Column(
                  children: [
                    Container(
                        height: SizeConfig.screenHeight * 0.7,
                        child: WidgetShot(
                          key: controller.shotKey,
                          child: Obx(() => IndexedStack(
                                index: controller.selectedIndex.value,
                                children: [
                                  Template1(controller: controller),
                                  Template2(controller: controller),
                                  Template3(controller: controller),
                                  Template4(controller: controller),
                                  Template5(controller: controller),
                                  Template6(controller: controller),
                                ],
                              )),
                        )),
                    designSelector(),
                    verticalSpace(SizeConfig.blockSizeVertical * 1),
                    ElevatedButton.icon(
                        onPressed: () {
                          controller.saveCard();
                        },
                        icon: Icon(Icons.share),
                        label: Text("Share"))
                  ],
                ),
              )
            : _inputFieldView(context)),
      ),
    );
  }

  Widget designSelector() {
    return Container(
        height: SizeConfig.blockSizeVertical * 5,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.NetworkImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin:
                    EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 2),
                child: GestureDetector(
                  onTap: () {
                    controller.selectedIndex.value = index;
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: SizeConfig.blockSizeVertical * 5,
                        height: SizeConfig.blockSizeVertical * 5,
                        decoration: BoxDecoration(
                          // color: AppColors.cardBackground_color,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 5),
                          // Apply the border radius to the image itself
                          image: DecorationImage(
                            fit: BoxFit.fill, // Fill the entire container
                            image: CachedNetworkImageProvider(
                                controller.NetworkImages[index]),
                          ),
                        ),
                      ),
                      Obx(() => controller.selectedIndex.value == index
                          ? Container(
                              width: SizeConfig.blockSizeVertical * 5,
                              height: SizeConfig.blockSizeVertical * 5,
                              decoration: BoxDecoration(
                                // color: AppColors.cardBackground_color,
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.blockSizeHorizontal * 5),
                                // Apply the border radius to the image itself
                                color: Color.fromARGB(96, 68, 62, 62),
                              ),
                              child: Center(child: Icon(Icons.check)),
                            )
                          : Container())
                    ],
                  ),
                ),
              );
            }));
  }

  SingleChildScrollView _inputFieldView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Groom Name Input
            verticalSpace(SizeConfig.blockSizeVertical * 2),
            TextFormField(
              controller: controller.groomNameTextController,
              decoration: InputDecoration(
                labelText: 'Groom Name',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter the groom\'s name',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter the groom\'s name' : null,
            ),
            SizedBox(height: 20),

            // Bride Name Input
            TextFormField(
              controller: controller.brideNameTextController,
              decoration: InputDecoration(
                labelText: 'Bride Name',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter the bride\'s name',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter the bride\'s name' : null,
            ),

            SizedBox(height: 20),

            // Contact Number Input
            TextFormField(
              controller: controller.contactNoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter the contact number',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) => !value!.isPhoneNumber
                  ? 'Please enter a valid phone number'
                  : null,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2),
            TextFormField(
              controller: controller.addressTextController,
              decoration: InputDecoration(
                labelText: 'Venue',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter Venue Address',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter the bride\'s name' : null,
            ),

            // Wedding Date Selection
            verticalSpace(SizeConfig.blockSizeVertical * 1.5),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showOmniDateTimePicker(
                  context: context,
                  initialDate: controller.dateTime,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050),
                );
                if (selectedDate != null) {
                  controller.dateTime = selectedDate;
                }
              },
              child: Text(
                'Select Wedding Date: ${controller.dateTime.day}-${controller.dateTime.month}-${controller.dateTime.year}',
              ),
            ),

            verticalSpace(SizeConfig.blockSizeVertical * 1.5),
          ],
        ),
      ),
    );
  }
}
