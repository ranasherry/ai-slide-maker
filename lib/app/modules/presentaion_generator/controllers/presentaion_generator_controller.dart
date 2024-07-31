import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/slide_outline_frag.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/slide_styles_fragment.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/slides_fragment.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/title_input_fragment.dart.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/utills/remoteConfigVariables.dart';

class PresentaionGeneratorController extends GetxController {
  //TODO: Implement PresentaionGeneratorController

  //? Input Fragment Variables
  TextEditingController title = TextEditingController();

  Rx<String> isEmpty = ''.obs;
  Rx<String> selectedTone = 'Default'.obs;
  Rx<String> selectedTextAmount = 'Brief'.obs;
  Rx<bool> isSelected = false.obs;

  //-----------------------------------------------------------------------------------//

  //? Slide Outline Section
  RxList<String> plannedOutlines = <String>[].obs;
  RxBool isPlannedOutlinesGenerated = false.obs;

//-------------------------------------------------------------------------------------//
  final count = 0.obs;
  // RxInt currentIndex = 0.obs;
  RxInt currentIndex = 0.obs;

  List<Widget> mainFragments = [
    titleInputFragment(),
    SlidesOutlinesFrag(),
    SlideStylesFrag(),
    SlidesFragment(),
  ];
  RxInt noOfSlide = 3.obs;
  String toneOfVoice = "";

  TextEditingController titleTextCTL = TextEditingController();

  Rx<TextAmount> textAmount = TextAmount.Brief.obs;

  int tokensConsumed = 0;

