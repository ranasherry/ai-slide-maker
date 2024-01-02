import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

// import 'package:webview_flutter/webview_flutter.dart';

import '../../pdfView/controllers/pdf_view_controller.dart';

class ShowPPTView extends GetView<PdfViewController> {
  // WebViewController webViewController = WebViewController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // webViewController.loadRequest(Uri.parse(
    //     'https://docs.google.com/gview?embedded=true&url=${controller.pdf_viewer_model[controller.selectedindex.value].path}'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Electric_Blue_color,
        title: Text(
          "PDF Viewer",
          style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
        ),
        actions: [
          Row(
            children: [
              // Padding(
              //   padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 5),
              //   child: GestureDetector(
              //       onTap: () {
              //         // Get.toNamed(Routes.PDF_EDITOR,arguments: "${controller.pdf_viewer_model[controller.selectedindex.value].path.toString()}");
              //          //! share file using unitlist
              //         // Share.shareXFiles([
              //         //   XFile.fromData(
              //         //     controller
              //         //         .pdf_viewer_model[controller.selectedindex.value]
              //         //         .file,
              //         //   )
              //         // ]);
              //       },
              //       child: Icon(Icons.mode_edit_outlined)),
              // ),
              Padding(
                padding:
                    EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 5),
                child: GestureDetector(
                    onTap: () {
                      controller.ShareFile(controller
                          .pdf_viewer_model[controller.selectedindex.value].path
                          .toString());
                      //! share file using unitlist
                      // Share.shareXFiles([
                      //   XFile.fromData(
                      //     controller
                      //         .pdf_viewer_model[controller.selectedindex.value]
                      //         .file,
                      //   )
                      // ]);
                    },
                    child: Icon(Icons.share)),
              ),
            ],
          ),
          // Icon(Icons.print_rounded),
        ],
      ),
      // body: SfPdfViewer.file(
      //     File("storage/emulated/0/Download/gis_succinctly.pdf")),
      body: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: Column(
          children: [
            // Expanded(
            //     child: FutureBuilder<Uint8List>(
            //   future: controller
            //               .pdf_viewer_model[controller.selectedindex.value]
            //               .path !=
            //           null
            //       ? convertPPTxToPDF(controller
            //           .pdf_viewer_model[controller.selectedindex.value].path)
            //       : null,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return SfPdfViewer.memory(
            //         snapshot.data!,
            //         controller: controller.pdfViewerController,
            //         key: controller.pdfViewerKey,
            //         interactionMode: controller.interactionMode,
            //         scrollDirection: controller.scrollDirection,
            //         pageLayoutMode: controller.pageLayoutMode,
            //       );
            //     } else if (snapshot.hasError) {
            //       print("Error converting PPTX to PDF: ${snapshot.error}");
            //       return Center(
            //           child: Text(
            //               'Error converting PPTX to PDF: ${snapshot.error}'));
            //     } else {
            //       return Center(child: CircularProgressIndicator());
            //     }
            //   },
            // )

            //     //    SfPdfViewer.file(File(controller
            //     //       .pdf_viewer_model[controller.selectedindex.value].path)),
            //     // ),
            //     // Expanded(
            //     //   child: Obx(
            //     //     () => SfPdfViewer.memory(
            //     //       controller
            //     //           .pdf_viewer_model[controller.selectedindex.value].file,
            //     //       controller: controller.pdfViewerController,
            //     //       key: controller.pdfViewerKey,
            //     //       interactionMode: controller.interactionMode,
            //     //       scrollDirection: controller.scrollDirection,
            //     //       pageLayoutMode: controller.pageLayoutMode,
            //     //     ),
            //     //   ),
            //     // ),
            //     )
          ],
        ),
      ),
    );
  }

  Future<Uint8List> convertPPTxToPDF(String pptxPath) async {
    print("Inside convertPPTxToPDF");
    final Uint8List pptFile = File(pptxPath).readAsBytesSync();
    final tempDir = await getTemporaryDirectory();
    // final PdfDocument document =
    //     PdfDocument(inputBytes: File(pptxPath).readAsBytesSync());

    try {
      print("Inside try");
      // final pdfBytes = (await document.save()) as Uint8List;
      // return pdfBytes;

      // final List<int> bytes = document.saveSync();

      final File file = await File('${tempDir.path}/pdfToPpt.pdf').create();
      await file.writeAsBytes(pptFile, flush: true);
      final unitBytes = await file.readAsBytes();

      //Dispose the document.
      // document.dispose();
      print("Unint8List: $unitBytes");
      return unitBytes;
      //Save and launch the file.
      // Return the PDF as Uint8List
    } finally {
      // document.dispose(); // Ensure proper disposal of the document
    }
  }
}
