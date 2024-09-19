import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_open_ctl.dart';
import 'package:slide_maker/app/slide_styles/title_slide1_editor.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';
import 'package:slide_maker/app/data/slide.dart';

class PresentationEditCtl extends GetxController {
  //TODO: Implement PresentationHomeController
  // RxBool readOnly = false.obs;
  PresentationOpenCtl presOpenCtl = Get.find();
  RxBool isBottomNavbarEditorVisible = false.obs;
  RxBool isBottomNavbarTextEditorVisible = false.obs;
  RxBool isBottomNavbarTextFieldVisible = false.obs;
  RxBool isFontSizeProviderVisible = false.obs;
  late RxList<TextEditingController> slideTitles =
      <TextEditingController>[].obs;
  late RxList<List<TextEditingController>> slideSectionHeaders =
      <List<TextEditingController>>[].obs;
  late RxList<List<TextEditingController>> slideSectionContents =
      <List<TextEditingController>>[].obs;
  late RxList<RxDouble> slideTitlesFontValue = <RxDouble>[].obs;
  late RxList<List<RxDouble>> slideSectionHeadersFontValue =
      <List<RxDouble>>[].obs;
  late RxList<List<RxDouble>> slideSectionContentsFontValue =
      <List<RxDouble>>[].obs;
  final FocusNode focusNode = FocusNode();

  // late TextEditingController slideSection1SlideTitle;
  // late List<TextEditingController> slideSection1SectionHeaders;
  // late List<TextEditingController> slideSection1SectionContents;
  late RxInt firstIndexOfFont;
  late RxInt secondIndexOfFont;
  late RxBool isSectionHeader;
  late RxBool isSectionContent;
  late RxBool isTitle;
  RxBool test = false.obs;
  RxDouble titleFontSize = 0.0.obs;
  RxDouble contentFontSize = 0.0.obs;

  RxList<MyPresentation> presentations = <MyPresentation>[].obs;

  RxString presentationTitle = "".obs;

  RxInt currentSelectedIndex = 0.obs;

  RxDouble currentFontSize = 0.0.obs;
  RxString currentText = "".obs;
  late TextEditingController textEditingController;
  RxString currentEditedText = "".obs;

  Rx<SlidePallet> slidePallet = SlidePallet(
          palletId: 6,
          name: "milky",
          slideCategory: "Light",
          bigTitleTColor: Colors.black.value,
          normalTitleTColor: Colors.black.value,
          sectionHeaderTColor: Colors.black.value,
          normalDescTColor: Colors.black.value,
          sectionDescTextColor: Colors.black.value,
          imageList: AppImages.slidy_style6,
          fadeColor: const Color.fromARGB(64, 187, 222, 251),
          isPaid: true)
      .obs;

  SlidePallet currentPallet = SlidePallet(
      palletId: 6,
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
          isLiked: false,
          commentsCount: 0)
      .obs;

  Rx<MyPresentation> myEditedPresentation = MyPresentation(
          presentationId: 0,
          presentationTitle: "",
          slides: <MySlide>[].obs,
          createrId: null,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          styleId: '1'.obs,
          likesCount: 0,
          isLiked: false,
          commentsCount: 0)
      .obs;

  @override
  void onInit() {
    super.onInit();
    MyPresentation pres = Get.arguments[0] as MyPresentation;
    // RxBool readOnly = Get.arguments[1] as RxBool;
    slidePallet.value = presOpenCtl.slidePallet.value;
    developer.log(
        "this is slide pallet id in edit ctl: ${slidePallet.value.palletId}");
    presentationTitle.value = pres.presentationTitle;
    myPresentation.value = pres;
    myEditedPresentation.value = pres;
    textEditingController = TextEditingController(text: currentText.value);
    textEditingController.addListener(() {
      currentText.value = textEditingController.text;
    });
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
    int index = palletList.indexWhere((s) => s.palletId == int.parse(id));
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
    int currentIndex = palletList.indexWhere((pallet) =>
        pallet.palletId == int.parse(myPresentation.value.styleId.value));

    int nextIndex = (currentIndex + 1) % palletList.length;
    SlidePallet nextPallet = palletList[nextIndex];

    myPresentation.value.styleId.value = nextPallet.palletId.toString();

    developer.log("PalletID: ${myPresentation.value.styleId}");
    // myPresentation.value.pallet = nextPallet;
  }

