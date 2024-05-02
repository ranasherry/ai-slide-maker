import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/book_writer_controller.dart';

class BookWriterView extends GetView<BookWriterController> {
  const BookWriterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Writer",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
            child: Container(
              margin: EdgeInsets.only(
                  right: SizeConfig.blockSizeHorizontal * 3,
                  left: SizeConfig.blockSizeHorizontal * 3),
              color: Theme.of(context).colorScheme.primary,
              height: 1.5,
            ),
            preferredSize: Size.fromHeight(6.0)),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: inputFormWidget(context),
      //     Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Center(
      //       child: Container(
      //           child: Image.asset(
      //         AppImages.commingSoon,
      //         scale: 3,
      //       )),
      //     )
      //   ],
      // ),
    );
  }

  Widget inputFormWidget(BuildContext context) {
    return FormWidget(controller: controller);
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({
    super.key,
    required this.controller,
  });
  final BookWriterController controller;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

// class _MyWidgetState extends State<MyWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2,
          left: SizeConfig.blockSizeVertical * 1,
          right: SizeConfig.blockSizeVertical * 1,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                // color: Colors.amber,
                child: Center(
                  child: !AppLovinProvider.instance.isAdsEnable
                      ? Container()
                      : MaxAdView(
                          adUnitId: Platform.isAndroid
                              ? AppStrings.MAX_BANNER_ID
                              : AppStrings.IOS_MAX_BANNER_ID,
                          adFormat: AdFormat.banner,
                          listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                            print('Banner widget ad loaded from ' +
                                ad.networkName);
                          }, onAdLoadFailedCallback: (adUnitId, error) {
                            print(
                                'Banner widget ad failed to load with error code ' +
                                    error.code.toString() +
                                    ' and message: ' +
                                    error.message);
                          }, onAdClickedCallback: (ad) {
                            print('Banner widget ad clicked');
                          }, onAdExpandedCallback: (ad) {
                            print('Banner widget ad expanded');
                          }, onAdCollapsedCallback: (ad) {
                            print('Banner widget ad collapsed');
                          })),
                ),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Text("Title",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold)),
              createTextField(context, widget.controller.titleController, 50,
                  "Title Name", null),
              Text("Topic",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold)),
              createTextField(context, widget.controller.topicController, 50,
                  "Topic Name", null),
              // // //  Add Stlye UI Designs // // //
              Text("Style",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold)),
              Obx(() => Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: widget.controller.chipLabels
                        .map(
                          (option) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: ChoiceChip(
                                label: Text(option),
                                labelStyle: TextStyle(
                                  color: widget.controller.nameSelectedOptions
                                          .contains(option)
                                      ? Colors.blue
                                      : Colors.white,
                                  letterSpacing: 1,
                                ),
                                selected: widget.controller.nameSelectedOptions
                                    .contains(option),
                                onSelected: (selected) {
                                  if (selected) {
                                    widget.controller.nameSelectedOptions
                                        .clear();
                                    widget.controller.nameSelectedOptions
                                        .add(option);
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors
                                        .white, // set border color to white
                                    width: 1, // set border width
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary
                                //   Theme.of(context)
                                // .scaffoldBackgroundColor, // set background color to transparent
                                // selectedColor: Colors.white,
                                ),
                          ),
                        )
                        .toList(),
                  )),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Text("Author Name",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold)),

              createTextField(context, widget.controller.authorController, 50,
                  "Auther name", null),
              Text("Description",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold)),
              createTextField(context, widget.controller.descriptionController,
                  500, "Description", 5),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // print("Button Pressed");
                    if (widget.controller.formKey.currentState!.validate()) {
                      widget.controller.generateBook();
                      // Form is valid, perform actions here
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeVertical * 2),
                    height: SizeConfig.blockSizeVertical * 5,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.indigoAccent, Colors.indigo],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3)),
                    child: Center(
                      child: Text(
                        "Generate",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget createTextField(BuildContext context, TextEditingController controller,
      int maxlength, String text, int? maxlines) {
    return TextFormField(
      maxLength: maxlength,
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return "Required";
          }
        }
      },
      onChanged: (value) {},
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: TextStyle(
        fontSize: SizeConfig.blockSizeHorizontal * 4,
        color: Theme.of(context).colorScheme.primary,
      ),
      decoration: InputDecoration(
        // labelText: text,
        // labelStyle: TextStyle(color: Colors.grey),
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
            borderSide: BorderSide.none
            // borderSide: BorderSide(
            //   color: Color(0xFF0095B0), // Border color
            //   width: 1.0, // Border width
            // ),
            ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            // Color(0xFF0095B0), // Border color when focused
            width: 1.0, // Border width when focused
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      minLines: null, // Null or 1 for single-line TextField
      maxLines: maxlines, // Null means infinite number of lines
      keyboardType: TextInputType.multiline, // Enable multiline input
    );
  }
}
