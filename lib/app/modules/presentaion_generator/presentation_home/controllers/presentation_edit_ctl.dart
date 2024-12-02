import 'dart:developer' as developer;
// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/presentation_history_dbhandler.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/data/text_properties.dart';
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
  RxBool isFontWeightProviderVisible = false.obs;
  RxBool isFontColorProviderVisible = false.obs;
  late RxList<TextEditingController> slideTitles =
      <TextEditingController>[].obs;
  late RxList<List<TextEditingController>> slideSectionHeaders =
      <List<TextEditingController>>[].obs;
  late RxList<List<TextEditingController>> slideSectionContents =
      <List<TextEditingController>>[].obs;
  late RxList<TextProperties> slideTitlesTextProperties =
      <TextProperties>[].obs;
  late RxList<List<TextProperties>> slideSectionHeadersTextProperties =
      <List<TextProperties>>[].obs;
  late RxList<List<TextProperties>> slideSectionContentsTextProperties =
      <List<TextProperties>>[].obs;

  late RxList<bool> isSelectedSlideTitle = <bool>[].obs;
  late RxList<List<bool>> isSelectedSlideSectionHeader = <List<bool>>[].obs;
  late RxList<List<bool>> isSelectedSlideSectionContent = <List<bool>>[].obs;
  final FocusNode focusNode = FocusNode();
  RxBool switchViewState = false.obs;
  RxBool ignorePointer = false.obs;

  // late TextEditingController slideSection1SlideTitle;
  // late List<TextEditingController> slideSection1SectionHeaders;
  // late List<TextEditingController> slideSection1SectionContents;
  late RxInt firstIndexOfSlide;
  late RxInt secondIndexOfFont;
  late RxBool isSectionHeader;
  late RxBool isSectionContent;
  late RxBool isTitle;
  late RxString beforeToggleStateCurrentEditedText;
  late RxDouble beforeToggleStateCurrentFontSize;
  late Rx<FontWeight> beforeToggleStateCurrentFontWeight;
  late Rx<double> beforeToggleStateCurrentFontWeightDouble;
  late Rx<Color> beforeToggleStateCurrentFontColor;
  late RxString beforeToggleStateCurrentText;
  late RxInt beforeToggleStateSecondIndexOfFont;
  late RxInt beforeToggleStateFirstIndexOfSlide;
  late RxBool beforeToggleStateIsTitle;
  late RxBool beforeToggleStateIsSectionHeader;
  late RxBool beforeToggleStateIsSectionContent;

  RxBool isSelectedCheck = false.obs;
  RxBool test = false.obs;
  // RxDouble titleFontSize = 0.0.obs;
  // RxDouble contentFontSize = 0.0.obs;
  RxBool resetProperties = false.obs;
  RxList<MyPresentation> presentations = <MyPresentation>[].obs;
  RxBool isEditViewOpen = false.obs;
  RxString presentationTitle = "".obs;

  RxInt currentSelectedIndex = 0.obs;

  RxDouble currentFontSize = 0.0.obs;
  RxDouble currentFontWeightDouble = 1.0.obs;
  Rx<FontWeight> currentFontWeight = FontWeight.normal.obs;
  Rx<Color> currentFontColor = Colors.white.obs;
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
    initializeSlidesTextProperties();
    initializeSlidesTextController();
    initializeIsSelectedSlides();
    setValuesAsNull();
    selectTitleOnInit();
    initializeBeforeToggleStateVariables();
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

  Future<void> initializeSlidesTextController() async {
    // get a list of slideTitles
    slideTitles.value = myEditedPresentation.value.slides.map((slides) {
      return TextEditingController(text: slides.slideTitle);
    }).toList();
    developer.log("This is slideTitle after initialize${slideTitles[0].text}");

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
    developer.log("initializing text done.");
  }

  Future<void> initializeSlidesTextProperties() async {
    slideTitlesTextProperties.value =
        myEditedPresentation.value.slides.map((slides) {
      return TextProperties(
          fontSize: 0.0,
          fontColor: Color(slidePallet.value.bigTitleTColor),
          fontWeight: FontWeight.normal);
    }).toList();
    developer.log(
        "Slide title font value after initialization ${slideTitlesTextProperties[0]}");

    slideSectionHeadersTextProperties.value =
        myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return TextProperties(
            fontSize: 0.0,
            fontColor: Color(slidePallet.value.bigTitleTColor),
            fontWeight: FontWeight.normal);
      }).toList();
    }).toList();

    slideSectionContentsTextProperties.value =
        myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return TextProperties(
            fontSize: 0.0,
            fontColor: Color(slidePallet.value.bigTitleTColor),
            fontWeight: FontWeight.normal);
      }).toList();
    }).toList();
    developer.log("initializing font done.");
  }

  Future<void> initializeIsSelectedSlides() async {
    if (isSelectedCheck.value) {
      isSelectedCheck.value = false;
    } else {
      isSelectedCheck.value = true;
    }
    isSelectedSlideTitle.value =
        myEditedPresentation.value.slides.map((slides) {
      return false;
    }).toList();
    developer.log(
        "Slide title font value after initialization ${isSelectedSlideTitle[0]}");

    isSelectedSlideSectionHeader.value =
        myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return false;
      }).toList();
    }).toList();

    isSelectedSlideSectionContent.value =
        myEditedPresentation.value.slides.map((slides) {
      return slides.slideSections.map((slideSection) {
        return false;
      }).toList();
    }).toList();
    developer.log("initializing font done.");
  }

  Future<void> initializeBeforeToggleStateVariables() async {
    beforeToggleStateCurrentEditedText = "".obs;
    beforeToggleStateCurrentFontSize = 0.0.obs;
    beforeToggleStateCurrentFontWeight = FontWeight.normal.obs;
    beforeToggleStateCurrentFontWeightDouble = 0.0.obs;
    beforeToggleStateCurrentFontColor = Colors.white.obs;
    beforeToggleStateCurrentText = "".obs;
    beforeToggleStateSecondIndexOfFont = 0.obs;
    beforeToggleStateFirstIndexOfSlide = 0.obs;
    beforeToggleStateIsTitle = false.obs;
    beforeToggleStateIsSectionHeader = false.obs;
    beforeToggleStateIsSectionContent = false.obs;
  }

  void setValuesAsNull() {
    firstIndexOfSlide = 0.obs;
    secondIndexOfFont = 0.obs;
    isSectionHeader = false.obs;
    isSectionContent = false.obs;
    isTitle = false.obs;
  }

  void setFontValue(double value) {
    currentFontSize.value = value;
    double newFontSize = value;
    if (isTitle.value) {
      slideTitlesTextProperties[firstIndexOfSlide.value].fontSize = newFontSize;
    } else if (isSectionContent.value) {
      slideSectionContentsTextProperties[firstIndexOfSlide.value]
              [secondIndexOfFont.value]
          .fontSize = newFontSize;
    } else if (isSectionHeader.value) {
      slideSectionHeadersTextProperties[firstIndexOfSlide.value]
              [secondIndexOfFont.value]
          .fontSize = newFontSize;
    } else {}
  }

  Future<void> setFontWeight(double value) async {
    FontWeight fontWeight = await provideFontWeight(value);
    if (isTitle.value) {
      slideTitlesTextProperties[firstIndexOfSlide.value].fontWeight =
          fontWeight;
    } else if (isSectionContent.value) {
      slideSectionContentsTextProperties[firstIndexOfSlide.value]
              [secondIndexOfFont.value]
          .fontWeight = fontWeight;
    } else if (isSectionHeader.value) {
      slideSectionHeadersTextProperties[firstIndexOfSlide.value]
              [secondIndexOfFont.value]
          .fontWeight = fontWeight;
    }
  }

  Future<FontWeight> provideFontWeight(double value) async {
    currentFontWeightDouble.value = value;
    if (value == 1) {
      currentFontWeight.value = FontWeight.w400;
      return currentFontWeight.value;
    } else if (value == 2) {
      currentFontWeight.value = FontWeight.w500;
      return currentFontWeight.value;
    } else if (value == 3) {
      currentFontWeight.value = FontWeight.w600;
      return currentFontWeight.value;
    } else if (value == 4) {
      currentFontWeight.value = FontWeight.w700;
      return currentFontWeight.value;
    } else if (value == 5) {
      currentFontWeight.value = FontWeight.w800;
      return currentFontWeight.value;
    } else {
      currentFontWeight.value = FontWeight.w900;
      return currentFontWeight.value;
    }
  }

  Future<double> getFontWeightDouble(FontWeight fontWeight) async {
    if (fontWeight == FontWeight.w400 || fontWeight == FontWeight.normal) {
      return 1;
    } else if (fontWeight == FontWeight.w500) {
      return 2;
    } else if (fontWeight == FontWeight.w600) {
      return 3;
    } else if (fontWeight == FontWeight.w700) {
      return 4;
    } else if (fontWeight == FontWeight.w800) {
      return 5;
    } else if (fontWeight == FontWeight.w900) {
      return 6;
    } else
      return 0;
  }

  void setFontColor(Color value) {
    currentFontColor.value = value;
    Color newFontColor = value;
    if (isTitle.value) {
      slideTitlesTextProperties[firstIndexOfSlide.value].fontColor =
          newFontColor;
    } else if (isSectionContent.value) {
      slideSectionContentsTextProperties[firstIndexOfSlide.value]
              [secondIndexOfFont.value]
          .fontColor = newFontColor;
    } else if (isSectionHeader.value) {
      slideSectionHeadersTextProperties[firstIndexOfSlide.value]
              [secondIndexOfFont.value]
          .fontColor = newFontColor;
    } else {}
  }

  void setIsSelected(value) async {
    await initializeIsSelectedSlides();
    if (isSelectedCheck.value) {
      isSelectedCheck.value = false;
    } else {
      isSelectedCheck.value = true;
    }
    if (isTitle.value) {
      developer.log("set to ${value} is selected slide title");
      isSelectedSlideTitle[firstIndexOfSlide.value] = value;
    } else if (isSectionContent.value) {
      isSelectedSlideSectionContent[firstIndexOfSlide.value]
          [secondIndexOfFont.value] = value;
    } else if (isSectionHeader.value) {
      isSelectedSlideSectionHeader[firstIndexOfSlide.value]
          [secondIndexOfFont.value] = value;
    } else {}
  }

  void setSlidesText(String value) {
    developer.log(" this is the text passed to setSlideText ${value}");
    if (isTitle.value) {
      slideTitles[firstIndexOfSlide.value].text = value;
      currentText.value = value;
    } else if (isSectionContent.value) {
      slideSectionContents[firstIndexOfSlide.value][secondIndexOfFont.value]
          .text = value;
      currentText.value = value;
    } else if (isSectionHeader.value) {
      slideSectionHeaders[firstIndexOfSlide.value][secondIndexOfFont.value]
          .text = value;
      currentText.value = value;
    } else {}
  }

  // double increaseOrDecreaseFontSize(bool isIncrease, double currentValue) {
  //   if (isIncrease) {
  //     developer.log("before increase ${currentValue}");

  //     currentValue += 0.002;
  //     developer.log("Increased ${currentValue}");
  //     return currentValue;
  //   } else {
  //     developer.log("before decreased ${currentValue}");

  //     currentValue -= 0.002;
  //     developer.log("Decreased ${currentValue}");
  //     return currentValue;
  //   }
  // }

  // void toggleVisibilityBottomNavbarEditor(bool toggle){
  //   isBottomNavbarEditorVisible.value = toggle;
  //   if(toggle){
  //     toggleVisibilityBottomNavbarTextField(false);
  //     toggleVisibilityFontSizeProvider(false);
  //   }
  //   developer.log("Toggle bottom navbar visibility ${isBottomNavbarEditorVisible.value}");
  // }

  Future<void> toggleVisibilityTextEditor(bool toggle) async {
    if (toggle) {
      await toggleVisibilityBottomNavbarTextField(false);
      await toggleVisibilityFontSizeProvider(false);
    }
    isBottomNavbarTextEditorVisible.value = toggle;
    developer.log(
        "Toggle bottom text eDITOR visibility ${isBottomNavbarTextEditorVisible.value}");
  }

  Future<void> toggleVisibilityBottomNavbarTextField(bool toggle) async {
    isBottomNavbarTextFieldVisible.value = toggle;
    developer.log(
        "Toggle bottom text field visibility ${isBottomNavbarTextFieldVisible.value}");
  }

  Future<void> toggleVisibilityFontSizeProvider(bool toggle) async {
    isFontSizeProviderVisible.value = toggle;
    developer.log(
        "Toggle bottom Font size visibility ${isFontSizeProviderVisible.value}");
  }

  Future<void> toggleVisibilityFontWeightProvider(bool toggle) async {
    isFontWeightProviderVisible.value = toggle;
    developer.log(
        "Toggle bottom Font size visibility ${isFontWeightProviderVisible.value}");
  }

  Future<void> toggleVisibilityFontColorProvider(bool toggle) async {
    isFontColorProviderVisible.value = toggle;
    developer.log(
        "Toggle bottom Font size visibility ${isFontColorProviderVisible.value}");
  }

  Future<void> toggleVisibilityTextProperties(
      bool fontSize, bool fontWeight, bool fontColor, bool textField) async {
    if (fontSize) {
      toggleVisibilityFontSizeProvider(fontSize);
      toggleVisibilityBottomNavbarTextField(textField);
      toggleVisibilityFontColorProvider(fontColor);
      toggleVisibilityFontWeightProvider(fontWeight);
    } else if (fontWeight) {
      toggleVisibilityFontSizeProvider(fontSize);
      toggleVisibilityBottomNavbarTextField(textField);
      toggleVisibilityFontColorProvider(fontColor);
      toggleVisibilityFontWeightProvider(fontWeight);
    } else if (fontColor) {
      toggleVisibilityFontSizeProvider(fontSize);
      toggleVisibilityBottomNavbarTextField(textField);
      toggleVisibilityFontColorProvider(fontColor);
      toggleVisibilityFontWeightProvider(fontWeight);
    } else if (textField) {
      toggleVisibilityFontSizeProvider(fontSize);
      toggleVisibilityBottomNavbarTextField(textField);
      toggleVisibilityFontColorProvider(fontColor);
      toggleVisibilityFontWeightProvider(fontWeight);
    }
  }

  Future<void> saveSlides(int slideIndex) async {
    List<SlideSection> slidesText =
        myEditedPresentation.value.slides[slideIndex].slideSections;
    String slideTitle =
        myEditedPresentation.value.slides[slideIndex].slideTitle;
    // print("Before editing ${slides.forEach((e){e.sectionContent;})}");
    slidesText.forEach((e) {
      print("Before ${e.sectionContent}");
    });

    currentPallet.slideTitlesTextProperties![slideIndex].fontSize =
        slideTitlesTextProperties[slideIndex].fontSize;
    currentPallet.slideTitlesTextProperties![slideIndex].fontWeight =
        slideTitlesTextProperties[slideIndex].fontWeight;
    currentPallet.slideTitlesTextProperties![slideIndex].fontColor =
        slideTitlesTextProperties[slideIndex].fontColor;

    developer.log("This is the index $slideIndex");
    var slideContents = slideSectionContents[slideIndex];
    var slideHeaders = slideSectionHeaders[slideIndex];
    List<TextProperties> slideContentsTextProperties = [];
    List<TextProperties> slideHeadersTextProperties = [];
    int i = 0;

    slidesText.forEach((e) {
      if (i < slideContents.length) {
        e.sectionContent = slideContents[i].text;
        e.sectionHeader = slideHeaders[i].text;
        i++;
      }
    });
    i = 0;
    for (var e in slideSectionContentsTextProperties[slideIndex]) {
      slideContentsTextProperties.add(TextProperties(
          fontSize: e.fontSize,
          fontWeight: e.fontWeight,
          fontColor: e.fontColor));
    }
    for (var e in slideSectionHeadersTextProperties[slideIndex]) {
      slideHeadersTextProperties.add(TextProperties(
          fontSize: e.fontSize,
          fontWeight: e.fontWeight,
          fontColor: e.fontColor));
    }
    currentPallet.slideSectionContentsTextProperties![slideIndex] =
        slideContentsTextProperties;
    currentPallet.slideSectionHeadersTextProperties![slideIndex] =
        slideHeadersTextProperties;

    slideTitle = slideTitles[slideIndex].text;
    // print("After editing ${slides.forEach((e){e.sectionContent;})}");
    slidesText.forEach((e) {
      print(" After ${e.sectionContent}");
    });

    myEditedPresentation.value.slides[slideIndex].slideSections = slidesText;
    myEditedPresentation.value.slides[slideIndex].slideTitle = slideTitle;
  }

  Future<void> toggleResetProperties() async {
    if (resetProperties.value) {
      resetProperties.value = false;
    } else {
      resetProperties.value = true;
    }
  }

  Future<void> backButtonAction() async {
    await toggleVisibilityTextEditor(false);
    await toggleVisibilityBottomNavbarTextField(false);
    await toggleVisibilityFontSizeProvider(false);
    await toggleVisibilityFontWeightProvider(false);
    await toggleVisibilityFontColorProvider(false);
    await initializeSlidesTextController();
    await toggleResetProperties();
    await initializeBeforeToggleStateVariables();
    await initializeIsSelectedSlides();

    ignorePointer.value = false;
    switchViewState.value = false;
    isEditViewOpen.value = false;
  }

  double setMaxFontSize() {
    if (isTitle.value) {
      // slideTitles[firstIndexOfSlide.value].text = value;
      // currentText.value = value;
      return 0.085;
    } else if (isSectionContent.value) {
      // slideSectionContents[firstIndexOfSlide.value][secondIndexOfFont.value]
      //     .text = value;
      // currentText.value = value;
      return 0.035;
    } else if (isSectionHeader.value) {
      // slideSectionHeaders[firstIndexOfSlide.value][secondIndexOfFont.value]
      //     .text = value;
      // currentText.value = value;
      return 0.075;
    } else {
      return 0;
    }
  }

  double setMinFontSize() {
    if (isTitle.value) {
      // slideTitles[firstIndexOfSlide.value].text = value;
      // currentText.value = value;
      return 0.02;
    } else if (isSectionContent.value) {
      // slideSectionContents[firstIndexOfSlide.value][secondIndexOfFont.value]
      //     .text = value;
      // currentText.value = value;
      return 0.018;
    } else if (isSectionHeader.value) {
      // slideSectionHeaders[firstIndexOfSlide.value][secondIndexOfFont.value]
      //     .text = value;
      // currentText.value = value;
      return 0.018;
    } else {
      return 0;
    }
  }

  void selectTitleOnInit() async {
    toggleVisibilityTextEditor(true);
    setValuesAsNull();
    isTitle.value = true;
    firstIndexOfSlide.value = currentSelectedIndex.value;
    currentFontSize.value =
        slideTitlesTextProperties[currentSelectedIndex.value].fontSize!;
    currentFontWeight.value =
        slideTitlesTextProperties[currentSelectedIndex.value].fontWeight!;
    currentFontWeightDouble.value =
        await getFontWeightDouble(currentFontWeight.value);
    currentFontColor.value =
        slideTitlesTextProperties[currentSelectedIndex.value].fontColor!;
    currentText.value = slideTitles[currentSelectedIndex.value].text;
    currentEditedText.value = slideTitles[currentSelectedIndex.value].text;
    isSelectedSlideTitle[firstIndexOfSlide.value] = true;
    developer.log('Select Title on init method called.');
    developer.log(
        "${slideTitlesTextProperties[currentSelectedIndex.value].fontSize} size of title");
  }

  void selectedBeforeToggleState() async {
    if (isSectionContent.value) {
      beforeToggleStateIsSectionContent.value = isSectionContent.value;
    } else if (isSectionHeader.value) {
      beforeToggleStateIsSectionHeader.value = isSectionHeader.value;
    } else if (isTitle.value) {
      beforeToggleStateIsTitle.value = isTitle.value;
    }
    beforeToggleStateFirstIndexOfSlide.value = firstIndexOfSlide.value;
    beforeToggleStateSecondIndexOfFont.value = secondIndexOfFont.value;
    beforeToggleStateCurrentText.value = currentText.value;
    beforeToggleStateCurrentFontSize.value = currentFontSize.value;
    beforeToggleStateCurrentFontWeight.value = currentFontWeight.value;
    beforeToggleStateCurrentFontWeightDouble.value =
        await getFontWeightDouble(currentFontWeight.value);
    beforeToggleStateCurrentFontColor.value = currentFontColor.value;
    beforeToggleStateCurrentEditedText.value = currentEditedText.value;
  }

  void setPreviouslySelectedBeforeToggleState() async {
    toggleVisibilityTextEditor(true);
    if (isSectionContent.value) {
      isSectionContent.value = beforeToggleStateIsSectionContent.value;
    } else if (isSectionHeader.value) {
      isSectionHeader.value = beforeToggleStateIsSectionHeader.value;
    } else if (isTitle.value) {
      isTitle.value = beforeToggleStateIsTitle.value;
    }
    setIsSelected(true);
    firstIndexOfSlide.value = beforeToggleStateFirstIndexOfSlide.value;
    secondIndexOfFont.value = beforeToggleStateSecondIndexOfFont.value;
    currentText.value = beforeToggleStateCurrentText.value;
    currentFontSize.value = beforeToggleStateCurrentFontSize.value;
    currentFontWeight.value = beforeToggleStateCurrentFontWeight.value;
    currentFontWeightDouble.value =
        await getFontWeightDouble(currentFontWeight.value);
    currentFontColor.value = beforeToggleStateCurrentFontColor.value;
    currentEditedText.value = beforeToggleStateCurrentEditedText.value;
  }

  Future<void> hideEditingOptions() async {
    toggleVisibilityTextEditor(false);
    toggleVisibilityBottomNavbarTextField(false);
    toggleVisibilityFontSizeProvider(false);
    toggleVisibilityFontWeightProvider(false);
    toggleVisibilityFontColorProvider(false);
    initializeIsSelectedSlides();
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
  Future<void> initializeSlidePalletAndController() async {
    if (currentPallet.slideTitlesTextProperties == null ||
        currentPallet.slideTitlesTextProperties!.isEmpty) {
      currentPallet.slideTitlesTextProperties =
          slideTitlesTextProperties.map((textProperties) {
        return TextProperties(
            fontSize: textProperties.fontSize,
            fontWeight: textProperties.fontWeight,
            fontColor: textProperties.fontColor);
      }).toList();
    } else {
      if (currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                  .fontSize! !=
              0.0 ||
          currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                  .fontWeight! !=
              FontWeight.normal) {
        developer.log("inside slide title text propertires != true");
        slideTitlesTextProperties[currentSelectedIndex.value].fontSize =
            currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                .fontSize!;
        slideTitlesTextProperties[currentSelectedIndex.value].fontWeight =
            currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                .fontWeight!;
        slideTitlesTextProperties[currentSelectedIndex.value].fontColor =
            currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                .fontColor!;
      } else {
        currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                .fontSize =
            slideTitlesTextProperties[currentSelectedIndex.value].fontSize;
        currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                .fontWeight =
            slideTitlesTextProperties[currentSelectedIndex.value].fontWeight;
        currentPallet.slideTitlesTextProperties![currentSelectedIndex.value]
                .fontColor =
            slideTitlesTextProperties[currentSelectedIndex.value].fontColor;
      }
    }
    if (currentPallet.slideSectionContentsTextProperties == null ||
        currentPallet.slideSectionContentsTextProperties!.isEmpty) {
      currentPallet.slideSectionContentsTextProperties =
          slideSectionContentsTextProperties.map((rxList) {
        return rxList.map((textProperties) {
          return TextProperties(
              fontSize: textProperties.fontSize,
              fontWeight: textProperties.fontWeight,
              fontColor: textProperties.fontColor);
        }).toList();
      }).toList();
    } else {
      int i = 0;
      while (i <
          slideSectionContentsTextProperties[currentSelectedIndex.value]
              .length) {
        if (currentPallet
                    .slideSectionContentsTextProperties![
                        currentSelectedIndex.value][i]
                    .fontSize! !=
                0.0 ||
            currentPallet
                    .slideSectionContentsTextProperties![
                        currentSelectedIndex.value][i]
                    .fontWeight! !=
                FontWeight.normal) {
          developer
              .log("inside slide section content text propertires != true");

          slideSectionContentsTextProperties[currentSelectedIndex.value][i]
                  .fontSize =
              currentPallet
                  .slideSectionContentsTextProperties![
                      currentSelectedIndex.value][i]
                  .fontSize!;
          slideSectionContentsTextProperties[currentSelectedIndex.value][i]
                  .fontWeight =
              currentPallet
                  .slideSectionContentsTextProperties![
                      currentSelectedIndex.value][i]
                  .fontWeight!;
          slideSectionContentsTextProperties[currentSelectedIndex.value][i]
                  .fontColor =
              currentPallet
                  .slideSectionContentsTextProperties![
                      currentSelectedIndex.value][i]
                  .fontColor!;
        } else {
          currentPallet
              .slideSectionContentsTextProperties![currentSelectedIndex.value]
                  [i]
              .fontSize = slideSectionContentsTextProperties[
                  currentSelectedIndex.value][i]
              .fontSize;
          currentPallet
              .slideSectionContentsTextProperties![currentSelectedIndex.value]
                  [i]
              .fontWeight = slideSectionContentsTextProperties[
                  currentSelectedIndex.value][i]
              .fontWeight;
          currentPallet
              .slideSectionContentsTextProperties![currentSelectedIndex.value]
                  [i]
              .fontColor = slideSectionContentsTextProperties[
                  currentSelectedIndex.value][i]
              .fontColor;
        }
        i++;
      }
    }
    if (currentPallet.slideSectionHeadersTextProperties == null ||
        currentPallet.slideSectionHeadersTextProperties!.isEmpty) {
      currentPallet.slideSectionHeadersTextProperties =
          slideSectionHeadersTextProperties.map((rxList) {
        return rxList.map((textProperties) {
          return TextProperties(
              fontSize: textProperties.fontSize,
              fontWeight: textProperties.fontWeight,
              fontColor: textProperties.fontColor);
        }).toList();
      }).toList();
    } else {
      int i = 0;
      while (i <
          slideSectionHeadersTextProperties[currentSelectedIndex.value]
              .length) {
        if (currentPallet
                    .slideSectionHeadersTextProperties![
                        currentSelectedIndex.value][i]
                    .fontSize! !=
                0.0 ||
            currentPallet
                    .slideSectionHeadersTextProperties![
                        currentSelectedIndex.value][i]
                    .fontWeight! !=
                FontWeight.normal) {
          developer.log("inside slide section header text propertires != true");

          slideSectionHeadersTextProperties[currentSelectedIndex.value][i]
                  .fontSize =
              currentPallet
                  .slideSectionHeadersTextProperties![
                      currentSelectedIndex.value][i]
                  .fontSize!;
          slideSectionHeadersTextProperties[currentSelectedIndex.value][i]
                  .fontWeight =
              currentPallet
                  .slideSectionHeadersTextProperties![
                      currentSelectedIndex.value][i]
                  .fontWeight!;
          slideSectionHeadersTextProperties[currentSelectedIndex.value][i]
                  .fontColor =
              currentPallet
                  .slideSectionHeadersTextProperties![
                      currentSelectedIndex.value][i]
                  .fontColor!;
        } else {
          currentPallet
              .slideSectionHeadersTextProperties![currentSelectedIndex.value][i]
              .fontSize = slideSectionHeadersTextProperties[
                  currentSelectedIndex.value][i]
              .fontSize;
          currentPallet
              .slideSectionHeadersTextProperties![currentSelectedIndex.value][i]
              .fontWeight = slideSectionHeadersTextProperties[
                  currentSelectedIndex.value][i]
              .fontWeight;
          currentPallet
              .slideSectionHeadersTextProperties![currentSelectedIndex.value][i]
              .fontColor = slideSectionHeadersTextProperties[
                  currentSelectedIndex.value][i]
              .fontColor;
        }
        i++;
      }
    }
    developer.log("completed the method.. called at 106 : 2");
  }

  textForTitleWithGestureDetector(
      RxList<TextEditingController> slideText,
      int firstIndex,
      RxList<TextProperties> textProperties,
      Rx<MyPresentation> myEditedPresentation,
      RxDouble fontSize,
      SlidePallet widgetSlidePallet) {
    return IgnorePointer(
        ignoring: !isEditViewOpen.value || ignorePointer.value,
        child: GestureDetector(
          onTap: () async {
            toggleVisibilityTextEditor(true);
            setValuesAsNull();
            setIsSelected(true);
            isTitle.value = true;
            firstIndexOfSlide.value = firstIndex;
            currentText.value = slideText[firstIndex].text;
            currentFontWeight.value = textProperties[firstIndex].fontWeight!;
            currentFontWeightDouble.value =
                await getFontWeightDouble(currentFontWeight.value);
            currentFontSize.value = textProperties[firstIndex].fontSize!;
            currentFontColor.value = textProperties[firstIndex].fontColor!;
            currentEditedText.value = slideText[firstIndex].text;
            selectedBeforeToggleState();
          },
          child: IntrinsicWidth(
            child: Stack(
              children: [
                Obx(() => Text(
                      (switchViewState.value
                          ? myEditedPresentation
                              .value.slides[firstIndex].slideTitle
                          : slideText[firstIndex].text),
                      style: TextStyle(
                          fontSize: fontSize.value,
                          fontWeight: (switchViewState.value
                              ? widgetSlidePallet
                                  .slideTitlesTextProperties![firstIndex]
                                  .fontWeight!
                              : textProperties[firstIndex].fontWeight),
                          color: (switchViewState.value
                              ? widgetSlidePallet
                                  .slideTitlesTextProperties![firstIndex]
                                  .fontColor!
                              : textProperties[firstIndex].fontColor)),
                    )),
                if (isSelectedSlideTitle[firstIndex] && isEditViewOpen.value)
                  onTapBorderForText(),
              ],
            ),
          ),
        ));
  }

  textForSlideSectionContentWithGestureDetector(
      RxList<List<TextEditingController>> slideText,
      int firstIndex,
      int secondIndex,
      RxList<List<TextProperties>> textProperties,
      Rx<MyPresentation> myEditedPresentation,
      RxDouble fontSize,
      SlidePallet widgetSlidePallet) {
    return IgnorePointer(
        ignoring: !isEditViewOpen.value || ignorePointer.value,
        child: GestureDetector(
          onTap: () async {
            toggleVisibilityTextEditor(true);
            setValuesAsNull();
            setIsSelected(true);
            isSectionContent.value = true;
            firstIndexOfSlide.value = firstIndex;
            secondIndexOfFont.value = secondIndex;
            currentText.value = slideText[firstIndex][secondIndex].text;
            currentFontWeight.value =
                textProperties[firstIndex][secondIndex].fontWeight!;
            currentFontWeightDouble.value =
                await getFontWeightDouble(currentFontWeight.value);
            currentFontSize.value =
                textProperties[firstIndex][secondIndex].fontSize!;
            currentFontColor.value =
                textProperties[firstIndex][secondIndex].fontColor!;
            currentEditedText.value = slideText[firstIndex][secondIndex].text;
            selectedBeforeToggleState();
          },
          child: Stack(
            children: [
              Obx(() => Text(
                    (switchViewState.value
                        ? myEditedPresentation.value.slides[firstIndex]
                            .slideSections[secondIndex].sectionContent!
                        : slideText[firstIndex][secondIndex].text),
                    style: TextStyle(
                        fontSize: fontSize.value,
                        fontWeight: (switchViewState.value
                            ? widgetSlidePallet
                                .slideSectionContentsTextProperties![firstIndex]
                                    [secondIndex]
                                .fontWeight!
                            : textProperties[firstIndex][secondIndex]
                                .fontWeight),
                        color: (switchViewState.value
                            ? widgetSlidePallet
                                .slideSectionContentsTextProperties![firstIndex]
                                    [secondIndex]
                                .fontColor!
                            : textProperties[firstIndex][secondIndex]
                                .fontColor)),
                  )),
              if (isSelectedSlideSectionContent[firstIndex][secondIndex] &&
                  isEditViewOpen.value)
                onTapBorderForText(),
            ],
          ),
        ));
  }

  textForSlideSectionHeaderWithGestureDetector(
      RxList<List<TextEditingController>> slideText,
      int firstIndex,
      int secondIndex,
      RxList<List<TextProperties>> textProperties,
      Rx<MyPresentation> myEditedPresentation,
      RxDouble fontSize,
      SlidePallet widgetSlidePallet) {
    return IgnorePointer(
        ignoring: !isEditViewOpen.value || ignorePointer.value,
        child: GestureDetector(
          onTap: () async {
            toggleVisibilityTextEditor(true);
            setValuesAsNull();
            setIsSelected(true);
            isSectionHeader.value = true;
            firstIndexOfSlide.value = firstIndex;
            secondIndexOfFont.value = secondIndex;
            currentText.value = slideText[firstIndex][secondIndex].text;
            currentFontWeight.value =
                textProperties[firstIndex][secondIndex].fontWeight!;
            currentFontWeightDouble.value =
                await getFontWeightDouble(currentFontWeight.value);
            currentFontSize.value =
                textProperties[firstIndex][secondIndex].fontSize!;
            currentFontColor.value =
                textProperties[firstIndex][secondIndex].fontColor!;
            currentEditedText.value = slideText[firstIndex][secondIndex].text;
            selectedBeforeToggleState();
          },
          child: Stack(
            children: [
              Obx(() => Text(
                    (switchViewState.value
                        ? myEditedPresentation.value.slides[firstIndex]
                            .slideSections[secondIndex].sectionHeader!
                        : slideText[firstIndex][secondIndex].text),
                    style: TextStyle(
                        fontSize: fontSize.value,
                        fontWeight: (switchViewState.value
                            ? widgetSlidePallet
                                .slideSectionHeadersTextProperties![firstIndex]
                                    [secondIndex]
                                .fontWeight!
                            : textProperties[firstIndex][secondIndex]
                                .fontWeight),
                        color: (switchViewState.value
                            ? widgetSlidePallet
                                .slideSectionHeadersTextProperties![firstIndex]
                                    [secondIndex]
                                .fontColor!
                            : textProperties[firstIndex][secondIndex]
                                .fontColor)),
                  )),
              if (isSelectedSlideSectionHeader[firstIndex][secondIndex] &&
                  isEditViewOpen.value)
                onTapBorderForText(),
            ],
          ),
        ));
  }
}

Positioned onTapBorderForText() {
  return Positioned.fill(
    child: IgnorePointer(
      child: Align(
        alignment: Alignment.center,
        child: Transform.scale(
          scale: 1.03,
          child: Container(
            // margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(3)),
          ),
        ),
      ),
    ),
  );
}
