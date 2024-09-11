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
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';
import 'package:slide_maker/app/data/slide.dart';


class PresentationEditCtl extends GetxController {
  //TODO: Implement PresentationHomeController
  // RxBool readOnly = false.obs;
  late List<TextEditingController> slideTitles;
  late List<List<TextEditingController>> slideSectionHeaders;
  late List<List<TextEditingController>> slideSectionContents;
  late RxList<RxDouble> slideTitlesFontValue = <RxDouble>[].obs;
  late RxList<List<RxDouble>> slideSectionHeadersFontValue  = <List<RxDouble>>[].obs;
  late RxList<List<RxDouble>> slideSectionContentsFontValue = <List<RxDouble>>[].obs;

  // late TextEditingController slideSection1SlideTitle;
  // late List<TextEditingController> slideSection1SectionHeaders;
  // late List<TextEditingController> slideSection1SectionContents;
  late RxInt firstIndexOfFont;
  late RxInt secondIndexOfFont;
  late RxBool isSectionHeader;
  late RxBool isSectionContent; 
  late RxBool isTitle; 
  RxBool test = false.obs;

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;
  
  RxString presentationTitle = "".obs;

  RxInt currentSelectedIndex = 0.obs;

  RxDouble currentFontSize = 0.0.obs;

  SlidePallet currentPallet=SlidePallet(
    id: 6,
    name: "milky",
    slideCategory: "Light",
    bigTitleTColor: Colors.black.value,
    normalTitleTColor: Colors.black.value,
    sectionHeaderTColor: Colors.black.value,
    normalDescTColor: Colors.black.value,
    sectionDescTextColor: Colors.black.value,
    imageList: AppImages.slidy_style6,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
    isPaid: true);

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
    initializeSlidesFontList();
    initializeSlidesTextController();
    setValuesAsNull();


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

  void initializeSlidesFontList(){
    slideTitlesFontValue.value = myEditedPresentation.value.slides.map(
      (slides){
         return 0.0.obs;
    }).toList();


    slideSectionHeadersFontValue.value = myEditedPresentation.value.slides.map(
      (slides){
      return slides.slideSections.map(
        (slideSection){
          return 0.0.obs;
          }).toList();
    })
    .toList();


    slideSectionContentsFontValue.value = myEditedPresentation.value.slides.map(
      (slides){
      return slides.slideSections.map(
        (slideSection){
          return 0.0.obs;
          }).toList();
    })
    .toList();
  }
  void setValuesAsNull(){
    firstIndexOfFont= 0.obs;
    secondIndexOfFont = 0.obs;
    isSectionHeader = false.obs;
    isSectionContent = false.obs;
    isTitle = false.obs;
  }
  void setFontValue(int firstIndexOfFont, int secondIndexOfFont, bool isSectionHeader, bool isSectionContent, bool isTitle, double setValue){
    if(isTitle){

      slideTitlesFontValue[firstIndexOfFont].value = setValue;
      currentPallet.titleFontSize=setValue;
      developer.log("Pallet TitleFont  size: ${currentPallet.titleFontSize}");
      // developer.log("Editing TitleFont ${firstIndexOfFont}");
      // developer.log("set Value ${slideTitlesFontValue[firstIndexOfFont].value}");
      // developer.log("set Value  Index: ${firstIndexOfFont}");

      
    }
    else if(isSectionContent){
      slideSectionContentsFontValue.value[firstIndexOfFont][secondIndexOfFont].value = setValue;
      developer.log("Editing SectionContent ${firstIndexOfFont} ${secondIndexOfFont}");
      developer.log("set Value ${slideSectionContentsFontValue.value[firstIndexOfFont][secondIndexOfFont].value}");

    }
    else if(isSectionHeader){
      slideSectionHeadersFontValue.value[firstIndexOfFont][secondIndexOfFont].value = setValue;
      developer.log("Editing SectionHeader ${firstIndexOfFont} ${secondIndexOfFont}");
      developer.log("set Value ${slideSectionHeadersFontValue.value[firstIndexOfFont][secondIndexOfFont].value}");

    
    }
    else{

    }

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