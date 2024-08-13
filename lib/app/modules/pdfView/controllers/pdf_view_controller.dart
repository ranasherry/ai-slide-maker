import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_storage/shared_storage.dart';
// import 'package:shared_storage/saf.dart';
// import 'package:slide_maker/app/data/enum.dart';
import 'package:slide_maker/app/data/pdf_viewer_model.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/utills/app_strings.dart';

import 'package:url_launcher/url_launcher.dart';

ReceivePort _port = ReceivePort();
RxList<PDFModel> pdf_viewer_model = <PDFModel>[].obs;

class PdfViewController extends GetxController {
  // static const MethodChannel channel = MethodChannel('pdf_files');
  // Rx<bool> canShowPdf = false.obs;
  // Rx<bool> canShowToast = false.obs;
  // Rx<bool> canShowToolbar = true.obs;
  // Rx<bool> canShowScrollHead = true.obs;
  // // OverlayEntry? selectionOverlayEntry;
  // // PdfTextSelectionChangedDetails? textSelectionDetails;
  // // Color? contextMenuColor;
  // // Color? copyTextColor;
  // OverlayEntry? textSearchOverlayEntry;

  // String? documentPath;
  // RxList<DocumentFile> files = <DocumentFile>[].obs;
  // StreamSubscription<DocumentFile>? _listener;

  // RxBool DoneScanning = false.obs;
  // String privacyLink =
  //     "https://clarkkentad98.wixsite.com/moonlight/post/pdf-reader";

  // // String shareApp =
  // //     "https://play.google.com/store/search?q=pdf.pdfreader.viewer.free.editor";
  // RxList<PDFModel> pdf_viewer_model = <PDFModel>[].obs;
  // // RxList<DocumentFile> files = <DocumentFile>[].obs;
  // // StreamSubscription<DocumentFile>? _listener;
  // RxBool hasPermission = true.obs;
  // Uri? waURI;
  // bool searchPDF = true;
  // Directory? tempDir;
  // List<String> alreadyDownloadedFileName = [];
  // Rx<int> selectedindex = 0.obs;

  // String API29Folder =
  //     'content://com.android.externalstorage.documents/tree/home%3A';
  // String API30Folder =
  //     "content://com.android.externalstorage.documents/tree/home%3A";

