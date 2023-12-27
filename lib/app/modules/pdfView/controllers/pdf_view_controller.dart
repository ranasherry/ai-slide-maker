import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_storage/shared_storage.dart';
// import 'package:shared_storage/saf.dart';
// import 'package:slide_maker/app/data/enum.dart';
import 'package:slide_maker/app/data/pdf_viewer_model.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';


ReceivePort _port = ReceivePort();
 RxList<PDFModel> pdf_viewer_model = <PDFModel>[].obs;
class PdfViewController extends GetxController {
  static const MethodChannel channel = MethodChannel('pdf_files');
  Rx<bool> canShowPdf = false.obs;
  Rx<bool> canShowToast = false.obs;
  Rx<bool> canShowToolbar = true.obs;
  Rx<bool> canShowScrollHead = true.obs;
  // OverlayEntry? selectionOverlayEntry;
  // PdfTextSelectionChangedDetails? textSelectionDetails;
  // Color? contextMenuColor;
  // Color? copyTextColor;
  OverlayEntry? textSearchOverlayEntry;
  // OverlayEntry? chooseFileOverlayEntry;
  // OverlayEntry? zoomPercentageOverlay;
  // OverlayEntry? settingsOverlayEntry;
  // LocalHistoryEntry? historyEntry;
  // bool needToMaximize = false;
  // bool isHorizontalModeClicked = true;
  // bool isContinuousModeClicked = true;
  String? documentPath;
  PdfInteractionMode interactionMode = PdfInteractionMode.selection;
  PdfPageLayoutMode pageLayoutMode = PdfPageLayoutMode.continuous;
  PdfScrollDirection scrollDirection = PdfScrollDirection.vertical;
  // final FocusNode focusNode = FocusNode()..requestFocus();
  // final GlobalKey<ToolbarState> toolbarKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  final PdfViewerController pdfViewerController = PdfViewerController();
  // final GlobalKey<SearchToolbarState> textSearchKey = GlobalKey();
  // final GlobalKey<TextSearchOverlayState> textSearchOverlayKey = GlobalKey();
  // late bool canShowContinuousModeOptions =
  //     pageLayoutMode == PdfPageLayoutMode.continuous;
  // late bool isLight;
  // late bool isDesktopWeb;
  // final double kWebContextMenuHeight = 32;
  // final double kMobileContextMenuHeight = 48;
  // final double kContextMenuBottom = 55;
  // final double kContextMenuWidth = 100;
  // final double kSearchOverlayWidth = 412;
  // Color? fillColor;
  // Orientation? deviceOrientation;
  // final TextEditingController textFieldController = TextEditingController();
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final FocusNode passwordDialogFocusNode = FocusNode();
  // bool passwordVisible = true;
  // String? password;
  // bool hasPasswordDialog = false;
  // String errorText = '';
  RxBool DoneScanning = false.obs;
  String privacyLink="https://clarkkentad98.wixsite.com/moonlight/post/pdf-reader";

  // String shareApp =
  //     "https://play.google.com/store/search?q=pdf.pdfreader.viewer.free.editor";
  RxList<PDFModel> pdf_viewer_model = <PDFModel>[].obs;
  RxList<DocumentFile> files = <DocumentFile>[].obs;
  StreamSubscription<DocumentFile>? _listener;
  RxBool hasPermission = true.obs;
  Uri? waURI;
  bool searchPDF = true;
  Directory? tempDir;
  List<String> alreadyDownloadedFileName = [];
  Rx<int> selectedindex = 0.obs;

  String API29Folder =
      'content://com.android.externalstorage.documents/tree/home%3A';
  String API30Folder =
      "content://com.android.externalstorage.documents/tree/home%3A";

  String kWppStatusFolderAccessed =
      "content://com.android.externalstorage.documents/tree/home%3A";

