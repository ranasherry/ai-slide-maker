import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:easy_docs_viewer/easy_docs_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slide_maker/app/modules/controllers/home_view_ctl.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/modules/pdfView/controllers/pdf_view_controller.dart';
import 'package:slide_maker/app/modules/showppt/controllers/show_p_p_t_controller.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

// import 'package:webview_flutter/webview_flutter.dart';

import '../../pdfView/controllers/pdf_view_controller.dart';

class ShowPPTView extends GetView<ShowPPTController> {
  // WebViewController webViewController = WebViewController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // webViewController.loadRequest(Uri.parse(
    //     'https://docs.google.com/gview?embedded=true&url=${controller.pdf_viewer_model[controller.selectedindex.value].path}'));
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        // color: Colors.amber,
        child: Center(
            child: Obx(() => RevenueCatService().currentEntitlement.value ==
                    Entitlement.paid
                ? Container()
                : MaxAdView(
                    adUnitId: Platform.isAndroid
                        ? AppStrings.MAX_BANNER_ID
                        : AppStrings.IOS_MAX_BANNER_ID,
                    adFormat: AdFormat.banner,
                    listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                      print('Banner widget ad loaded from ' + ad.networkName);
                    }, onAdLoadFailedCallback: (adUnitId, error) {
                      print('Banner widget ad failed to load with error code ' +
                          error.code.toString() +
                          ' and message: ' +
                          error.message);
                    }, onAdClickedCallback: (ad) {
                      print('Banner widget ad clicked');
                    }, onAdExpandedCallback: (ad) {
                      print('Banner widget ad expanded');
                    }, onAdCollapsedCallback: (ad) {
                      print('Banner widget ad collapsed');
                    })))),
      ),

      appBar: AppBar(
        // backgroundColor: AppColors.Electric_Blue_color,
        title: Text(
          "PPT Viewer",
          style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
        ),
        actions: [
          // Row(
          //   children: [
          //     Padding(
          //       padding:
          //           EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 5),
          //       child: GestureDetector(onTap: () {}, child: Icon(Icons.share)),
          //     ),
          //   ],
          // ),
          // Icon(Icons.print_rounded),
        ],
      ),
      // body: SfPdfViewer.file(
      //     File("storage/emulated/0/Download/gis_succinctly.pdf")),
      body: Container(
        margin: EdgeInsets.only(bottom: 60),
        // child: Obx(() => controller.isUploaded.value
        //     ? EasyDocsViewer(
        //         url: controller.uploadedUrl.value,
        //       )
        //     : Container(
        //         // child: CircularProgressIndicator(),
        //         child: _LoadingPPT(),
        //       )),
      ),
    );
  }

  Widget _LoadingPPT() {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          verticalSpace(SizeConfig.blockSizeVertical),
          Text(
            "Please wait...",
            style: TextStyle(color: Colors.black, fontSize: 16),
          )
        ],
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
