import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:file_saver/file_saver.dart';
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
import 'dart:io';
// import 'package:path_provider/path_provider.dart';

class SlideMakerController extends GetxController {
  //TODO: Implement SlideMakerController
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textEditingController = TextEditingController();
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
  //  RxList <Slides> slideData = [].obs;

  RxBool outlineTitleFetched = false.obs;

  RxBool showSlides = false.obs;
  RxBool showInside = false.obs;

  late OpenAI openAi;

  String promptForGPT = "";

  List<Uint8List> imageslist = [];

  void onInit() {
    super.onInit();
    show_input();
    Future.delayed(Duration(seconds: 1), () {
      show_create_button();
      openAi = OpenAI.instance.build(
        token: AppStrings.OPENAI_TOKEN,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 20),
          connectTimeout: const Duration(seconds: 20),
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
    print("value: $decrease");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value - decrease;
    if (gems.value < 0) {
      gems.value = 0;
      await prefs.setInt('gems', gems.value);
    } else {
      await prefs.setInt('gems', gems.value);
    }

    print("inters");
    getGems();
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
    Get.toNamed(Routes.GemsView);
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
    create_box_width.value = 100;
    // create_box_height.value = SizeConfig.screenHeight *0.05;
    create_box_height.value = 50;
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

  validate_user_input() async {
    if (userInput.isNotEmpty) {
      if (gems.value > 0) {
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          // sendMessage(formattedJson);
          //  getImage(ImageSource);
          sendMessage();
          print("Internet ON");
        } else {
          Toster("No internet Connection", AppColors.Lime_Green_color);
          print("Internet OFF");
        }
      } else {
        // GemsFinished();
        Toster("No More Gems Available", AppColors.Electric_Blue_color);
        Get.toNamed(Routes.GemsView);
      }
    } else {
      Toster("Please write somthing!", AppColors.Lime_Green_color);
    }
  }

  RxString output = "".obs;
  RxString jsonOutput = "".obs;

  Future sendMessage() async {
    EasyLoading.show(status: "Creating Outlines");

    // promptForGPT = 'create a presentation slide data according to following json on topic ${userInput.value}, like: {"slide_title": "What is AI?","slide_descr": "AI, or Artificial Intelligence, refers to computer systems designed to mimic human intelligence. It encompasses machine learning, neural networks, and data analysis to make decisions, solve problems, and adapt to new information. AI applications range from speech recognition and self-driving cars to healthcare diagnostics, transforming various industries."}, make a list  of 6 slides. your responce must contain JSON list without errors and slide description must be under 20 words';
    // promptForGPT = 'create a presentation slide data according to following json on topic ${userInput.value}, like: {"slide_title": "What is AI?","slide_descr": "AI, or Artificial Intelligence, refers to computer systems designed to mimic human intelligence. It encompasses machine learning, neural networks, and data analysis to make decisions, solve problems, and adapt to new information. AI applications range from speech recognition and self-driving cars to healthcare diagnostics, transforming various industries."}, make a list  of 6 slides';
    promptForGPT =
        'create a presentation slide data according to following json on topic ${userInput.value}, like: {"slide_title": "What is AI?","slide_descr": "AI, or Artificial Intelligence, refers to computer systems designed to mimic human intelligence."}, make a list of 6 slides only in JSON formate.';

    String message = "$promptForGPT";
    log("prompt for GPT: $message");

    final userMessage = Messages(role: Role.user, content: message);
    final request = ChatCompleteText(
      messages: [userMessage],
      // maxToken: AppStrings.MAX_CHAT_TOKKENS,
      maxToken: AppStrings.MAX_SLIDES_TOKENS,
      model: GptTurbo0301ChatModel(),
    );

    try {
      final response = await openAi.onChatCompletion(request: request);

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
          input: message);

      /// J.

      // EasyLoading.dismiss();
      //
      String originalString = messageReceived.message;
      jsonOutput.value = originalString;

      /// J.

      // responseState.value=ResponseState.success;
      // print("OutPut Value: ${output.value}");
      log("output of gpt: ${jsonOutput.value}");
      extreactJson().then((value) {
        Future.delayed(Duration(seconds: 1), () {
          increaseOutputHeight();
        });
      });
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
      EasyLoading.showError("Something Went Wrong..");
      // EasyLoading.dismiss();
      // EasyLoading.showError("Something Went Wrong");
      if (err is OpenAIAuthError) {
        print('OpenAIAuthError error ${err.data?.error?.toMap()}');
      }
      if (err is OpenAIRateLimitError) {
        print('OpenAIRateLimitError error ${err.data?.error?.toMap()}');
      }
      if (err is OpenAIServerError) {
        print('OpenAIServerError error ${err.data?.error?.toMap()}');
      }
    }
  }

  List<SlideResponse> slideResponseList = [];

  Future extreactJson() async {
    // final List<SlideResponse> slideResponseList = (jsonDecode(jsonOutput.value) as List)
    slideResponseList = (jsonDecode(jsonOutput.value) as List<dynamic>)
        .map((item) => SlideResponse.fromJson(item))
        .toList();

    log("data: ${slideResponseList[0].slideTitle}");
    log("data: ${slideResponseList[0].slideDescription}");
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
                pw.Image(pw.MemoryImage(imageslist[i])),
              ],
            );
          },
        ),
      );
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

  ShareApp() {
    Share.share(
        "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=com.genius.aislides.generator.");
  }

  Future openURL(ur) async {
    final Uri _url = Uri.parse(ur);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
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