  @override
  onInit() async {
    super.onInit();
    print("current: onit");
    if (AppLovinProvider.instance.isInitialized.value) {
      AppLovinMAX.setAppOpenAdListener(AppOpenAdListener(
        onAdLoadedCallback: (ad) {
          print("onAdLoadedCallback");
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          // print("onAdLoadFailedCallback");
          print("onAdLoadFailedCallback: $error");
        },
        onAdDisplayedCallback: (ad) {
          print("onAdDisplayedCallback");
        },
        onAdDisplayFailedCallback: (ad, error) {
          AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
          print("onAdDisplayFailedCallback");
        },
        onAdClickedCallback: (ad) {
          print("onAdClickedCallback");
        },
        onAdHiddenCallback: (ad) {
          AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
        },
        onAdRevenuePaidCallback: (ad) {
          print("onAdRevenuePaidCallback");
        },
      ));

      AppLovinMAX.loadAppOpenAd(AppStrings.MAX_APPOPEN_ID);
    }

    // WidgetsBinding.instance.addObserver(this);
    //!
    // Future.delayed(Duration(seconds: 1),(){
    //   AppLovinProvider.instance.showInterstitial();
    // });
    //!
    // _bindBackgroundIsolate();
    // final SendPort? send =
    //     IsolateNameServer.lookupPortByName('downloader_send_port');
    // send!.send("Hello");
      
//   for (var i = 0; i<=100; i++) {

  // Future.delayed(Duration(seconds: 3),(){
try {
    getPdfFiles().then((value) {
      print("GetPDFFiles Done");
      nextPdf().then((value) => null);
    });
  } on Exception catch (e) {
    print("Error:$e");
  }
  // });
  
// }

// Future.delayed(Duration(seconds: 5),(){
//         try {
//   getPdfFiles().then((value) => DoneScanning.value=true);
// } on Exception catch (e) {
//   print("Error:$e");
// }
// });
      // .then((value) => print("");
    // getPermissionAndPDF();
  }

  Future nextPdf()async{
    DoneScanning.value=true;
    for (var i = 0;i<=50; i++) {
  getPdfFiles();
}
  }

  

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  

  Future SavePdfPath(pdfPath) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save an String value to 'action' key.
    await prefs.setString('pdfPath', '$pdfPath');
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> getPdfFiles() async {
    print("inside getPdfFiles");
    final pdfFiles = await channel.invokeMethod('getPdfFiles');
    print("pdf files: $pdfFiles");
    for (var eachpdfpath in pdfFiles) {
      print("each:$eachpdfpath");
      if (eachpdfpath != null) {
          
          File file = File(eachpdfpath);

          // Get file name
          String fileName = file.path.split('/').last;

          // Get file size
          int fileSize = await file.length();

          // Get date created
          DateTime dateCreated = await file.lastModified();
          
          print("Name:${fileName}");
          print("Size: ${fileSize}");
          print("Date: ${dateCreated}");

          PDFModel pdfFile = PDFModel(
                  name: fileName,
                  // file: uint8List,
                  // File: docFile,
                  path: eachpdfpath,
                  date: dateCreated.toString(),
                  // date: formatDateTime(dateCreated),
                  size: fileSize,

                  // isdownloaded: false.obs
                  );
                  pdf_viewer_model.add(pdfFile);
        }
        
      // final document = await FlutterAbsolutePath.getAbsolutePath(pdfpath);
      //     File tempFile = File(document);
      // // var fileName = path.basename(file.path);
      //   PDFModel pdfFile = PDFModel(
      //             name: fileName,
      //             // file: uint8List,
      //             // File: docFile,
      //             path: Uri.parse(file.path),
      //             date: "",
      //             size: 123

      //             // isdownloaded: false.obs
      //             );
              // whatsapp_images.add(waImage);
              // pdf_viewer_model.add(pdfFile);
        // print("PDF Path: ${file.path}");
      print(eachpdfpath);

    }
    print("After getPdfFiles");

    // print(pdfFiles);
    return pdfFiles;
  }

