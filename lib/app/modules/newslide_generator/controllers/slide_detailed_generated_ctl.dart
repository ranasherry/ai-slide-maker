import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
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
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';

class SlideDetailedGeneratedCTL extends GetxController {
  //TODO: Implement BookWriterController

  RxList<BookPageModel> bookPages = <BookPageModel>[].obs;
  // String mainDetail = "";
  String mainTopic = "";
  RxBool isBookGenerated = false.obs;

  RxString Title = "".obs;

  RxString OutlinesinMarkdown = "".obs;
  RxString TitleMarkDown = "".obs;

  int tokensConsumed = 0;

  @override
  void onInit() {
    super.onInit();

    final argumunts = Get.arguments;

    String mainTopic = argumunts[0] as String;
    Title.value = mainTopic;
    RxList<String> listOfOutlines = argumunts[1] as RxList<String>;
    // String auther = argumunts[1];
    // mainDetail = argumunts[2];
    // Title.value = argumunts[3];

//     TitleMarkDown.value = '''

// # ${Title.value} \n\n

// ## By ${auther} ''';

//     print("Request: $apirequest \n Auther: $auther");

    startGeneratingSlide(listOfOutlines);
    // generateBookOutlines(apirequest);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  int geminiRequestCounter = 0;
  Future<String?> gemeniAPICall(String request) async {
    developer.log("RequestCounter: $geminiRequestCounter");
    final apiKey = RCVariables.geminiAPIKeys[geminiRequestCounter];
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          maxOutputTokens: 200,
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

          return "Could not generate this slide due to busy server. please try again after a few minutes ";
        } else {
          geminiRequestCounter++;
          String? generatedMessage = await gemeniAPICall(request);
          return generatedMessage;
        }
      }
    } catch (e) {
      developer.log('Gemini Error $e ', error: e);
      // return "Could not generate due to some techniqal issue. please try again after a few minutes ";
      if (geminiRequestCounter >= RCVariables.geminiAPIKeys.length - 1) {
        geminiRequestCounter = 0;

        return "Could not generate this slide due to busy server. please try again after a few minutes ";
      } else {
        geminiRequestCounter++;
        String? generatedMessage = await gemeniAPICall(request);
        return generatedMessage;
      }

      // generatedMessage = "Error Message $e";
    }
  }

  List<String> parseStringToList(String text) {
    final parsedList = text.split(',');
    return parsedList;
  }

  Future<void> startGeneratingSlide(List<String> listOfOutlines) async {
    for (String outline in listOfOutlines) {
      // Complete the request string for each chapter
      String request =
          '''You are writing Generating a Presentation Slide on the following details: 
      Main Presentation Topic: $mainTopic
      Individual Siled Titles: $listOfOutlines
      you are writing each Slide in individual request.
      you have to write on following Slide Topic $outline
      Note: Do not write anything else then the required Slide. Your response must be in mark down format and only in less then 70 words. if possible try to compare thing and make tables if needed. there must be very few description for the content as a single slide can not have a lot of text.
       ''';

      String? chapterContent = await gemeniAPICall(request);
      if (chapterContent != null) {
        BookPageModel page =
            BookPageModel(ChapName: outline, ChapData: chapterContent);
        bookPages.add(page);
        developer.log("Title: $outline Booke Page: $chapterContent");
      } else {
        BookPageModel page = BookPageModel(
            ChapName: outline,
            ChapData:
                "Could not Write anything on this Chapter as I'am Still in learning phase.");
        bookPages.add(page);
        developer.log("Title: $outline Booke Page: $chapterContent");
      }
    }

    isBookGenerated.value = true;
    if (isBookGenerated.value) {
      AppLovinProvider.instance.showInterstitial(() {});

      if (RevenueCatService().currentEntitlement.value == Entitlement.paid) {
        List<BookPageModel> listToUpload = bookPages;

        final historyItem = SlideItem(
            slideTitle: Title.value,
            listOfPages: listToUpload,
            timestamp: DateTime.now().millisecondsSinceEpoch);

        FirestoreService()
            .addHistoryItem(FirestoreService().UserID, historyItem);

        // FirestoreService()
        //     .increaseGenerationCount(uid: FirestoreService().UserID);
        FirestoreService()
            .increaseTokensConsumed(
          uid: FirestoreService().UserID,
          increament: tokensConsumed,
        )
            .then((value) {
          tokensConsumed = 0;
        });
      }
      HomeViewCtl homeViewCtl = Get.find();
      homeViewCtl.ShowFeedbackBottomSheet();
    }
  }

  sharePDF(BuildContext context) async {
    EasyLoading.show(status: "Please Wait Generating PDF File..");
    // String htmlContent = markdownToHtml('${bookPages[0].ChapData}');
    // developer.log("HTML Content: $htmlContent");
    // generatePDFFromHTML(htmlContent);

    final StringBuffer htmlContentBuffer = StringBuffer();

    // final titleInHtml = markdownToHtml(TitleMarkDown.value);
    // final outlineInHtml = markdownToHtml(OutlinesinMarkdown.value);

    // htmlContentBuffer.write(titleInHtml);
    // htmlContentBuffer.write('<div class="page-break"></div>');
    // htmlContentBuffer.write(outlineInHtml);
    // htmlContentBuffer.write('<div class="page-break"></div>');

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
    developer.log("Generating PDF");
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

        FirebaseAnalytics.instance
            .logShare(contentType: "pdf", itemId: "ai_pdf", method: "android");
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