  // String kWppStatusFolderAccessed =
  //     "content://com.android.externalstorage.documents/tree/home%3A";

//   @override
//   onInit() async {
//     super.onInit();
//     print("current: onit");
//     if (AppLovinProvider.instance.isInitialized.value) {
//       AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
//         onAdLoadedCallback: (ad) {
//           print("onAdLoadedCallback");
//         },
//         onAdLoadFailedCallback: (adUnitId, error) {
//           // print("onAdLoadFailedCallback");
//           print("onAdLoadFailedCallback: $error");
//         },
//         onAdDisplayedCallback: (ad) {
//           print("onAdDisplayedCallback");
//         },
//         onAdDisplayFailedCallback: (ad, error) {
//           AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
//           print("onAdDisplayFailedCallback");
//         },
//         onAdClickedCallback: (ad) {
//           print("onAdClickedCallback");
//         },
//         onAdHiddenCallback: (ad) {
//           AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
//         },
//         onAdRevenuePaidCallback: (ad) {
//           print("onAdRevenuePaidCallback");
//         },
//       ));

//       AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
//     }

//     // try {
//     //   getPdfFiles().then((value) {
//     //     print("GetPDFFiles Done");
//     //     nextPdf().then((value) => null);
//     //   });
//     // } on Exception catch (e) {
//     //   print("Error:$e");
//     // }
//   }

//   openSafFolder() async {
//     final uri = await openDocumentTree(
//       initialUri: Uri.parse(kWppStatusFolderAccessed),
//     );
// // kWppStatusFolder=url.toString();
//     // waURI = uri;
//     // print("URL: $waURI");

//     if (uri == null) return;

//     // files = null;
//     files.clear();

//     loadFiles(uri);
//   }

//   void loadFiles(Uri uri) async {
//     hasPermission.value = await canRead(uri) ?? false;

//     if (!hasPermission.value) {
//       return;
//     }
//     final folderUri = Uri.parse(kWppStatusFolderAccessed);

//     const columns = [
//       DocumentFileColumn.displayName,
//       DocumentFileColumn.size,
//       DocumentFileColumn.lastModified,
//       DocumentFileColumn.mimeType,
//       // The column below is a optional column
//       // you can wether include or not here and
//       // it will be always available on the results
//       DocumentFileColumn.id,
//     ];
//     final fileListStream = listFiles(uri, columns: columns);

//     _listener = fileListStream.listen((docFile) async {
//       print("File Name: ${docFile.name} ");

//       // Uint8List? FileToStoreInList = await convertDocFileToFile(docFile);

//       // if (FileToStoreInList != null) {
//       if (docFile.name!.endsWith(".pdf")) {
//         print("Image: ${docFile.name}");
//         PDFModel pdf = PDFModel(
//             name: docFile.name!,
//             date: docFile.size!.toString(),
//             path: docFile.uri.toString(),
//             size: docFile.size!);
//         pdf_viewer_model.add(pdf);
//         // ImageFiles.add(FileToStoreInList);
//       }

//       //? Add Video List

//       // }
//     }, onDone: () {
//       // files.value = [...?files];
//       // _files.
//       print("Files1: ${pdf_viewer_model.length}");
//     });
//   }

//   Future nextPdf() async {
//     DoneScanning.value = true;
//     for (var i = 0; i <= 50; i++) {
//       getPdfFiles();
//     }
//   }

//   @override
//   void dispose() {
//     // WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   Future SavePdfPath(pdfPath) async {
//     // Obtain shared preferences.
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     // Save an String value to 'action' key.
//     await prefs.setString('pdfPath', '$pdfPath');
//   }

//   Future<void> launchInBrowser(Uri url) async {
//     if (!await launchUrl(
//       url,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw 'Could not launch $url';
//     }
//   }

//   Future<void> getPdfFiles() async {
//     print("inside getPdfFiles");
//     final pdfFiles = await channel.invokeMethod('getPdfFiles');
//     print("pdf files: $pdfFiles");
//     for (var eachpdfpath in pdfFiles) {
//       print("each:$eachpdfpath");
//       if (eachpdfpath != null) {
//         File file = File(eachpdfpath);

//         // Get file name
//         String fileName = file.path.split('/').last;

//         // Get file size
//         int fileSize = await file.length();

//         // Get date created
//         DateTime dateCreated = await file.lastModified();

//         print("Name:${fileName}");
//         print("Size: ${fileSize}");
//         print("Date: ${dateCreated}");

//         PDFModel pdfFile = PDFModel(
//           name: fileName,
//           // file: uint8List,
//           // File: docFile,
//           path: eachpdfpath,
//           date: dateCreated.toString(),
//           // date: formatDateTime(dateCreated),
//           size: fileSize,

//           // isdownloaded: false.obs
//         );
//         pdf_viewer_model.add(pdfFile);
//       }

//       // final document = await FlutterAbsolutePath.getAbsolutePath(pdfpath);
//       //     File tempFile = File(document);
//       // // var fileName = path.basename(file.path);
//       //   PDFModel pdfFile = PDFModel(
//       //             name: fileName,
//       //             // file: uint8List,
//       //             // File: docFile,
//       //             path: Uri.parse(file.path),
//       //             date: "",
//       //             size: 123

//       //             // isdownloaded: false.obs
//       //             );
//       // whatsapp_images.add(waImage);
//       // pdf_viewer_model.add(pdfFile);
//       // print("PDF Path: ${file.path}");
//       print(eachpdfpath);
//     }
//     print("After getPdfFiles");

//     // print(pdfFiles);
//     return pdfFiles;
//   }

//   // String formatDateTime(DateTime dateTime) {
//   //   String formattedDate = DateFormat('MMM, dd yyyy').format(dateTime);
//   //   return formattedDate;
//   // }

//   ShareFile(String path) async {
//     Share.shareFiles([path], text: "PDF");
//   }

//   //! new code

//   @override
//   void onReady() {
//     super.onReady();
//     print("current:");
//     // for (var i = 0; i<=100; i++) {
//     // try {
//     //   getPdfFiles().then((value) => DoneScanning.value=true);
//     // } on Exception catch (e) {
//     //   print("Error:$e");
//     // }
// // }
//   }

//   @override
//   void onClose() {
//     super.onClose();
//     resetMethodChannel();
//   }

//   String getReadableFileSize(int sizeInBytes) {
//     if (sizeInBytes < 1024) {
//       return '${sizeInBytes} B';
//     } else if (sizeInBytes < 1048576) {
//       return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
//     } else if (sizeInBytes < 1073741824) {
//       return '${(sizeInBytes / 1048576).toStringAsFixed(1)}MB';
//     } else {
//       return '${(sizeInBytes / 1073741824).toStringAsFixed(1)}GB';
//     }
//   }

//   // Future<Uint8List?> convertDocFileToFile(DocumentFile docFile) async {
//   //   Uint8List? memoryFile = await getDocumentContent(docFile.uri);

//   //   return memoryFile;
//   // }

//   final Uri url =
//       Uri.parse('https://clarkkentad98.wixsite.com/moonlight/post/pdf-reader');

//   Future<void> LaunchUrl() async {
//     if (!await launchUrl(url)) {
//       throw 'Could not launch $url';
//     }
//   }

//   void resetMethodChannel() async {
//     final result = await channel.invokeMethod('resetMethodChannel');
//     print("Reset MethodChannel: $result");
//   }

//   void deleteFile(String path, int index) async {
//     EasyLoading.show(status: "Deleting..");

//     try {
//       final file = File(path);
//       if (await file.exists()) {
//         await file.delete();
//         EasyLoading.dismiss();
//         print("Length: Before${pdf_viewer_model.length}");
//         pdf_viewer_model.removeAt(index);
//         // pdf_viewer_model.remove(path);
//         print("Length: After ${pdf_viewer_model.length}");

//         EasyLoading.showSuccess("Deleted Successfully");
//         print("File deleted successfully: $path");
//       } else {
//         EasyLoading.showError("File not found");
//         print("File not found: $path");
//       }
//     } catch (e) {
//       EasyLoading.showError("Error deleting file:");

//       print("Error deleting file: $e");
//     }
//   }
}