  // String formatDateTime(DateTime dateTime) {
  //   String formattedDate = DateFormat('MMM, dd yyyy').format(dateTime);
  //   return formattedDate;
  // }

  ShareFile(String path) async {
    // File file = File(path);
    // Uint8List fileInBytes = file.readAsBytesSync();
    // print("File Path :: ${file.path}");
    Share.shareFiles(
      [
      path
    ],
    text: "PDF"
    );
    //   Share.shareXFiles([
    //   XFile.fromData(
    //     fileInBytes,
    //   )
    // ]);
    // Share
    // Share.
  }

//       Future<void> getPermissionAndPDF() async{
// PermissionStatus status = await Permission.manageExternalStorage.request();

//     if (status == PermissionStatus.granted) {
//       print("Storage Granted");
//       //         var d =
//       // await Environment.getExternalStorageDirectory();
//       // print("Directory $d");
//       List<Directory> storages = (await getExternalStorageDirectories())!;
//       storages = storages.map((Directory e) {
//         final List<String> splitedPath = e.path.split("/");
//         return Directory(splitedPath
//             .sublist(
//                 0, splitedPath.indexWhere((element) => element == "Android"))
//             .join("/"));
//       }).toList();

//       print("1st path: ${storages[0]}");

//       // Directory root = Directory(storages[0]);
//       List<String> pdfFiles = await getPdfFiles(storages[0].path);
//     }

//   }

