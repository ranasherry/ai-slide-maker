import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pptx/flutter_pptx.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:html_to_pdf/html_to_pdf.dart';
import 'package:markdown/markdown.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer' as developer;

import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/helping_enums.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/home/slide_assistant.dart';
import 'package:slide_maker/app/modules/newslide_generator/views/helping_widget.dart/mymarkdown_widget.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';

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
        final isTable = ComFunction().containsTable(chapterContent);
        BookPageModel page = BookPageModel(
            ChapName: outline,
            ChapData: chapterContent,
            imageType: SlideImageType.svg,
            ImagePath: AppImages.Theme2_vertical[0],
            containsImage: isTable ? false : true);
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

  sharePPTX(mat.BuildContext context) async {
    await generatePPTXFile();
  }

  sharePDF(mat.BuildContext context) async {
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

  Future<void> generatePPTXFile() async {
    EasyLoading.show(status: "Generating PPTX File");
    try {
      final pres = await createPresentation();

      await downloadPresentation(pres);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError("Could not Generate Slide");
      // TODO
    }
  }

  Future<void> downloadPresentation(FlutterPowerPoint pres) async {
    final bytes = await pres.save();
    if (bytes == null) {
      EasyLoading.dismiss();
      return;
    }
    downloadFile('presentation.pptx', bytes);
  }

  Future<FlutterPowerPoint> createPresentation() async {
    final pres = FlutterPowerPoint();

//? Title Slide
    await pres.addWidgetSlide(
      (size) => MyMarkDownWidget(
        page: BookPageModel(
            ChapName: Title.value,
            ChapData: "",
            imageType: SlideImageType.svg,
            ImagePath: AppImages.Theme2_horizontal[0],
            containsImage: true),
        size: size,
        isTitle: true,
      ),
    );

    int i = 1;
    for (final BookPageModel page in bookPages) {
      developer.log("Page Data: ${page.ChapData}");
      await pres.addWidgetSlide(
        (size) => MyMarkDownWidget(
          page: page,
          size: size,
          isTitle: false,
        ),
      );

      double value = (i / bookPages.length);
      EasyLoading.showProgress(value, status: "Generating PPTX");
      i++;
    }

    pres.showSlideNumbers = true;

    return pres;
  }

  // mat.Container buildMarkdown(mat.BuildContext context, String data) {
  //   final isDark = mat.Theme.of(context).brightness == mat.Brightness.dark;
  //   final config =
  //       isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
  //   final codeWrapper =
  //       (child, text, language) => CodeWrapperWidget(child, text, language);

  //   // PreConfig(textStyle: );
  //   return mat.Container(
  //     width: SizeConfig.screenWidth,
  //     // height: SizeConfig.blockSizeVertical * 50,
  //     // decoration:
  //     //     BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
  //     child: MarkdownWidget(
  //       shrinkWrap: true,
  //       physics: mat.NeverScrollableScrollPhysics(),
  //       data: data,
  //       config: config.copy(configs: [
  //         isDark
  //             ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
  //             : PreConfig(
  //                     textStyle: mat.TextStyle(
  //                         color: mat.Theme.of(context).colorScheme.primary))
  //                 .copy(wrapper: codeWrapper)
  //       ]),
  //     ),
  //   );
  // }

  Future<void> downloadFile(String filename, Uint8List bytes) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Get the temporary directory for safe file creation

      // Create a new file with the specified filename
      final file = File('$tempPath/$filename');

      // Write the bytes to the file
      await file.writeAsBytes(bytes);

      // Share the downloaded file using ShareXFile
      final xFile = XFile(file.path);
      ShareResult result = await Share.shareXFiles([xFile]);
      if (result.status == ShareResultStatus.success) {
        EasyLoading.dismiss();
        AppLovinProvider.instance.showInterstitial(() {});
      } else {
        EasyLoading.dismiss();
      }

      print('File downloaded successfully: ${file.path}');
    } on FileSystemException catch (e) {
      // Handle file system errors (e.g., insufficient storage)
      print('Error downloading file: $e');
      EasyLoading.dismiss();
    } catch (e) {
      // Handle other unexpected errors
      print('Unexpected error: $e');
      EasyLoading.dismiss();
    }
  }
}
