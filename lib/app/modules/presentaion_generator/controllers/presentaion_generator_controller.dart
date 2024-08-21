import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/data/my_presentation.dart';
import 'package:slide_maker/app/data/slide.dart';
import 'package:slide_maker/app/data/slide_pallet.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/slide_outline_frag.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/slide_styles_fragment.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/slides_fragment.dart';
import 'package:slide_maker/app/modules/presentaion_generator/views/fragements_views/title_input_fragment.dart.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/services/myapi_services.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
// import by rizwan
import 'package:slide_maker/app/modules/controllers/presentation_history_ctl.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/slide_pallets.dart';

class PresentaionGeneratorController extends GetxController {
//line below added by rizwan
  PresentationHistoryCTL presentationHistoryCTL =
      Get.put(PresentationHistoryCTL());

  //TODO: Implement PresentaionGeneratorController

  //? Input Fragment Variables
  TextEditingController title = TextEditingController();

  Rx<String> isEmpty = ''.obs;
  Rx<String> selectedTone = 'Default'.obs;
  Rx<String> selectedTextAmount = 'Brief'.obs;
  Rx<bool> isSelected = false.obs;

  RxBool isWaitingForTime = false.obs;
  RxString timerValue = "".obs;
  //-----------------------------------------------------------------------------------//

  //? Slide Outline Section
  RxList<String> plannedOutlines = <String>[].obs;
  RxBool isPlannedOutlinesGenerated = false.obs;

  List<Uint8List> downloadedImages = [];

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
  Rx<MyPresentation> myPresentation = MyPresentation(
    presentationId: 0,
    presentationTitle: "",
    slides: <MySlide>[].obs,
    createrId: null,
    timestamp: DateTime.now().millisecondsSinceEpoch,
    styleId: '1',
  ).obs;

  Rx<SlidePallet> selectedPallet = palletList.first.obs;

  // Uint8List? memoryImage;

//? Slides Fragment
  RxBool isSlidesGenerated = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();

    initializeTimer();

    // initdummyPresentation();
    // RequestPresentationPlan();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    @override
    void onClose() {
      HomeViewCtl homeViewCtl = Get.find();
      homeViewCtl.showReviewDialogue(Get.context!);

      super.onClose();
    }