  void initializeSlidesTextController() {
    // get a list of slideTitles
    slideTitles.value = myEditedPresentation.value.slides.map((slides) {
      return TextEditingController(text: slides.slideTitle);
    }).toList();
    // developer.log("${slideTitles.length}");

    // slideTitles.forEach((title){print("this is the title $title");});

// Get a list of lists, where each inner list contains TextEditingControllers
// Example: slideSectionHeaders[1][1] accesses the TextEditingController
    slideSectionHeaders.value = myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return TextEditingController(text: slideSection.sectionHeader ?? "");
      }).toList();
    }).toList();

// Get a list of lists, where each inner list contains TextEditingControllers
// Example: slideSectionContents[1][1] accesses the TextEditingController
    slideSectionContents.value =
        myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return TextEditingController(text: slideSection.sectionContent ?? "");
      }).toList();
    }).toList();
  }

  void initializeSlidesFontList() {
    slideTitlesFontValue.value =
        myEditedPresentation.value.slides.map((slides) {
      return 0.0.obs;
    }).toList();

    slideSectionHeadersFontValue.value =
        myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return 0.0.obs;
      }).toList();
    }).toList();

    slideSectionContentsFontValue.value =
        myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return 0.0.obs;
      }).toList();
    }).toList();
  }

  void setValuesAsNull() {
    firstIndexOfFont = 0.obs;
    secondIndexOfFont = 0.obs;
    isSectionHeader = false.obs;
    isSectionContent = false.obs;
    isTitle = false.obs;
  }

  void setFontValue(bool isIncrease) {
    double newFontSize =
        increaseOrDecreaseFontSize(isIncrease, currentFontSize.value);
    if (isTitle.value) {
      slideTitlesFontValue[firstIndexOfFont.value].value = newFontSize;
      currentPallet.slideTitlesFontValue![firstIndexOfFont.value] = newFontSize;
      // currentPallet.titleFontSize = newFontSize;
      // developer.log("Pallet TitleFont  size: ${currentPallet.titleFontSize}");
      // developer.log("Editing TitleFont ${firstIndex}");
      // developer.log("set Value ${slideTitlesFontValue[firstIndex]}");
    } else if (isSectionContent.value) {
      slideSectionContentsFontValue[firstIndexOfFont.value]
              [secondIndexOfFont.value]
          .value = newFontSize;
      currentPallet.slideSectionContentsFontValue![firstIndexOfFont.value]
          [secondIndexOfFont.value] = newFontSize;
      // developer.log("Editing SectionContent ${firstIndex} ${secondIndex}");
      // double developer.log("set Value ${slideSectionContentsFontValue[firstIndex][secondIndex]}");
    } else if (isSectionHeader.value) {
      slideSectionHeadersFontValue[firstIndexOfFont.value]
              [secondIndexOfFont.value]
          .value = newFontSize;
      currentPallet.slideSectionHeadersFontValue![firstIndexOfFont.value]
          [secondIndexOfFont.value] = newFontSize;

      // developer.log("Editing SectionHeader ${firstIndex} ${secondIndex}");
      // developer.log("set Value ${slideSectionHeadersFontValue[firstIndex][secondIndex]}");
    } else {}
    // if(isTitle.value){

    //   slideTitlesFontValue[firstIndexOfFont.value].value = currentFontSize.value;
    //   currentPallet.titleFontSize=currentFontSize.value;
    //   // developer.log("Pallet TitleFont  size: ${currentPallet.titleFontSize}");
    //   // developer.log("Editing TitleFont ${firstIndexOfFont.value}");
    //   // developer.log("set Value ${slideTitlesFontValue[firstIndexOfFont.value].value}");
    // }
    // else if(isSectionContent.value){
    //   slideSectionContentsFontValue.value[firstIndexOfFont.value][secondIndexOfFont.value].value = currentFontSize.value;
    //   // developer.log("Editing SectionContent ${firstIndexOfFont.value} ${secondIndexOfFont.value}");
    //   // developer.log("set Value ${slideSectionContentsFontValue.value[firstIndexOfFont.value][secondIndexOfFont.value].value}");
    // }
    // else if(isSectionHeader.value){
    //   slideSectionHeadersFontValue.value[firstIndexOfFont.value][secondIndexOfFont.value].value = currentFontSize.value;
    //   // developer.log("Editing SectionHeader ${firstIndexOfFont.value} ${secondIndexOfFont.value}");
    //   // developer.log("set Value ${slideSectionHeadersFontValue.value[firstIndexOfFont.value][secondIndexOfFont.value].value}");
    // }
    // else{
    // }
  }

  void setSlidesText(String value) {
    if (isTitle.value) {
      slideTitles[firstIndexOfFont.value].text = value;
      currentText.value = value;
    } else if (isSectionContent.value) {
      slideSectionContents[firstIndexOfFont.value][secondIndexOfFont.value]
          .text = value;
      currentText.value = value;
    } else if (isSectionHeader.value) {
      slideSectionHeaders[firstIndexOfFont.value][secondIndexOfFont.value]
          .text = value;
      currentText.value = value;
    } else {}
  }

  double increaseOrDecreaseFontSize(bool isIncrease, double currentValue) {
    if (isIncrease) {
      developer.log("before increase ${currentValue}");

      currentValue += 0.002;
      developer.log("Increased ${currentValue}");
      return currentValue;
    } else {
      developer.log("before decreased ${currentValue}");

      currentValue -= 0.002;
      developer.log("Decreased ${currentValue}");
      return currentValue;
    }
  }

  // void toggleVisibilityBottomNavbarEditor(bool toggle){
  //   isBottomNavbarEditorVisible.value = toggle;
  //   if(toggle){
  //     toggleVisibilityBottomNavbarTextField(false);
  //     toggleVisibilityFontSizeProvider(false);
  //   }
  //   developer.log("Toggle bottom navbar visibility ${isBottomNavbarEditorVisible.value}");
  // }

  void toggleVisibilityTextEditor(bool toggle) {
    // toggleVisibilityBottomNavbarEditor(!toggle);
    if (toggle) {
      toggleVisibilityBottomNavbarTextField(false);
      toggleVisibilityFontSizeProvider(false);
    }
    isBottomNavbarTextEditorVisible.value = toggle;
    developer.log(
        "Toggle bottom text eDITOR visibility ${isBottomNavbarTextEditorVisible.value}");
  }

  void toggleVisibilityBottomNavbarTextField(bool toggle) {
    isBottomNavbarTextFieldVisible.value = toggle;
    developer.log(
        "Toggle bottom text field visibility ${isBottomNavbarTextFieldVisible.value}");
  }

  void toggleVisibilityFontSizeProvider(bool toggle) {
    isFontSizeProviderVisible.value = toggle;
    developer.log(
        "Toggle bottom Font size visibility ${isFontSizeProviderVisible.value}");
  }

  Future<void> saveSlides(int slideIndex) async {
    List<SlideSection> slides =
        myEditedPresentation.value.slides[slideIndex].slideSections;
    String slideTitle =
        myEditedPresentation.value.slides[slideIndex].slideTitle;
    // print("Before editing ${slides.forEach((e){e.sectionContent;})}");
    slides.forEach((e) {
      print("Before ${e.sectionContent}");
    });

    developer.log("This is the index $slideIndex");
    var slideContents = slideSectionContents[slideIndex];
    var slideHeaders = slideSectionHeaders[slideIndex];
    int i = 0;

    slides.forEach((e) {
      if (i < slideContents.length) {
        e.sectionContent = slideContents[i].text;
        e.sectionHeader = slideHeaders[i].text;
        i++;
      }
    });
    slideTitle = slideTitles[slideIndex].text;
    // print("After editing ${slides.forEach((e){e.sectionContent;})}");
    slides.forEach((e) {
      print(" After ${e.sectionContent}");
    });

    myEditedPresentation.value.slides[slideIndex].slideSections = slides;
    myEditedPresentation.value.slides[slideIndex].slideTitle = slideTitle;
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
