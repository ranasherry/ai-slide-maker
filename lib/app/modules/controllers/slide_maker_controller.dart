import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_pptx/flutter_pptx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/provider/admob_ads_provider.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/provider/meta_ads_provider.dart';
import 'package:slide_maker/app/utills/helper_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/slideResponce.dart';

import '../../routes/app_pages.dart';

import '../../utills/Gems_rates.dart';
import '../../utills/app_strings.dart';
import '../../utills/colors.dart';
// import 'package:dart_pptx/dart_pptx.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

// import 'package:dart_pptx/dart_pptx.dart';
// import 'dart:typed_data';
// import 'dart:io';

// import 'package:path_provider/path_provider.dart';

class SlideMakerController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement SlideMakerController
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // late BuildContext context;

  // // pass the context to the constructor
  // MyController({required this.context});

  // TextEditingController textEditingController = TextEditingController();
  int initialGems = 20;
  RxInt gems = 0.obs;
  bool? firstTime = false;
  final pageController = PageController(initialPage: 0);

  final count = 0.obs;
  @override
  RxDouble input_box_width = 0.0.obs;
  RxDouble input_box_height = 0.0.obs;

  RxDouble create_box_width = 0.0.obs;
  RxDouble create_box_height = 0.0.obs;
  RxString timerValue = "".obs;
  ModelType currentModel = ModelType.Bard;

  RxBool isWaitingForTime = false.obs;

  TextEditingController inputTextCTL = TextEditingController();
  RxString userInput = "".obs;
  RxList<String> outlineTitles = [
    "AI",
    "What is AI?",
    "How to use AI",
    "Is AI safe to use?",
    "AI Advantages",
    "AI Disadvantages"
  ].obs;

  RxList<String> slideImageList = [
    "https://cdn.britannica.com/47/246247-050-F1021DE9/AI-text-to-image-photo-robot-with-computer.jpg",
    "https://img.freepik.com/free-photo/ai-technology-microchip-background-digital-transformation-concept_53876-124669.jpg?w=740&t=st=1699346316~exp=1699346916~hmac=24fbcf0ba1283a72c03bd58d6edcda8888eb034768ec59597f19453b21465025",
    "https://img.freepik.com/free-photo/3d-rendering-biorobots-concept_23-2149524396.jpg?w=740&t=st=1699348832~exp=1699349432~hmac=c7f3fab049ada70844286f1df9abc604a7b1aca13e521c438e20c02987574d00",
    "https://img.freepik.com/free-photo/ai-technology-microchip-background-futuristic-innovation-technology-remix_53876-124727.jpg?w=740&t=st=1699346391~exp=1699346991~hmac=b411c026e9b821f1d334ae78f3ad66d1ed548243a53ded5491ca6d1b89509512",
    "https://img.freepik.com/free-photo/ai-nuclear-energy-background-future-innovation-disruptive-technology_53876-129783.jpg?w=740&t=st=1699346627~exp=1699347227~hmac=06d2555942f19bb40c75b8de1b9f24d5299067441f8d9586a436aa34d2462215",
    "https://img.freepik.com/free-photo/cardano-blockchain-platform_23-2150411956.jpg?w=740&t=st=1699346673~exp=1699347273~hmac=0210466243b91213fefdacc0a97ecbb6c8efc50242c7520e193bbedf537b903e"
  ].obs;
  //  RxList <Slides> slideData = [].obs;

  RxBool outlineTitleFetched = false.obs;

  RxBool showSlides = false.obs;
  RxBool showInside = false.obs;

  late OpenAI openAi;

  String promptForGPT = "";

  List<String> imageslist = [];

  void onInit() {
    super.onInit();
    // AppLovinProvider.instance.init();
    // MetaAdsProvider.instance.initialize();
    // AdMobAdsProvider.instance.initialize();
    initializeTimer();
    show_input();
    Future.delayed(Duration(seconds: 1), () {
      show_create_button();
      openAi = OpenAI.instance.build(
        enableLog: true,
        token: AppStrings.OPENAI_TOKEN,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 60),
          connectTimeout: const Duration(seconds: 60),
        ),
      );
    });
    if (kDebugMode) {
      initialGems = 100;
    } else {
      initialGems = GEMS_RATE.FREE_GEMS;
    }

    CheckUser().then((value) {
      getGems();
    });
  }

  Future<int> getGems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      gems.value = prefs.getInt('gems') ?? 100;
    } else {
      gems.value = prefs.getInt('gems') ?? GEMS_RATE.FREE_GEMS;
    }
    print("GEMS value: ${gems.value}");
    return gems.value;
  }

  decreaseGEMS(int decrease) async {
//     if (kReleaseMode) {
//   print("value: $decrease");
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   gems.value = gems.value - decrease;
//   if (gems.value < 0) {
//     gems.value = 0;
//     await prefs.setInt('gems', gems.value);
//   } else {
//     await prefs.setInt('gems', gems.value);
//   }

//   print("inters");
//   getGems();
// }
  }

  increaseGEMS(int increase) async {
    print("value: $increase");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value + increase;
    await prefs.setInt('gems', gems.value);
    print("inters");
    getGems();
  }

  subscriptionCall() {
    // Get.toNamed(Routes.SUBSCRIPTION);
    // Get.toNamed(Routes.GemsView);
  }

  // saveifsmaller(){

  // }

  Future CheckUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('first_time');

    // var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime!) {
      // Not first time
      gems.value = prefs.getInt('gems') ?? initialGems;
      print("Not First time");
      print("${firstTime}");
      //     Timer(Duration(seconds: 3), () {
      //       // CheckUser();
      //       // AppLovinProvider.instance.init();
      //       Get.offNamed(Routes.NAV,arguments: false);
      // });
    } else {
      // First time
      prefs.setBool('first_time', false);
      print("First time");
      print("${firstTime}");
      await prefs.setInt('limit', 5);
      await prefs.setInt('mathLimit', 3);
      await prefs.setInt('gems', initialGems).then((value) {
        gems.value = prefs.getInt('gems')!;
      });
    }
  }

  show_input() {
    Future.delayed(Duration(milliseconds: 500), () {
      // input_box_width.value = SizeConfig.screenWidth *0.8;
      input_box_width.value = 300;
      // input_box_height.value = SizeConfig.screenHeight *0.2;
      input_box_height.value = 180;
    }).then((value) {
      Future.delayed(Duration(seconds: 1), () {
        showInside.value = true;
      });
    });
  }

  hide_input() {
    showInside.value = false;

    Future.delayed(Duration(seconds: 1), () {
      // input_box_width.value = SizeConfig.screenWidth *0.8;
      input_box_width.value = 300;
      // input_box_height.value = SizeConfig.screenHeight *0.2;
      input_box_height.value = 180;
    });
  }

  show_create_button() {
    create_box_width.value = 140;
    // create_box_height.value = SizeConfig.screenHeight *0.05;
    create_box_height.value = 55;
  }

  show_slides() {
    showSlides.value = true;
  }

  hide_outlines() {
    showInside.value = false;
    Future.delayed(Duration(seconds: 1), () {
      input_box_width.value = 0;
      input_box_height.value = 0;
    }).then((value) {
      hide_buttons().then((value) {
        Future.delayed(Duration(seconds: 1), () {
          show_slides();
        });
      });
    });
  }

  Future hide_buttons() async {
    create_box_height.value = 0;
    create_box_width.value = 0;
  }

  increaseOutputHeight() {
    // input_box_width.value = SizeConfig.screenWidth *0.8;
    input_box_width.value = 300;
    // input_box_height.value = SizeConfig.screenHeight *0.5;
    input_box_height.value = 450;
    Future.delayed(Duration(seconds: 1), () {
      // show_create_button();
      outlineTitleFetched.value = true;
    });
  }

  // Alert_Box(title,dis){
  //   AwesomeDialog(
  //           context: Get.context,
  //           dialogType: DialogType.info,
  //           animType: AnimType.rightSlide,
  //           title: 'Dialog Title',
  //           desc: 'Dialog description here.............',
  //           btnCancelOnPress: () {},
  //           btnOkOnPress: () {},
  //           ).show();
  // }

  validate_user_input() async {
    currentModel = ModelType.Bard;
    if (userInput.isNotEmpty) {
      if (gems.value > 0) {
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          // sendMessage(formattedJson);
          //  getImage(ImageSource);

          await generateContent(userInput.value).then((response) {
            jsonOutput.value = response;
            BaseExtractJson();
            print("BardResponse: ${response}");
          });

          print("Internet ON");
        } else {
          Toster("No internet Connection", AppColors.Lime_Green_color);
          print("Internet OFF");
        }
      } else {
        // GemsFinished();
        Toster("No More Gems Available", AppColors.Electric_Blue_color);
        // Get.toNamed(Routes.GemsView);
      }
    } else {
      Toster("Please write somthing!", AppColors.Lime_Green_color);
    }
  }

  RxString output = "".obs;
  RxString jsonOutput = "".obs;

  Future sendMessage() async {
    currentModel = ModelType.OpenAPI;
    EasyLoading.show(status: "Creating Outlines");

    // promptForGPT = 'create a presentation slide data according to following json on topic ${userInput.value}, like: {"slide_title": "What is AI?","slide_descr": "AI, or Artificial Intelligence, refers to computer systems designed to mimic human intelligence. It encompasses machine learning, neural networks, and data analysis to make decisions, solve problems, and adapt to new information. AI applications range from speech recognition and self-driving cars to healthcare diagnostics, transforming various industries."}, make a list  of 6 slides. your responce must contain JSON list without errors and slide description must be under 20 words';

    // promptForGPT = 'create a presentation slide data according to following json on topic ${userInput.value}, like: {"slide_title": "What is AI?","slide_descr": "AI, or Artificial Intelligence, refers to computer systems designed to mimic human intelligence. It encompasses machine learning, neural networks, and data analysis to make decisions, solve problems, and adapt to new information. AI applications range from speech recognition and self-driving cars to healthcare diagnostics, transforming various industries."}, make a list  of 6 slides';

    print("user input: ${userInput.value}");
    promptForGPT =
        'create a presentation slide on topic provided by user data must be in following json format {"slide_title": "What is AI?","slide_descr": "AI, or Artificial Intelligence, refers to computer systems designed to mimic human intelligence."}, make a list of 6 slides only in JSON formate.';

    // String message = "$promptForGPT";
    // String userReq = "Hello How are you?";
    String userReq = "Topic: ${userInput.value}";
    // String systemReq = "${promptForGPT}";
    // String systemReq = 'Create six presentation slides in the following JSON format, based on the topic "${userInput.value}". Here is an example of the format I need: {"slide_title": "What is AI?","slide_descr": "AI, or Artificial Intelligence, refers to computer systems designed to mimic human intelligence. It encompasses machine learning, neural networks, and data analysis to make decisions, solve problems, and adapt to new information. AI applications range from speech recognition and self-driving cars to healthcare diagnostics, transforming various industries."}Please ensure each slide has a unique title and description, keeping the description under 20 words.';
    String systemReq =
        'Create six presentation slides data in the following JSON format list, based on the topic "${userInput.value}". Here is an example of the format I need: {"slide_title": "Title","slide_descr": "DISCRIPTION"} Please ensure each slide has a unique title and description, keeping the description under 40 words. your content must include creativity with no plagirism and I need only required data I am not demanding any visual content. and I need the list of requred json object';
    log("prompt for GPT: $userReq");
    print("prompt for GPT: $systemReq");

    final userMessage = Messages(role: Role.user, content: userReq);
    final systemMessage = Messages(role: Role.system, content: systemReq);

    print("userMessage for GPT: ${userMessage.role},${userMessage.content}");
    final request = ChatCompleteText(
      temperature: 0.8,
      // messages: [systemMessage,userMessage],
      messages: [systemMessage],
      // maxToken: 140,
      maxToken: AppStrings.MAX_SLIDES_TOKENS,
      // model: GptTurbo0301ChatModel(),
      model: GptTurbo0301ChatModel(),
      // model: Gpt4ChatModel(),
    );

    print("request for GPT: ${request}");

    try {
      final response = await openAi.onChatCompletion(request: request);

      print("response: $response");

      for (var element in response!.choices) {
        print("data -> ${element.message?.content}");
        print("dataID -> ${element.id}");
        // isWaitingForResponse.value = false;
        // shimmerEffect.value = false;
      }
      EasyLoading.dismiss();

      print("ConversationalID: ${response.conversionId}");
      print("ConversationalID: ${response.id}");

      if (response.choices.isNotEmpty &&
          response.choices.first.message != null) {
        // responseState.value=ResponseState.success;
        // conversationID = response.choices.first.message!.id;
      } else {
        // responseState.value=ResponseState.failure;
      }

      ChatMessage messageReceived = ChatMessage(
          senderType: SenderType.Bot,
          message: response.choices[0].message!.content,
          input: "");

      /// J.

      // EasyLoading.dismiss();
      //
      String originalString = messageReceived.message;
      jsonOutput.value = originalString;

      /// J.

      // responseState.value=ResponseState.success;
      // print("OutPut Value: ${output.value}");
      log("output of gpt: ${jsonOutput.value}");
      BaseExtractJson(); //? Commented By Sherry
      // navCTL.gems.value =navCTL.gems.value - GEMS_RATE.IMAGE_GEMS_RATE;
      // savelimit();
      // navCTL.saveGems(navCTL.gems.value);

      decreaseGEMS(GEMS_RATE.slide_GEMS_RATE);
      // String removeString = limit;
      // messageReceived.input = originalString.replaceFirst(removeString, '');
      //
      // chatList.insert(0, messageReceived);
    } catch (err) {
      EasyLoading.dismiss();
      EasyLoading.showError("Server Error Please Try Again Later..");

      // EasyLoading.dismiss();
      // EasyLoading.showError("Something Went Wrong");
      if (err is OpenAIAuthError) {
        print('OpenAIAuthError error ${err.data?.error?.toMap()}');
        FirebaseAnalytics.instance.logEvent(
            name: "Open AI Error", parameters: err.data?.error?.toMap());
      }
      if (err is OpenAIRateLimitError) {
        print('OpenAIRateLimitError error ${err.data?.error?.toMap()}');
        FirebaseAnalytics.instance.logEvent(
            name: "Open AI Error", parameters: err.data?.error?.toMap());
      }
      if (err is OpenAIServerError) {
        print('OpenAIServerError error ${err.data?.error?.toMap()}');
        FirebaseAnalytics.instance.logEvent(
            name: "Open AI Error", parameters: err.data?.error?.toMap());
      }
    }
  }

  void BaseExtractJson() {
    extreactJson().then((value) {
      //  if (kReleaseMode) {

      Future.delayed(Duration(seconds: 1), () {
        if (value) {
          increaseOutputHeight();
          setNewTime();
          if (true) {
            EasyLoading.dismiss();
            if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
              MetaAdsProvider.instance.showInterstitialAd();
            } else {
              AppLovinProvider.instance.showInterstitial(() {});
            }
          }
          Map<String, Object?>? SuccesParameters = <String, dynamic>{
            'Title': 'userInput.value',
          };
          if (currentModel == ModelType.Bard) {
            FirebaseAnalytics.instance.logEvent(
                name: "Successful Result Bard", parameters: SuccesParameters);
          } else {
            FirebaseAnalytics.instance.logEvent(
                name: "Successful Result Open AI",
                parameters: SuccesParameters);
          }
        } else {
          if (currentModel == ModelType.Bard) {
            sendMessage();
          } else {
            EasyLoading.dismiss();
            EasyLoading.showError("Could not Create something Try again");
          }
          Map<String, Object?>? SuccesParameters = <String, dynamic>{
            'Title': 'userInput.value',
          };
          FirebaseAnalytics.instance
              .logEvent(name: "Wrong Json", parameters: SuccesParameters);
        }
      });
    }).onError((error, stackTrace) {
      log("Error: ${error}");
    });
  }

  RxList<SlideResponse> slideResponseList = <SlideResponse>[].obs;

  // Future extreactJson() async {
  //   // final List<SlideResponse> slideResponseList = (jsonDecode(jsonOutput.value) as List)
  //   slideResponseList = (jsonDecode(jsonOutput.value) as List<dynamic>)
  //       .map((item) => SlideResponse.fromJson(item))
  //       .toList();

  //   log("data: ${slideResponseList[0].slideTitle}");
  //   log("data: ${slideResponseList[0].slideDescription}");
  // }

  bool isRetriedJson = false;

  Future<bool> extreactJson() async {
    try {
      // Ensure that jsonOutput.value is not null or empty
      if (jsonOutput.value != null && jsonOutput.value.isNotEmpty) {
        // Parse the JSON data
        var jsonData = jsonDecode(jsonOutput.value);

        log("Json Data $jsonData");

        // Check if jsonData is a list; if not, wrap it in a list
        if (jsonData is List) {
          // Map each item in the list to SlideResponse
          slideResponseList.value =
              jsonData.map((item) => SlideResponse.fromJson(item)).toList();

          // Log the data from the first item
          if (slideResponseList.isNotEmpty) {
            log("data: ${slideResponseList[0].slideTitle}");
            log("data: ${slideResponseList[0].slideDescription}");
            return true;
          } else {
            log("Error: Empty list of slide responses.");
            return false;
          }
        } else {
          // Wrap the non-list data in a list and map it to SlideResponse
          slideResponseList.value = [SlideResponse.fromJson(jsonData)];

          // Log the data from the first item
          log("data: ${slideResponseList[0].slideTitle}");
          log("data: ${slideResponseList[0].slideDescription}");
          return true;
        }
      } else {
        log("Error: JSON data is null or empty.");
        return false;
      }
    } catch (e) {
      log("Error: $e");

      if (!isRetriedJson) {
        isRetriedJson = true;
        List<Map<String, String>?> result = parseJsonString(jsonOutput.value);
        jsonOutput.value = jsonEncode(result);
        // jsonOutput.value = result.toString();
        if (result.isEmpty) {
          log("List is empty");
          return false;
        } else {
          log("List Result: ${result}");
          return await extreactJson().then((value) {
            return value;
          }).onError((error, stackTrace) {
            return false;
          });
        }
      } else {
        return false;
      }

      // return false;
    }
  }

  List<Map<String, String>> parseJsonString(String jsonString) {
    List<Map<String, String>> jsonList = [];

    try {
      List<String> lines = jsonString.split('\n');

      for (String line in lines) {
        if (line.isNotEmpty) {
          int startIndex = line.indexOf('{');
          int endIndex = line.lastIndexOf('}');

          if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
            String jsonSubstring = line.substring(startIndex, endIndex + 1);
            Map<String, String> jsonMap =
                Map<String, String>.from(json.decode(jsonSubstring));
            jsonList.add(jsonMap);
          }
        }
      }
    } catch (e) {
      // Handle any parsing or decoding errors here
      print('Error in Numbering parser: $e');
    }

    return jsonList;
  }

  List<Map<String, String>?> convertToListOfMaps(String input) {
    List<String> lines = input.split('\n');

    List<Map<String, String>?> result = lines
        .map((line) {
          try {
            // Extract the JSON-like string
            String jsonString = line.substring(line.indexOf('{'));
            // Parse the JSON-like string into a map
            Map<String, dynamic> map = json.decode(jsonString);
            // Convert dynamic map to a map with String values
            Map<String, String> stringMap = Map<String, String>.from(map);
            return stringMap;
          } catch (e) {
            // Handle parsing errors (e.g., invalid JSON)
            print('Error parsing line: $line  Error: $e');
            return null;
          }
        })
        .where((map) => map != null && map.isNotEmpty)
        .toList();

    return result;
  }

  String extractValidJson(String input) {
    final RegExp jsonRegex = RegExp(r'{[^{}]*}');
    final Iterable<Match> matches = jsonRegex.allMatches(input);

    if (matches.isNotEmpty) {
      // Extract the first matching JSON string.
      final String validJson = matches.first.group(0) ?? '';
      return validJson;
    } else {
      // Return an empty string if no valid JSON is found.
      return '';
    }
  }

  Future<Uint8List> fetchNetworkImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load network image');
    }
  }

  Future<void> generatePDF(
      // log("No valid data found in the list.");

      // String title, String description,
// Uint8List imageBytes
      ) async {
    log("Entered into the generatePDF");
    // Create a new PDF document
    final pdf = pw.Document();

    for (int i = 0; i < slideResponseList.length; i++) {
      log("Entered into the for loop $i");

      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // Add the title to the PDF
                pw.Text(
                  // title,
                  slideResponseList[i].slideTitle,
                  style: pw.TextStyle(
                    fontSize: 24.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                // Add the description to the PDF
                pw.Paragraph(
                    text:
                        // description
                        slideResponseList[i].slideDescription),
                // Add the image to the PDF

                // pw.Image(pw.MemoryImage(imageslist[i])), //? Temporary comment
                // pw.Image(pw.ImageProvider(NetworkImage(url))),  ///? Temporary comment
              ],
            );
          },
        ),
      );
      // ? Share pdf Image implementation commented by jamal.
      // await fetchNetworkImage(imageslist[i]).then((Uint8List imageBytes) {
      //   // final image = pw.Image(pw.MemoryImage(imageBytes));

      //   pdf.editPage(
      //       i,
      //       pw.Page(
      //         pageFormat: PdfPageFormat.a4,
      //         build: (pw.Context context) {
      //           return pw.Column(
      //             crossAxisAlignment: pw.CrossAxisAlignment.center,
      //             children: [
      //               // Add the title to the PDF
      //               pw.Text(
      //                 // title,
      //                 slideResponseList[i].slideTitle,
      //                 style: pw.TextStyle(
      //                   fontSize: 24.0,
      //                   fontWeight: pw.FontWeight.bold,
      //                 ),
      //               ),
      //               // Add the description to the PDF
      //               pw.Paragraph(
      //                   text:
      //                       // description
      //                       slideResponseList[i].slideDescription),
      //               // Add the image to the PDF
      //               pw.Image(pw.MemoryImage(imageBytes))
      //               // pw.Image(pw.MemoryImage(image)), //? Temporary comment
      //               // pw.Image(pw.ImageProvider(NetworkImage(url))),  ///? Temporary comment
      //             ],
      //           );
      //         },
      //       ));
      //   // pdf.pages[i].add(image);
      //   // You might need to call `pdf.save()` to generate the final PDF after adding all images.
      // });
      //  ? -----------------End----------------
    }

    try {
      log("Entered into the try catch stoage");
      // // Get the document directory on Android
      final outputDir = await getExternalStorageDirectory();
      //  final directory = "/storage/emulated/0/Download/";
      // log("outputDir $directory");

      // // Get the download directory on Android
      // final outputDir = await ExtStorage.getExternalStoragePublicDirectory(
      //     ExtStorage.DIRECTORY_DOWNLOADS);

      // final outputDir = await getDownloadsDirectory();
      // log(inputTextCTL.text);
      String fileName = inputTextCTL.text;
      String filePath = '${outputDir?.path}/$fileName.pdf';
      // String filePath = '${directory}$fileName.pdf';
      final file = File(filePath);
      print('PDF saved to: ${file.path}');
      // Save the PDF to the device's storage
      //trying

      // await FileSaver.instance.saveFile(name: fileName,file: file,filePath: directory,);

//
      await file.writeAsBytes(await pdf.save()).then((value) {
        openPDF(filePath);
      });
    } catch (e) {
      print('Error creating PDF: $e');
    }
  }

  Future<void> openPDF(String filePath) async {
    log("Entered into the openPDF");
    try {
      log("Entered into the openPDF try catch");
      final result = await OpenFile.open(filePath);
      if (result.type == ResultType.done) {
        print('PDF file opened successfully.');
      }
    } catch (e) {
      print('Error opening PDF: $e');
    }
  }

  saveFile() {}

  convertToPPT() async {
    // final pres = await createPresentation();
    //           await downloadPresentation(pres);
    // Check and request permission for writing external storage
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   log("permission");
    //   await Permission.storage.request();
    // }else{
    generatePDF();
    // }
  }

  // ShareApp() {
  //   Share.share(
  //       "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=com.genius.aislides.generator.");
  // }

  // Future openURL(ur) async {
  //   final Uri _url = Uri.parse(ur);
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }

  Toster(msg, color) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: AppColors.white_color,
        fontSize: 16.0);
  }

  String StableDiffusionBudget =
      "https://api.hotpot.ai/stable-diffusion-budget";
  String StableDiffusionNormal =
      "https://api.hotpot.ai/stable-diffusion-normal";
  String ArtGenerator = 'https://api.hotpot.ai/make-art';

  int makeArtCount = 0;
  Future<Uint8List?> makeArtRequest(String prompt) async {
    makeArtCount++;
    print("MakeArtCount: $makeArtCount");

    // isLoaded.value = false;
    print("Slide Image Prompt: $prompt");
    final String apiKey = AppStrings.HOTPOT_API;
    final String styleId = '23';
    final Uri uri = Uri.parse(StableDiffusionBudget);
    final Map<String, String> headers = {
      'Authorization': apiKey,
    };
    final Map<String, String> body = {
      'inputText': prompt,
      'styleId': styleId,
    };

    // return null;
    final response = await http.post(uri, headers: headers, body: body);
    print("Image Link response.statusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      Uint8List imageBytes = response.bodyBytes;

      // EasyLoading.dismiss();
      print("Image Link: ${response.bodyBytes}");
      print("Image Link: ${response.body}");
      // navCTL.decreaseGEMS(GEMS_RATE.AI_IMAGE_GEMS_RATE);
      return imageBytes; // Return imageBytes if generated successfully.
    } else {
      // EasyLoading.dismiss();
      print(
          'Slide Prompt: ( $prompt) Image Link Request failed with status: ${response.statusCode}');
      return null; // Return null to indicate that imageBytes were not generated.
    }
  }

  Future<String?> generateImage(String prompt) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (prompt != "" && result == true) {
      print("inside: generate image if");

      try {
        print("inside: generate image if try");
        //? Commented By Sherry
        final request = GenerateImage(prompt, 1,
            size: ImageSize.size256, responseFormat: Format.url);
        final response = await openAi.generateImage(request);

        String img = "${response?.data?.last?.url}";
        print("Downloaded for image: ${img}");
        // response?.data?.last?.url;

        print("image link: ${img}");
        return img;
        // return "https://oaidalleapiprodscus.blob.core.windows.net/private/org-XKVdJA1KVr1Y1UFoZj0TtApV/user-K6qwhqxwsNyL5aAlMC8td8P2/img-kNGMI20Di8IU1Uy8IGVCkeoK.png?st=2023-10-31T07%3A27%3A23Z&se=2023-10-31T09%3A27%3A23Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-10-31T00%3A19%3A53Z&ske=2023-11-01T00%3A19%3A53Z&sks=b&skv=2021-08-06&sig=8bB1jyuPDE72oAL900SZhVGWxYFEJuoTzXHpgFhwWEo%3D";
        // });
      } catch (e) {
        print("inside: generate image if catch");
        print('Error generating image: $e');
        print('Response error: ${e.toString()}');
        return "https://oaidalleapiprodscus.blob.core.windows.net/private/org-XKVdJA1KVr1Y1UFoZj0TtApV/user-K6qwhqxwsNyL5aAlMC8td8P2/img-kNGMI20Di8IU1Uy8IGVCkeoK.png?st=2023-10-31T07%3A27%3A23Z&se=2023-10-31T09%3A27%3A23Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-10-31T00%3A19%3A53Z&ske=2023-11-01T00%3A19%3A53Z&sks=b&skv=2021-08-06&sig=8bB1jyuPDE72oAL900SZhVGWxYFEJuoTzXHpgFhwWEo%3D";
        // Handle the error appropriately, such as showing an error message to the user
      }
    } else {
      print("inside: generate image else, ${prompt}, , ${result}");

      return "https://oaidalleapiprodscus.blob.core.windows.net/private/org-XKVdJA1KVr1Y1UFoZj0TtApV/user-K6qwhqxwsNyL5aAlMC8td8P2/img-kNGMI20Di8IU1Uy8IGVCkeoK.png?st=2023-10-31T07%3A27%3A23Z&se=2023-10-31T09%3A27%3A23Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-10-31T00%3A19%3A53Z&ske=2023-11-01T00%3A19%3A53Z&sks=b&skv=2021-08-06&sig=8bB1jyuPDE72oAL900SZhVGWxYFEJuoTzXHpgFhwWEo%3D";
    }
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

  void onBackPressed() {
    inputTextCTL.clear();
    showSlides.value = false;
    outlineTitleFetched.value = false;
    show_input();
    Future.delayed(Duration(seconds: 1), () {
      show_create_button();
    });
  }

  Future<bool> shouldGenerateNewSlide() async {
    try {
      // Load last generation time from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime lastGenerationTime =
          DateTime.parse(prefs.getString('lastGenerationTime') ?? '');

      // If lastGenerationTime is not available or more than 10 minutes ago
      if (lastGenerationTime == null ||
          DateTime.now().difference(lastGenerationTime).inMinutes > 10) {
        // Update last generation time in SharedPreferences
        // prefs.setString('lastGenerationTime', DateTime.now().toIso8601String());
        return true; // Generate a new slide
      }

      return false; // Do not generate a new slide
    } catch (e) {
      print("Error in shouldGenerateNewSlide: $e");
      return true; // Return false in case of an error
    }
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

  //? Bard API Below
  Future<String> generateContent(String UserInput) async {
    EasyLoading.show(status: "Creating Outlines");
    print("Bard API Call...");
    final String apiKey = AppStrings.GeminiProKey;
    // print("Bard API $apiKey");

    final String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    try {
      // Construct the request payload
      Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Create six presentation slides data in the following JSON format list, based on the topic "${UserInput}". Here is an example of the format I need: [{"slide_title": "Title","slide_descr": "DISCRIPTION"}] Please ensure each slide has a unique title and description, keeping the description under 40 words. Your content must include creativity with no plagiarism and I need only required data. I am not demanding any visual content, and I need the list of required JSON objects. It must not contain extra content or numbering to the slides, Strictly follow the required json instruction. Note: Your Response must not contain plagirzed content'
                // 'Create six presentation slides data in the following JSON format list, based on the topic "${UserInput}". Here is an example of the format I need: [{"slide_title": "Title","slide_descr": "DISCRIPTION","image_link": "imageUrlHere"}] Please ensure each slide has a unique title and description and an online available image url link from unsplash. url must exist on unsplash, keeping the description under 40 words. Your content must include creativity with no plagiarism and I need only required data. I am not demanding any visual content, and I need the list of required JSON objects. It must not contain extra content or numbering to the slides, Strictly follow the required json instruction'
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.9,
          'topK': 1,
          'topP': 1,
          'maxOutputTokens': 2048,
          'stopSequences': [],
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
        ]
      };

      // Make the API request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse and return the response
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        log("Bard Json Body: ${jsonResponse}");
        final contentList = jsonResponse['candidates'];

        // Assuming the first item in the list is the one you want to access
        final firstItem = contentList.first;

        // Accessing the 'content' and 'parts' keys
        final content = firstItem['content'];
        final parts = content['parts'];

        // Assuming 'parts' is a List and we're taking the first item
        final firstPart = parts.first;

        // Accessing the 'text' property
        final text = firstPart['text'];

        // Returning the text as a String
        return text as String;
      } else {
        throw Exception(
            'Failed to generate content. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      return ''; // You may want to handle errors more gracefully
    }
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

// ? commented by jamal start
  // void tempList() {
  //   SlideResponse slideResponse =
  //       SlideResponse(slideTitle: "Hello", slideDescription: "ABC");

  //   slideResponseList.add(slideResponse);
  //   slideResponse = SlideResponse(slideTitle: "Hello", slideDescription: "ABC");

  //   slideResponseList.add(slideResponse);
  //   slideResponse = SlideResponse(slideTitle: "Hello", slideDescription: "ABC");

  //   slideResponseList.add(slideResponse);
  //   slideResponse = SlideResponse(slideTitle: "Hello", slideDescription: "ABC");

  //   slideResponseList.add(slideResponse);
  //   slideResponse = SlideResponse(slideTitle: "Hello", slideDescription: "ABC");

  //   slideResponseList.add(slideResponse);
  //   slideResponse = SlideResponse(slideTitle: "Hello", slideDescription: "ABC");

  //   slideResponseList.add(slideResponse);

  //   outlineTitleFetched.value = true;
  // }
  // ? commented by jamal end
}

class Slides {
  String title;
  String description;
  String imageUrl;

  Slides({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Slides.fromJson(Map<String, dynamic> json) {
    return Slides(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}

enum SenderType {
  User,
  Bot,
}

class ChatMessage {
  SenderType senderType;
  String message;
  String input;

  ChatMessage(
      {required this.senderType, required this.message, required this.input});
}

enum ModelType {
  Bard,
  OpenAPI,
}
