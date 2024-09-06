import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/slide_styles/title_slide1_editor.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';
import 'package:slide_maker/app/data/slide.dart';


class PresentationEditCtl extends GetxController {
  //TODO: Implement PresentationHomeController
  // RxBool readOnly = false.obs;
  late List<TextEditingController> slideTitles;
  late List<List<TextEditingController>> slideSectionHeaders;
  late List<List<TextEditingController>> slideSectionContents;
  // late TextEditingController slideSection1SlideTitle;
  // late List<TextEditingController> slideSection1SectionHeaders;
  // late List<TextEditingController> slideSection1SectionContents;

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;
  
  RxString presentationTitle = "".obs;
  RxInt currentSelectedIndex = 0.obs;
  

  Rx<MyPresentation> myPresentation = MyPresentation(
    presentationId: 0,
    presentationTitle: "",
    slides: <MySlide>[].obs,
    createrId: null,
    timestamp: DateTime.now().millisecondsSinceEpoch,
    styleId: '1'.obs,
    likesCount: 0,
    commentsCount: 0
  ).obs;
   Rx<MyPresentation> myEditedPresentation = MyPresentation(
    presentationId: 0,
    presentationTitle: "",
    slides: <MySlide>[].obs,
    createrId: null,
    timestamp: DateTime.now().millisecondsSinceEpoch,
    styleId: '1'.obs,
    likesCount: 0,
    commentsCount: 0
  ).obs;


  @override
  void onInit() {
    super.onInit();
    MyPresentation pres = Get.arguments[0] as MyPresentation;
    // RxBool readOnly = Get.arguments[1] as RxBool;
    presentationTitle.value = pres.presentationTitle;
    myPresentation.value = pres;
    myEditedPresentation.value = pres;
    developer.log("Opened Slide: ${pres.toMap()}");
  }

  @override
  void onClose() {
    super.onClose();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }

  Future<void> createPresentation() async {
    EasyLoading.show(status: "Generating PPTX File");
    try {
      final pres = await ComFunction().createSlidyPresentation(
          mySlides: myPresentation.value.slides,
          Title: myPresentation.value.presentationTitle,
          slidePallet:
              getSlidePalletFromID(myPresentation.value.styleId.value));

      await ComFunction().downloadPresentation(pres);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Could not Generate Slide");
      // TODO
    }
  }

  SlidePallet getSlidePalletFromID(String id) {
    int index = palletList.indexWhere((s) => s.id == int.parse(id));
    if (index >= 0) {
      return palletList[index];
    } else {
      return palletList[0];
    }
  }

  void deleteSlide(int index) {
    if (index >= 0 && index < myPresentation.value.slides.length) {
      myPresentation.value.slides.removeAt(index);
    } else {
      print("Index out of range");
    }
  }

  void changePallet() {
    int currentIndex = palletList.indexWhere(
        (pallet) => pallet.id == int.parse(myPresentation.value.styleId.value));

    int nextIndex = (currentIndex + 1) % palletList.length;
    SlidePallet nextPallet = palletList[nextIndex];

    myPresentation.value.styleId.value = nextPallet.id.toString();

    developer.log("PalletID: ${myPresentation.value.styleId}");
    // myPresentation.value.pallet = nextPallet;
  }
  void initializeSlidesTextController(){
    // get a list of slideTitles
    slideTitles = myEditedPresentation.value.slides.map(
      (slides){
         return TextEditingController(text : slides.slideTitle);
    }).toList();

    // slideTitles.forEach((title){print("this is the title $title");});

// Get a list of lists, where each inner list contains TextEditingControllers 
// Example: slideSectionHeaders[1][1] accesses the TextEditingController 
     slideSectionHeaders = myEditedPresentation.value.slides.map(
      (slides){
      return slides.slideSections.map(
        (slideSection){
          return TextEditingController(text : slideSection.sectionHeader ?? "");
          }).toList();
    })
    .toList();

// Get a list of lists, where each inner list contains TextEditingControllers 
// Example: slideSectionContents[1][1] accesses the TextEditingController 
    slideSectionContents = myEditedPresentation.value.slides.map(
      (slides){
      return slides.slideSections.map(
        (slideSection){
          return TextEditingController(text : slideSection.sectionContent ?? "");
          }).toList();
    })
    .toList();
  }
 
  // void initializeSectionSlide1Editor(MySlide mySlide){
  //   slideSection1SlideTitle = TextEditingController(text : mySlide.slideTitle);
    
  //     // Initialize  with the default values from slideSections
  //   slideSection1SectionHeaders = mySlide.slideSections.map((section) {
  //     return TextEditingController(text: section.sectionHeader ?? '');
  //   }).toList();

  //   slideSection1SectionContents = mySlide.slideSections.map((section) {
  //     return TextEditingController(text: section.sectionContent ?? '');
  //   }).toList();
  // }


 
}