import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../pdfView/controllers/pdf_view_controller.dart';
import '../controllers/show_p_d_f_controller.dart';

class ShowPDFView extends GetView<PdfViewController> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE7EBFA),
        elevation: 0,
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
            Expanded(
              child: PDFView(
                filePath: controller
                    .pdf_viewer_model[controller.selectedindex.value].path,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                onRender: (_pages) {
                  // setState(() {
                  //   pages = _pages;
                  //   isReady = true;
                  // });
                },
                onError: (error) {
                  print(error.toString());
                },
                onPageError: (page, error) {
                  print('$page: ${error.toString()}');
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  // _controller.complete(pdfViewController);
                },
                onPageChanged: (int? page, int? total) {
                  print('page change: $page/$total');
                },
              ),
            ),
            // Expanded(
            //   child: SfPdfViewer.file(File(controller
            //       .pdf_viewer_model[controller.selectedindex.value].path)),
            // ),
            // Expanded(
            //   child: Obx(
            //     () => SfPdfViewer.memory(
            //       controller
            //           .pdf_viewer_model[controller.selectedindex.value].file,
            //       controller: controller.pdfViewerController,
            //       key: controller.pdfViewerKey,
            //       interactionMode: controller.interactionMode,
            //       scrollDirection: controller.scrollDirection,
            //       pageLayoutMode: controller.pageLayoutMode,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
