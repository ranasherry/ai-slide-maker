import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:markdown/markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/helping_enums.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';

class BookGeneratedCTL extends GetxController {
  //TODO: Implement BookWriterController

  RxList<BookPageModel> bookPages = <BookPageModel>[].obs;
  String mainDetail = "";
  RxBool isBookGenerated = false.obs;

  RxString Title = "".obs;

  RxString OutlinesinMarkdown = "".obs;
  RxString TitleMarkDown = "".obs;
  var isFeedbackGiven = false.obs;
  var isPositiveFeedback = false.obs;

  @override
  void onInit() {
    super.onInit();

    final argumunts = Get.arguments;

    String apirequest = argumunts[0];
    String auther = argumunts[1];
    mainDetail = argumunts[2];
    Title.value = argumunts[3];

    TitleMarkDown.value = '''


# ${Title.value} \n\n



## By ${auther} ''';

    print("Request: $apirequest \n Auther: $auther");
    generateBookOutlines(apirequest);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> generateBookOutlines(String apirequest) async {
    String? rawResponse = await geminiAPICall(apirequest);
    if (rawResponse != null) {
      List<String> listOfOutlines = parseStringToList(rawResponse);
      OutlinesinMarkdown.value = convertListToMarkdownToc(listOfOutlines);
      startWritingBook(listOfOutlines);
      developer.log("List of OutLines: $listOfOutlines ");
      developer.log("List of OutLines Lenght: ${listOfOutlines.length} ");
    } else {
      Get.back();
    }
  }

  String convertListToMarkdownToc(List<String> listOfOutlines) {
    final sb = StringBuffer();
    sb.write('''### Table of Contents &nbsp; &nbsp; &nbsp;
    \n\n\n


    ''');
    for (final outline in listOfOutlines) {
      // Assuming outlines have a simple structure (e.g., chapter number - title)
      // final parts = outline.split(' - ');
      // if (parts.length == 2) {
      //   final chapterNumber = parts[0].trim();
      //   final title = parts[1].trim();
      //   // Use appropriate heading level based on your preference (e.g., ## for chapters)
      //   sb.write('## $chapterNumber - $title\n');
      // } else {
      //   // Handle outlines with unexpected structure (optional)
      //   // sb.write('Invalid outline format: $outline\n');
      // }

      sb.write('''# ${outline} 
      
      ''');
    }
    return sb.toString();
  }
  // commented by rizwan
  // Future<String?> gemeniAPICall(String request) async {
  //   final gemini = Gemini.instance;
  //   List<Content> chatContent = [];
  //   Content userInstruction =
  //       Content(parts: [Parts(text: request)], role: 'user');
  //   chatContent.add(userInstruction);

  //   try {
  //     var value = await gemini.chat(chatContent,
  //         // safetySettings: safetySettings,
  //         generationConfig: GenerationConfig(
  //           temperature: 0.5,
  //         ));
  //     String? generatedMessage = value?.output;

  //     // developer.log(value?.output ?? 'without output');
  //     // developer.log("${value}");
  //     developer.log(value?.output ?? 'No Gemini Output');
  //     developer.log(" Gemini Output ${value}");
  //     return generatedMessage;
  //   } catch (e) {
  //     developer.log('Gemini Error $e', error: e);
  //     return null;

  //     // generatedMessage = "Error Message $e";
  //   }
  // }

  // added by rizwan
  int geminiRequestCounter = 0;
  Future<String?> geminiAPICall(String request) async {
    String? generatedMessage;
    print('inside gemini api call');
    final String apiKey =
        RCVariables.geminiAPIKeysSlideAssistant[geminiRequestCounter];
    print("This is api key. $apiKey");
    List<SafetySetting>? safetySettings = <SafetySetting>[
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
    ];
    var model = GenerativeModel(
        apiKey: apiKey,
        model: RCVariables.geminiModel,
        safetySettings: safetySettings);
    // Gemini.reInitialize(apiKey: apiKey, enableDebugging: kDebugMode);

    // final Gemini gemini = Gemini.instance;
    // List<SafetySetting>? safetySettings = <SafetySetting>[
    //   SafetySetting(
    //     category: SafetyCategory.sexuallyExplicit,
    //     threshold: SafetyThreshold.blockOnlyHigh,
    //   ),
    // ];
    List<Content> chatContent = [];
    Content userInstruction = Content.text(request);
    chatContent.add(userInstruction);
    try {
      var response = await model.generateContent(chatContent,
          generationConfig: GenerationConfig(temperature: 0.5));
      generatedMessage = response.text;
      // var value = await gemini.chat(chatContent,
      //     safetySettings: safetySettings,
      //     generationConfig: GenerationConfig(
      //       temperature: 0.5,
      //     ));
      // generatedMessage = value?.output;
      print("this is generated message $generatedMessage");
      if (generatedMessage != null) {
        geminiRequestCounter = 0;

        developer.log("Gemini Response: $generatedMessage");
        return generatedMessage;
      } else {
        if (geminiRequestCounter >=
            RCVariables.geminiAPIKeysSlideAssistant.length - 1) {
          geminiRequestCounter = 0;

          return null;
        } else {
          geminiRequestCounter++;
          await Future.delayed(Duration(seconds: 1));
          String? generatedMessage = await geminiAPICall(request);
          return generatedMessage;
        }
      }
    } catch (e) {
      if (kDebugMode) developer.log('Gemini Error $e key: $apiKey  ', error: e);
      // return "Could not generate due to some techniqal issue. please try again after a few minutes ";
      if (geminiRequestCounter >=
          RCVariables.geminiAPIKeysSlideAssistant.length - 1) {
        geminiRequestCounter = 0;

        return null;
      } else {
        geminiRequestCounter++;
        await Future.delayed(Duration(seconds: 1));
        String? generatedMessage = await geminiAPICall(request);
        return generatedMessage;
      }
    }
  }

  void GoodResponse() {
    print("GoodResponse reported..");
    // feedbackMessages.add(message);
    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(SnackBar(content: mat.Text("Feedback saved successfully")));
    isFeedbackGiven.value = true;
    isPositiveFeedback.value = true;
    update();
  }

  void reportMessage(BuildContext context) {
    final TextEditingController customReasonController =
        TextEditingController();
    List<String> reasons = [
      "harmful/Unsafe",
      "Sexual Explicit Content",
      'Repetitive',
      'Hate and harrasment',
      'Misinformation',
      'Frauds and scam',
      "Spam",
      "Other",
    ];
    RxString selectedReason = "".obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: mat.Text("Report Inappropriate Message"),
          content: SingleChildScrollView(
            child: mat.Column(
              crossAxisAlignment: mat.CrossAxisAlignment.start,
              children: [
                mat.Text("Select a reason:"),
                ...reasons.map((reason) {
                  return Obx(
                    () => RadioListTile(
                      title: mat.Text(reason),
                      value: reason,
                      groupValue: selectedReason.value,
                      onChanged: (value) {
                        selectedReason.value = value!;
                        if (selectedReason != "Other") {
                          customReasonController.clear();
                        }
                      },
                    ),
                  );
                }).toList(),
                Obx(
                  () => selectedReason.value == "Other"
                      ? mat.TextField(
                          controller: customReasonController,
                          decoration: InputDecoration(
                            labelText: "Enter custom reason",
                          ),
                        )
                      : mat.Container(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: mat.Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: mat.Text("Report"),
              onPressed: () async {
                isFeedbackGiven.value = true;
                isPositiveFeedback.value = false;
                String reportReason = selectedReason.value == "Other"
                    ? customReasonController.text
                    : selectedReason.value;

                if (reportReason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: mat.Text("Please select or enter a reason.")),
                  );
                  return;
                }

                EasyLoading.show(status: "Please Wait...");
                try {
                  HomeViewCtl homeViewCTL = Get.find();
                  // Save report in Firestore
                  await FirebaseFirestore.instance
                      .collection('reported_messages')
                      .doc()
                      .set({
                    'senderId': homeViewCTL.uniqueId ?? "1234",
                    'reason': reportReason,
                    'reportedAt': DateTime.now(),
                  });
                  // await FirebaseFirestore.instance
                  //     .collection('reported_messages')
                  //     .add({
                  //   'message': message,
                  //   'senderId': homeViewCTL.uniqueId ?? "1234",
                  //   'messageId': gender_title.value,
                  //   'reason': reportReason,
                  //   'reportedAt': DateTime.now(),
                  // });

                  Navigator.of(context).pop();
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: mat.Text("Message reported successfully.")),
                  );
                } catch (e) {
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: mat.Text("Failed to report message: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    update();
  }

  List<String> parseStringToList(String text) {
    final parsedList = text.split(',');
    return parsedList;
  }

  Future<void> startWritingBook(List<String> listOfOutlines) async {
    for (String outline in listOfOutlines) {
      // Complete the request string for each chapter
      String request = '''You are writing a book on following details: 
      Main Details: $mainDetail
      Chapters: $listOfOutlines
      you are writing each chapter in individual request.
      you have to write on following chapter $outline
      Note: Do not write anything else then the required chapter.
       ''';

      String? chapterContent = await geminiAPICall(request);
      if (chapterContent != null) {
        BookPageModel page = BookPageModel(
            ChapName: outline,
            ChapData: chapterContent,
            imageType: SlideImageType.svg,
            ImagePath: AppImages.Theme2_vertical[0],
            containsImage: false);
        bookPages.add(page);
        developer.log("Title: $outline Booke Page: $chapterContent");
      } else {
        BookPageModel page = BookPageModel(
            ChapName: outline,
            ChapData:
                "Could not Write anything on this Chapter as I'am Still in learning phase.",
            imageType: SlideImageType.svg,
            ImagePath: AppImages.Theme2_vertical[0],
            containsImage: false);
        bookPages.add(page);
        developer.log("Title: $outline Booke Page: $chapterContent");
      }
    }

    isBookGenerated.value = true;
    if (isBookGenerated.value) {
      AppLovinProvider.instance.showInterstitial(() {});
    }
  }

  sharePDF(BuildContext context) async {
    EasyLoading.show(status: "Please Wait Generating PDF File..");
    String htmlContent = markdownToHtml('${bookPages[0].ChapData}');
    developer.log("HTML Content: $htmlContent");
    generatePDFFromHTML(htmlContent);

    final StringBuffer htmlContentBuffer = StringBuffer();

    final titleInHtml = markdownToHtml(TitleMarkDown.value);
    final outlineInHtml = markdownToHtml(OutlinesinMarkdown.value);

    htmlContentBuffer.write(titleInHtml);
    htmlContentBuffer.write('<div class="page-break"></div>');
    htmlContentBuffer.write(outlineInHtml);
    htmlContentBuffer.write('<div class="page-break"></div>');

    for (final BookPageModel page in bookPages) {
      htmlContentBuffer.write('<body">');
      final pageHtml = markdownToHtml(page.ChapData);
      htmlContentBuffer
          .write('<div class="page-break"></div>'); // Insert page break
      htmlContentBuffer.write(pageHtml);
      htmlContentBuffer.write('</body">');
    }

    final completeHtmlContent = htmlContentBuffer.toString();
    developer.log("Complete HTML Content: $completeHtmlContent");
    await generatePDFFromHTML(completeHtmlContent);
  }

  Future<void> generatePDFFromHTML(String htmlContent) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    try {
      final generatedPdfFile = await HtmlToPdf.convertFromHtmlContent(
        htmlContent: htmlContent,
        printPdfConfiguration: PrintPdfConfiguration(
          targetDirectory: tempPath,
          targetName: Title.value,
          printSize: PrintSize.A4,
          printOrientation: PrintOrientation.Portrait,
        ),
      );

      XFile xFile = XFile(generatedPdfFile.path);
      ShareResult shareResult = await Share.shareXFiles(
        [xFile],
        text: "A Book",
        subject: "Book Topic",
        // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      if (shareResult == ShareResultStatus.success) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess("PDF Shared Successfully");
      } else if (shareResult == ShareResultStatus.dismissed) {
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.showError("Please Try Again Later");
      EasyLoading.dismiss();
    }
  }
}