  //? Section Related to Slides Screens
  Rx<MyPresentation?> myPresentation = Rx<MyPresentation?>(null);
  SlidePallet dummySlidePallet = SlidePallet(
    id: 1,
    name: "Blue Theme",
    slideCategory: "Light",
    bigTitleTStyle: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.blue.shade900,
    ),
    normalTitleTStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blue.shade800,
    ),
    sectionHeaderTStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.blue.shade700,
    ),
    normalDescTStyle: TextStyle(
      fontSize: 16.0,
      color: Colors.blue.shade600,
    ),
    sectionDescTextStyle: TextStyle(
      fontSize: 14.0,
      color: Colors.blue.shade500,
    ),
    imageList: AppImages.slidy_style1,
    fadeColor: const Color.fromARGB(64, 187, 222, 251),
  );
  @override
  void onInit() {
    super.onInit();
    // initdummyPresentation();
    // RequestPresentationPlan();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void RequestPresentationPlan() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      EasyLoading.show(status: "Generating Outlines..");
      plannedOutlines.value = await generateOutlines();
      if (plannedOutlines.length >= 0) {
        EasyLoading.dismiss();
        for (var outline in plannedOutlines) {
          developer.log("PlannedOutlines: ${outline}");
        }
        isPlannedOutlinesGenerated.value = true;
        // startGeneratingSlide();
      } else {
        EasyLoading.dismiss();

        EasyLoading.showError(
            "We are Currently at our limit Please Try again later...");
      }
    } else {
      // Toster("No internet Connection", AppColors.Lime_Green_color);
      EasyLoading.showError("No Internet Connection");
      print("Internet OFF");
      EasyLoading.dismiss();
    }
  }

  Future<List<String>> generateOutlines() async {
    String apiRequest =
        ''' Generate the Main Titles for the presentation slide on the Topic ${titleTextCTL.text}
    For Example For the Topic AI Following will be Your response for the titles:
    Intro of AI , How AI Works , IS AI safe to Use , AI Advantages , AI Disadvantages , Conclusion

    You must follow the given example response and write the titles in comma seperated values. Note: Each Title should not be more then 3 words and you only need to provide ${noOfSlide.value} titles
     ''';

    String? rawResponse = await gemeniAPICall(apiRequest);

    if (rawResponse != null) {
      developer.log("RawResponse: $rawResponse");
      final outlines = parseStringToList(rawResponse);
      log("List of OutLines Lenght: ${outlines} ");

      return outlines;
    } else {
      EasyLoading.dismiss();
      return [];
      // Get.back();
    }
  }

  List<String> parseStringToList(String text) {
    final parsedList = text.split(',');
    return parsedList;
  }

  int geminiRequestCounter = 0;
  Future<String?> gemeniAPICall(String request) async {
    developer.log("RequestCounter: $geminiRequestCounter");
    final apiKey = RCVariables.geminiAPIKeys[geminiRequestCounter];
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(maxOutputTokens: 500, temperature: 1
            // responseMimeType: "application/json",
            ));

    final content = [Content.text(request)];
    try {
      final response = await model.generateContent(content);

      if (response.text != null) {
        if (response.usageMetadata != null) {
          developer
              .log("Tokens Count: ${response.usageMetadata!.totalTokenCount}");
          tokensConsumed += response.usageMetadata!.totalTokenCount ?? 0;
        }
        String? generatedMessage = response.text;
        geminiRequestCounter = 0;

        developer.log("Gemini Response: $generatedMessage");
        return generatedMessage;
      } else {
        if (geminiRequestCounter >= RCVariables.geminiAPIKeys.length - 1) {
          geminiRequestCounter = 0;

          return null;
        } else {
          geminiRequestCounter++;
          String? generatedMessage = await gemeniAPICall(request);
          return generatedMessage;
        }
      }
    } catch (e) {
      if (kDebugMode) developer.log('Gemini Error $e key: $apiKey  ', error: e);
      // return "Could not generate due to some techniqal issue. please try again after a few minutes ";
      if (geminiRequestCounter >= RCVariables.geminiAPIKeys.length - 1) {
        geminiRequestCounter = 0;

        return null;
      } else {
        geminiRequestCounter++;
        String? generatedMessage = await gemeniAPICall(request);
        return generatedMessage;
      }

      // generatedMessage = "Error Message $e";
    }
  }

  //? Slide Screen Section
  Future<void> startGeneratingSlide() async {
    currentIndex.value = 3;

    myPresentation = MyPresentation(
      presentationId: DateTime.now().millisecondsSinceEpoch,
      presentationTitle: titleTextCTL.text,
      slides: <MySlide>[].obs,
    ).obs;
    List<String> coveredTitles = [];
    for (var outline in plannedOutlines) {
      //?
      developer.log("Generating Slide for $outline");
      final request = '''
      You will create a presentation slide on given Topic: ${myPresentation.value!.presentationTitle}. 
      You will be creating individual slide on Following Slide Title: ${outline}.
      you must ignore the following topics as they already have covered.
      CoveredTopic List ${coveredTitles.toString()}
      
      you are only require to give your response on require json formate enclosed in curly braces{} and no other text will 
return. if format contains section then generate only 3 sections
 Required Json Format:
{
  "slideTitle": "Your Title Here",
  "slideSections": [
    {
      "sectionHeader": "Section Title",
      "sectionContent": "This is the content for the first section."
    }
      ]
}
      ''';

      developer.log("GeminiRequest: $request");

      String? apiRespnse = await gemeniAPICall(request);
      if (apiRespnse != null) {
        developer.log("GeminiRawResponse: $apiRespnse");
        try {
          MySlide mySlide = MySlide.fromJson(apiRespnse);
          myPresentation.value!.slides.add(mySlide);

          coveredTitles.add(mySlide.slideTitle);

          for (var section in mySlide.slideSections) {
            coveredTitles.add(section.sectionHeader ?? "");
          }
          developer.log("MySlide: ${mySlide.toJson()}");
        } on Exception catch (e) {
          developer.log("Json Parsing Error: $e");
          // TODO
        }
      }
    }
    for (var slide in myPresentation.value!.slides) {
      developer.log("SavedSlides: ${slide.toMap()}");
    }

    currentIndex.value = 3;
  }

  void initdummyPresentation() {
    MySlide slide1 = MySlide(
      slideTitle: "Solar Eclipse Overview",
      slideSections: [
        SlideSection(
            sectionContent:
                "A solar eclipse occurs when the moon passes between the Earth and the Sun."),
      ],
      slideType: SlideType.title,
    );

    MySlide slide2 = MySlide(
      slideTitle: "Types of Solar Eclipses",
      slideSections: [
        SlideSection(
            sectionHeader: "Total Solar Eclipse",
            sectionContent:
                "The moon completely covers the sun. Only part of the sun is obscured by the moon. Never look directly at the sun without proper eye protection. Solar eclipses are rare and spectacular events that should be observed with care "),
        SlideSection(
            sectionHeader: "Partial Solar Eclipse",
            sectionContent:
                "Only part of the sun is obscured by the moon. Solar eclipses are rare and spectacular events that should be observed with care. Never look directly at the sun without proper eye protection. Solar eclipses are rare and spectacular events that should be observed with care"),
        SlideSection(
            sectionHeader: "Annular Solar Eclipse",
            sectionContent:
                "The moon is too far to cover the sun completely, creating a ring-like appearance. Solar eclipses are rare and spectacular events that should be observed with care."),
      ],
      slideType: SlideType.sectioned,
    );

    MySlide slide3 = MySlide(
      slideTitle: "Safety Measures",
      slideSections: [
        SlideSection(
            sectionHeader: "Annular Solar Eclipse",
            sectionContent:
                "Never look directly at the sun without proper eye protection. Solar eclipses are rare and spectacular events that should be observed with care."),
        SlideSection(
            sectionContent:
                "Use solar viewing glasses or a pinhole projector to watch the eclipse. Use solar viewing glasses or a pinhole projector to watch the eclipse."),
      ],
      slideType: SlideType.sectioned,
    );

    MySlide slide4 = MySlide(
      slideTitle: "Conclusion",
      slideSections: [
        SlideSection(
            sectionHeader: "Annular Solar Eclipse",
            sectionContent:
                "Solar eclipses are rare and spectacular events that should be observed with care. Never look directly at the sun without proper eye protection. Solar eclipses are rare and spectacular events that should be observed with care"),
      ],
      slideType: SlideType.sectioned,
    );

    final mySlidesList = [slide1, slide2, slide3, slide4].obs;

    myPresentation.value = MyPresentation(
      presentationId: DateTime.now().millisecondsSinceEpoch,
      presentationTitle: "Solar Eclipse",
      slides: mySlidesList,
    );
  }

  //?  Input Fragment
  void updateText(String newText) {
    isEmpty.value = newText;
  }

  // var selectedSlides = "1 slides".obs;

  void selectSlide(int slideNumber) {
    noOfSlide.value = slideNumber;
  }

  void selectTone(String tone) {
    selectedTone.value = tone;
  }

  void selectTextAmount(String amount) {
    selectedTextAmount.value = amount;
  }

  //? Slide Outline Frag Section

  // Method to add a new slide
  void addSlide() {
    int newSlideNumber = plannedOutlines.length + 1;
    plannedOutlines.add(newSlideNumber.toString());
  }

  // Method to remove a slide
  void removeSlide(int index) {
    plannedOutlines.removeAt(index);
    // Adjust slide numbers after removal
    // updateSlideNumbers();
  }

  // Method to reorder slides
  void reorderSlides(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final String slide = plannedOutlines.removeAt(oldIndex);
    plannedOutlines.insert(newIndex, slide);
    // Adjust slide numbers after reordering
    // updateSlideNumbers();
  }

  // Update slide numbers to reflect their new order
  void updateSlideNumbers() {
    plannedOutlines.assignAll(
      List.generate(plannedOutlines.length, (index) => (index + 1).toString()),
    );
  }

  void switchToSlidesOutlines() {
    if (titleTextCTL.text.isNotEmpty) {
      RequestPresentationPlan();
      currentIndex.value = 1;
    }
  }

  void switchToSelectStyle() {
    currentIndex.value = 2;
    // startGeneratingSlide();
  }

  //-----------------------------------------------------------------------------------------------//
}

enum TextAmount { Brief, Medium, Detailed }