  //! new code

//     Future<void> getPermissionAndPDF() async{
// PermissionStatus status = await Permission.manageExternalStorage.request();

//     if (status == PermissionStatus.granted) {
//       print("Storage Granted");
//       //         var d =
//       // await Environment.getExternalStorageDirectory();
//       // print("Directory $d");
//       List<Directory> storages = (await getExternalStorageDirectories())!;
//       storages = storages.map((Directory e) {
//         final List<String> splitedPath = e.path.split("/");
//         return Directory(splitedPath
//             .sublist(
//                 0, splitedPath.indexWhere((element) => element == "Android"))
//             .join("/"));
//       }).toList();

//       print("1st path: ${storages[0]}");

//       // Directory root = Directory(storages[0]);
//       List<String> pdfFiles = await getPdfFiles(storages[0].path);
//     }

//   }

//   Future<List<String>> getPdfFiles(String rootPath) async {
//     List<String> pdfPaths = [];
//     try {
//       Directory rootDir = Directory(rootPath);
//       if (await rootDir.exists()) {
//         // pdfPaths = 
//         Stream.fromFuture(_getPdfFilesRecursively(rootDir));
        
//         // List<FileSystemEntity> files =
//         //     rootDir.listSync(recursive: false, followLinks: false);
//         // for (FileSystemEntity file in files) {
//         //   //Check if file is directory then again search recursively for pdf files

//         // }
//       }
//     } catch (e) {
//       print(e);
//     }
//     return pdfPaths;
//   }

//   Future <List<String>> _getPdfFilesRecursively(Directory dir) async {
//     List<String> pdfPaths = [];
//     List<FileSystemEntity> files =
//         dir.listSync(recursive: false, followLinks: false);
//     for (FileSystemEntity file in files) {
//       // print("PDF Path: ${file.path}");

//       if (file is File && file.path.endsWith('.pdf')) {
//         pdfPaths.add(file.path);
//         //! getting all pdf flies here
//         // var file1 = File('example.txt');
//         var bytes = file.readAsBytesSync();
//         var uint8List = Uint8List.fromList(bytes);
//         var fileName = path.basename(file.path);
//         PDFModel pdfFile = PDFModel(
//                   name: fileName,
//                   // file: uint8List,
//                   // File: docFile,
//                   path: Uri.parse(file.path),
//                   date: "",
//                   size: 123

//                   // isdownloaded: false.obs
//                   );
//               // whatsapp_images.add(waImage);
//               pdf_viewer_model.add(pdfFile);
//         print("PDF Path: ${file.path}");
//         //!
//       } else if (file is Directory) {
//         // print("Directory");

//         if (file.path.contains("Android/obb")||file.path.contains("Android/data")||file.path.contains("Android/obj")) {
//           print("Android: ${file.path}");
//         } 
//         else {
//           List<String> list2= await _getPdfFilesRecursively(file);
//           pdfPaths.addAll(list2);
//         }
//       }
//     }
    
//     return pdfPaths;
//   }
  //?
  //?
  //?

// Future<List<String>> getPdfFiles(String rootPath) async {
//   ReceivePort receivePort = ReceivePort();
//   await Isolate.spawn(_getPdfFilesIsolate, receivePort.sendPort);
//   SendPort sendPort = await receivePort.first;
//   // var pdf_viewer_model = List<PDFModel>();
//   List<String> pdfPaths = await sendReceive(sendPort, [rootPath, pdf_viewer_model]);
//   receivePort.close();
//   return pdfPaths;
// }

// void _getPdfFilesIsolate(SendPort sendPort) {
//   ReceivePort receivePort = ReceivePort();
//   sendPort.send(receivePort.sendPort);
//   receivePort.listen((data) {
//     String rootPath = data[0];
//     var pdf_viewer_model = data[1];
//     List<String> pdfPaths = _getPdfFilesRecursively(Directory(rootPath), pdf_viewer_model);
//     sendPort.send(pdfPaths);
//   });
// }

// List<String> _getPdfFilesRecursively(Directory dir, var pdf_viewer_model) {
//     List<String> pdfPaths = [];
//     List<FileSystemEntity> files =
//         dir.listSync(recursive: false, followLinks: false);
//     for (FileSystemEntity file in files) {
//       if (file is File && file.path.endsWith('.pdf')) {
//         pdfPaths.add(file.path);
//         var bytes = file.readAsBytesSync();
//         var uint8List = Uint8List.fromList(bytes);
//         var fileName = path.basename(file.path);
//         PDFModel pdfFile = PDFModel(
//                   name: fileName,
//                   // file: uint8List,
//                   // File: docFile,
//                   path: Uri.parse(file.path),
//                   date: "",
//                   size: 123

//                   // isdownloaded: false.obs
//                   );
//               pdf_viewer_model.add(pdfFile);
//         print("PDF Path: ${file.path}");
//       } else if (file is Directory) {
//         if (file.path.contains("Android/obb")||file.path.contains("Android/data")||file.path.contains("Android/obj")) {
//           print("Android: ${file.path}");
//         } else {
//           pdfPaths.addAll(_getPdfFilesRecursively(file, pdf_viewer_model));
//         }
//       }
//     }
//     return pdfPaths;
//   }

// Future<List<String>> sendReceive(SendPort port, List<dynamic> data) {
//   ReceivePort response = ReceivePort();
//   port.send([data, response.sendPort]);
//   return response.first.then((dynamic value) => value as List<String>);
// }

  //! new code

  @override
  void onReady() {
    super.onReady();
    print("current:");
    // for (var i = 0; i<=100; i++) {
  // try {
  //   getPdfFiles().then((value) => DoneScanning.value=true);
  // } on Exception catch (e) {
  //   print("Error:$e");
  // }
// }
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getReadableFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '${sizeInBytes} B';
    } else if (sizeInBytes < 1048576) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
    } else if (sizeInBytes < 1073741824) {
      return '${(sizeInBytes / 1048576).toStringAsFixed(1)}MB';
    } else {
      return '${(sizeInBytes / 1073741824).toStringAsFixed(1)}GB';
    }
  }

  Future<Uint8List?> convertDocFileToFile(DocumentFile docFile) async {
    Uint8List? memoryFile = await getDocumentContent(docFile.uri);

    return memoryFile;
  }

  final Uri url =
      Uri.parse('https://clarkkentad98.wixsite.com/moonlight/post/pdf-reader');

  Future<void> LaunchUrl() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