    super.onClose();
  }

  void increment() => count.value++;

  void RequestPresentationPlan() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      StartDownloadingImage(titleTextCTL.text);
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

        currentIndex.value -= 1;
      }
    } else {
      // Toster("No internet Connection", AppColors.Lime_Green_color);
      EasyLoading.showError("No Internet Connection");
      print("Internet OFF");
      EasyLoading.dismiss();
    }
  }

  Future<List<String>> generateOutlines() async {
    // noOfSlide.value = 14;
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
        generationConfig:
            GenerationConfig(maxOutputTokens: 50000, temperature: 1
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
//   Future<void> startGeneratingSlide() async {
//     currentIndex.value = 3;
//     String writingStyle = selectedTone.value;

//     String contentLength = "";
//     if (selectedTextAmount.value == "Brief") {
//       contentLength = "30 words";
//     } else if (selectedTextAmount.value == "Medium") {
//       contentLength = "45 words";
//     } else {
//       contentLength = "65 words";
//     }
//     myPresentation.value = MyPresentation(
//       presentationId: DateTime.now().millisecondsSinceEpoch,
//       presentationTitle: titleTextCTL.text,
//       slides: <MySlide>[].obs,
//     );
//     List<String> coveredTitles = [];
//     for (var outline in plannedOutlines) {
//       //?
//       developer.log("Generating Slide for $outline");
//       final request = '''
//       You will create a presentation slide on given Topic: ${myPresentation.value.presentationTitle}.

//       You will be creating individual slide on Following Slide Title: ${outline}.
//       you must ignore the following topics as they already have covered.
//       CoveredTopic List ${coveredTitles.toString()}

//       Your writing style will be: ${writingStyle}
//       write maximum word in sectionContent: ${contentLength}

//       you are only require to give your response on require json formate enclosed in curly braces{} and no other text will
// return. if format contains section then generate only 3 sections
//  Required Json Format:
// {
//   "slideTitle": "Your Title Here",
//   "slideSections": [
//     {
//       "sectionHeader": "Section Title",
//       "sectionContent": "This is the content for the first section."
//     }
//       ]
// }
//       ''';

//       developer.log("GeminiRequest: $request");

//       String? apiRespnse = await gemeniAPICall(request);
//       if (apiRespnse != null) {
//         developer.log("GeminiRawResponse: $apiRespnse");
//         try {
//           MySlide mySlide = MySlide.fromJson(apiRespnse);
//           myPresentation.value.slides.add(mySlide);

//           coveredTitles.add(mySlide.slideTitle);

//           for (var section in mySlide.slideSections) {
//             coveredTitles.add(section.sectionHeader ?? "");
//           }
//           developer.log("MySlide: ${mySlide.toJson()}");
//         } on Exception catch (e) {
//           developer.log("Json Parsing Error: $e");
//           // TODO
//         }
//       }
//     }
//     for (var slide in myPresentation.value.slides) {
//       developer.log("SavedSlides: ${slide.toMap()}");
//     }

//     isSlidesGenerated.value = true;

//     currentIndex.value = 3;
//   }

  int apiAttempt = 0;

  Future<void> startGeneratingSlide() async {
    currentIndex.value = 3;
    String writingStyle = selectedTone.value;

    String contentLength = "";
    if (selectedTextAmount.value == "Brief") {
      contentLength = "40 words";
    } else if (selectedTextAmount.value == "Medium") {
      // contentLength = "55 words";
      contentLength = "55 words";
    } else {
      contentLength = "75 words";
    }
    myPresentation.value = MyPresentation(
      presentationId: DateTime.now().millisecondsSinceEpoch,
      presentationTitle: titleTextCTL.text,
      slides: <MySlide>[].obs,
      createrId: null,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      styleId: selectedPallet.value.id.toString(),
    );
    List<String> coveredTitles = [];
    // for (var outline in plannedOutlines) {

    //?
    developer.log("Generating Slide for $plannedOutlines");
    final request = '''
      You will create a presentation slide on given Topic: ${myPresentation.value.presentationTitle}. 

      You will be creating slideList on Following Slide Titles: ${plannedOutlines}.
      you must ignore the following topics as they already have covered.
      CoveredTopic List ${coveredTitles.toString()}
      
      Your writing style will be: ${writingStyle}
      write maximum word in sectionContent: ${contentLength}

      you are only require to give your response on require json formate enclosed in curly braces{} and no other text will 
return. if format contains section then generate only maximum 3 sections.
Note: Sections for each slide must be 2 or 3.

Always use correct json format. never use quotes inside text so I Can parse it into object.
 Required Json Format:

 {
 "Slides": [
{
  "slideTitle": "Your Title Here",
  "slideSections": [
    {
      "sectionHeader": "Section Title",
      "sectionContent": "This is the content for the first section."
    }
      ]
},
{
  "slideTitle": "Your Title Here",
  "slideSections": [
    {
      "sectionHeader": "Section Title",
      "sectionContent": "This is the content for the first section."
    }
      ]
}

]
 }

      ''';

    developer.log("GeminiRequest: $request");

    String? apiRespnse = await gemeniAPICall(request);
    if (apiRespnse != null) {
      developer.log("GeminiRawResponse: $apiRespnse");
      try {
        final jsonList = json.decode(apiRespnse) as Map<String, dynamic>;
        final originalList = jsonList["Slides"] as List;
        developer.log("SlidesList: ${originalList}");

        List<MySlide> slides = [];
        for (var item in originalList) {
          MySlide slide = MySlide.fromMap(item);
          slides.add(slide);
          developer.log("Added Slide: ${slide.toMap()}");
        }
        // List<MySlide> slides =
        //     originalList.map((slide) => MySlide.fromMap(slide)).toList();

        // MySlide mySlide = MySlide.fromJson(apiRespnse);

        List<String> imageUrl =
            await MyAPIService().fetchImageUrl("Flutter With Gaming", 1) ?? [];

        developer.log("ImageUrl: ${imageUrl}");

        // int index = 0;
        // for (var url in imageUrl) {
        //   Uint8List? imageBytes = await MyAPIService().downloadImage(url);
        //   if (imageBytes != null) {
        //     slides[index].slideSections[0].memoryImage = imageBytes;
        //     // memoryImage=imageBytes;
        //     developer.log("Image Bytes: $imageBytes");
        //   }
        // }

        int i = 0;

        for (var image in downloadedImages) {
          slides[i].slideSections[0].memoryImage = image;
        }

        developer.log("Images Saved in Slides: ${i + 1}");

        myPresentation.value.slides.value = slides;
        setNewTime();

        // coveredTitles.add(mySlide.slideTitle);
        developer
            .log("SavedSlides Length: ${myPresentation.value.slides.length}");
        //line below added by rizwan
        presentationHistoryCTL.insertPresentation(myPresentation.value);

        // for (var section in mySlide.slideSections) {
        //   coveredTitles.add(section.sectionHeader ?? "");
        // }
        // developer.log("MySlide: ${mySlide.toJson()}");
      } on Exception catch (e) {
        developer.log("Json Parsing Error: $e");
        apiAttempt++;
        if (apiAttempt <= 2) {
          startGeneratingSlide();
        } else {
          EasyLoading.showError(
              "Something Went wrong. Please try again in few minutes..");
          currentIndex.value--;
        }
        // TODO
      }
    } else {
      EasyLoading.showError(
          "Something Went wrong. Please try again in few minutes..");
      currentIndex.value--;
    }

    for (var slide in myPresentation.value.slides) {
      developer.log("SavedSlides: ${slide.toMap()}");
    }

    isSlidesGenerated.value = true;

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
      createrId: null,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      styleId: selectedPallet.value.id.toString(),
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
      AppLovinProvider.instance.showInterstitial(() {});
    }
  }

  void switchToSelectStyle() {
    currentIndex.value = 2;
    AppLovinProvider.instance.showInterstitial(() {});
    // startGeneratingSlide();
  }

  Future<void> createPresentation() async {
    EasyLoading.show(status: "Generating PPTX File");
    try {
      final pres = await ComFunction().createSlidyPresentation(
          mySlides: myPresentation.value.slides,
          Title: myPresentation.value.presentationTitle,
          slidePallet: selectedPallet.value);

      await ComFunction().downloadPresentation(pres);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Could not Generate Slide");
      // TODO
    }
  }

  Future<void> StartDownloadingImage(String title) async {
    developer.log("Started Generating Images...");
    final startTime = DateTime.now();
    try {
      // Record the start time
      // List<String> imageUrl = [];
      List<String> imageUrl =
          await MyAPIService().fetchImageUrl("$title", 3) ?? [];

      // imageUrl.add(
      //     "https://cdn.britannica.com/84/203584-050-57D326E5/speed-internet-technology-background.jpg");
      // imageUrl.add(
      //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfOcYP2JM5nfHtZJai-LkaFynJpfx57yn2iA&s");
      // imageUrl.add(
      //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStJMEX3bKtfOgmU4tQzbneyAVCXJyW7As_kA&s");
      // imageUrl.add(
      //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBRH7oSi8-bTIBfSZjUCL9iWdBWyGUteUJPg&s");
      // imageUrl.add(
      //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7LyYFYMemkRO_G4Lc9mQSygeLfwP1482KHg&s");
      // imageUrl.add(
      //     "https://firebasestorage.googleapis.com/v0/b/ai-slide-generator.appspot.com/o/MathImages%2F1703165648901.jpg?alt=media&token=e584958d-c4f2-4a1d-9703-4755219efc1a");
      // imageUrl.add("aqibsiddiqui.com/images/technology4.jpg");
      // imageUrl.add("aqibsiddiqui.com/images/technology3.jpg");

      developer.log("ImageUrls: $imageUrl");
      for (var url in imageUrl) {
        final startTimeIndividual = DateTime.now();

        Uint8List? imageBytes = await MyAPIService().downloadImage(url);
        if (imageBytes != null) {
          downloadedImages.add(imageBytes);
          final endTime1 = DateTime.now();
          final duration1 = endTime1.difference(startTimeIndividual);
          // memoryImage=imageBytes;
          // downloadedImages[url] = imageBytes.length; // Store size in bytes
          developer.log(
              "Downloaded Image: $url (Size: ${imageBytes.length} bytes)   (Time: ${duration1.inMilliseconds})");
        }
      }
    } on Exception catch (e) {
      // TODO
    }
    final endTime = DateTime.now();

    // Calculate the total time taken
    final duration = endTime.difference(startTime);
    developer.log(
        "Total time taken to download all images: ${duration.inMilliseconds} ms");
  }

  //-----------------------------------------------------------------------------------------------//

  Future<void> initializeTimer() async {
    try {
      // Load last generation time from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // DateTime? lastGenerationTime =
      //     prefs.getString('lastGenerationTime') != null
      //         ? DateTime.parse(prefs.getString('lastGenerationTime')!)
      //         : null;

      // Start a timer to update the variable periodically
      Timer.periodic(Duration(seconds: 1), (timer) async {
        try {
          DateTime? lastGenerationTime =
              prefs.getString('lastGenerationTime') != null
                  ? DateTime.parse(prefs.getString('lastGenerationTime')!)
                  : null;
          if (lastGenerationTime != null) {
            // Calculate the difference between last generation time and current time
            Duration difference = DateTime.now().difference(lastGenerationTime);

            // Calculate the remaining time as a countdown
            Duration countdown = Duration(minutes: 5) - difference;
            countdown = Duration(
                seconds: countdown.inSeconds < 0 ? 0 : countdown.inSeconds);

            // Update the RxString with the formatted time difference

            // If the countdown reaches zero, stop the timer
            if (countdown.inSeconds <= 0) {
              // timer.cancel();
              timerValue.value = formatDuration(countdown);

              isWaitingForTime.value = false;
            } else {
              timerValue.value = formatDuration(countdown);

              isWaitingForTime.value = true;
            }

            // print("Last Generation: $lastGenerationTime");
            // print("Difference: $difference");
            // print("Timer: ${timerValue.value} ");
          } else {
            // Handle the case when lastGenerationTime is null
            isWaitingForTime.value = false;
            print("No lastGenerationTime available.");
          }
        } catch (e) {
          print("Error in timer execution: $e");
          // Handle the error gracefully without stopping the timer
        }
      });
    } catch (e) {
      print("Error in initializeTimer: $e");
    }
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> setNewTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastGenerationTime', DateTime.now().toIso8601String());
    // initializeTimer();
  }

  Future<void> setRewardUnlock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set the last generation time to 10 minutes before the current time
    DateTime lastGenerationTime =
        DateTime.now().subtract(Duration(minutes: 20));

    prefs.setString('lastGenerationTime', lastGenerationTime.toIso8601String());
    // initializeTimer();
  }

  void showWatchRewardPrompt() {
    // EasyLoading.showError("Wait for the time");
    showWatchAdDialog(
      onWatchAd: () {
        // Implement logic to handle "Watch Ad" button click
        print("Watch Ad clicked");
        AppLovinProvider.instance.showRewardedAd(setRewardUnlock);
      },
      onCancel: () {
        // Implement logic to handle "Cancel" button click
        print("Cancel clicked");
      },
      timerText: timerValue,
    );
  }

  void showNavigateBackWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange[100],
          title: Text(
            'Warning',
            style: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You will lose any unsaved progress if you go back. Do you want to continue?',
            style: TextStyle(
                // color: Colors.orange[800],
                ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop(); // Dismiss the dialog
                Get.back();
              },
              child: Text(
                'Cancel',
                // style: TextStyle(color: Colors.orange[900]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.of(context).maybePop(); // Navigate back
                // currentIndex.value = 0;
              },
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.orange[900]),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum TextAmount { Brief, Medium, Detailed }
