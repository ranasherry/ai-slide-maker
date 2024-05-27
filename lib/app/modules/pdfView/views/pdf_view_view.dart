import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:search_page/search_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_storage/shared_storage.dart';
import 'package:slide_maker/app/data/pdf_viewer_model.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/pdf_view_controller.dart';

class PdfViewView extends GetView<PdfViewController> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        // backgroundColor: Color(0xFFE7EBFA),
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
                    }))),
          ),
        ),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
          shadowColor: Colors.grey,
          elevation: 0,
          // leading: Icon(Icons.adf_scanner_outlined),
          actions: [
            GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: SearchPage(
                        barTheme: ThemeData(
                            inputDecorationTheme: InputDecorationTheme(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            textSelectionTheme: TextSelectionThemeData(
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            // appBarTheme: AppBarTheme(color: Color(0xFFc20000))),
                            appBarTheme: AppBarTheme(
                              color: Theme.of(context).colorScheme.background,
                              iconTheme: IconThemeData(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, // Change back button color here
                              ),
                            )),
                        onQueryUpdate: print,
                        items: controller.pdf_viewer_model,
                        searchLabel: 'Search file',
                        searchStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suggestion: Center(
                          child: Text(
                            'Search file by name',
                            // style: TextStyle(
                            //   color: Theme.of(context).colorScheme.primary,
                            // ),
                          ),
                        ),
                        failure: Center(
                          child: Text(
                            'No file found',
                            // style: TextStyle(
                            //   color: Theme.of(context).colorScheme.primary,
                            // ),
                          ),
                        ),
                        filter: (file) => [
                              file.name
                              // file.name,
                              // file.surname,
                              // file.age.toString(),
                            ],
                        sort: (a, b) => a.name.compareTo(b.name),
                        builder: (person) => pdfdocitem(person)),
                  );
                },
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                )),
            horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              itemBuilder: (BuildContext) {
                return [
                  PopupMenuItem(
                      child: GestureDetector(
                    onTap: () {
                      print("App share");
                      Share.share(
                          'https://play.google.com/store/apps/details?id=com.genius.aislides.generator',
                          subject: 'Look what I found on PlayStore!');
                      // Share.share(controller.shareApp);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.share,
                            color: Theme.of(context).colorScheme.primary),
                        horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                        Text(
                          "Share",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  )),
                  // PopupMenuItem(
                  //     child: Row(
                  //   children: [
                  //     Icon(
                  //       Icons.rate_review,
                  //       color: Colors.redAccent,
                  //     ),
                  //     horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                  //     Text(
                  //       "Rate Us",
                  //       style: TextStyle(color: Colors.grey.shade700),
                  //     ),
                  //   ],
                  // )),

                  PopupMenuItem(
                      child: Row(
                    children: [
                      Icon(Icons.privacy_tip,
                          color: Theme.of(context).colorScheme.primary),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                      GestureDetector(
                        onTap: () {
                          // controller.LaunchUrl();
                          Uri uri = Uri.parse(controller.privacyLink);

                          controller.launchInBrowser(uri);
                        },
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ))
                ];
              },
            )

            // Icon(Icons.more_vert_outlined)
          ],
          backgroundColor: Theme.of(context).colorScheme.background,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),

              // gradient: LinearGradient(
              //   colors: [
              //     AppColors.icon_color,
              //     AppColors.Electric_Blue_color
              //     // Color(0xFFC20000),
              //     // Colors.redAccent,
              //   ],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // )
            ),
          ),

          // bottom: TabBar(
          //   overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          //   splashFactory: NoSplash.splashFactory,
          //   indicatorColor: AppColors.Electric_Blue_color,
          //   // indicatorColor: Colors.redAccent,
          //   indicatorSize: TabBarIndicatorSize.label,
          //   tabs: [
          //     Tab(
          //       child: Text(
          //         "",
          //       ),
          //       // text: "",
          //     ),
          //   ],
          // ),

          title: Text(
            'PDF Reader',
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            GestureDetector(
                onTap: () {
                  AppLovinProvider.instance.showInterstitial(() {});
                },
                child: pdfdoc())
          ],
        ),
      ),
    );
  }

  Container pdfdoc() {
    return Container(
      child: Obx(() => !controller.pdf_viewer_model.isEmpty
          ? Container(
              child: Obx(() => controller.pdf_viewer_model.isEmpty
                  ? Container(
                      child: Center(
                          child: Image.asset(
                        AppImages.empty,
                        scale: 5,
                      )),
                    )
                  : _pdfdoclist()),
            )
          : Container(
              height: SizeConfig.screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                        child: Image.asset(
                      AppImages.empty,
                      scale: 5,
                    )),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  ElevatedButton(
                      onPressed: () {
                        controller.openSafFolder();
                      },
                      child: Text("Grant Permission"))
                ],
              ),
            )),
    );
  }

  // Container pdfdoc() {
  //   return Container(
  //     child: Obx(() => controller.DoneScanning.value
  //         ? Container(
  //             child: Obx(() => controller.pdf_viewer_model.isEmpty
  //                 ? Container(
  //                     child: Center(
  //                         child: Image.asset(
  //                       AppImages.empty,
  //                       scale: 5,
  //                     )),
  //                   )
  //                 : _pdfdoclist()),
  //           )
  //         : Container(
  //             margin: EdgeInsets.only(bottom: 60),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     CircularProgressIndicator(),
  //                     SizedBox(
  //                       height: SizeConfig.screenHeight * 0.03,
  //                     ),
  //                     Text("Scanning PDF from your Phone")
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           )),
  //   );
  // }

  Obx _pdfdoclist() {
    return Obx(
      () => Stack(children: [
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.blockSizeHorizontal * 2, bottom: 60),
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: ListView.separated(
            itemCount: controller.pdf_viewer_model.length,
            itemBuilder: (BuildContext, int index) {
              return Container(
                  child: _pdfdocitem(
                      BuildContext, index, controller.pdf_viewer_model[index]));
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          ),
        ),
      ]),
    );
  }

  // String formatDateTime(DateTime dateTime) {
  //   String formattedDate = DateFormat('MMM, dd yyyy').format(dateTime);
  //   return formattedDate;
  // }

  Padding _pdfdocitem(BuildContext context, int index, pdfModel) {
    String date =
        //!
        controller.pdf_viewer_model[index].date;
    // ??
    // DateTime.now();

    // String date = formatDateTime(d);
//!
    final namewithout =
        // "NAME";
        basenameWithoutExtension(
            controller.pdf_viewer_model[index].name.toString());

    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 1,
          right: SizeConfig.blockSizeHorizontal * 1,
          top: SizeConfig.blockSizeHorizontal * 0,
          bottom: SizeConfig.blockSizeHorizontal * 0),
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            // openDocumentFile(controller.pdf_viewer_model[index].File.uri);
            controller.selectedindex.value = index;
            Get.toNamed(Routes.SHOW_P_D_F);
            // Get.toNamed(Routes.ShowPPTView);
            print("Passing object: ${pdfModel.path}");
            // Get.toNamed(Routes.ShowPPTView, arguments: pdfModel);
          },
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 1,
                right: SizeConfig.blockSizeHorizontal * 1),
            child: Container(
              height: SizeConfig.blockSizeHorizontal * 18,
              width: SizeConfig.blockSizeHorizontal * 99,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.blockSizeHorizontal * 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.red.shade100,
                      ),
                      child: Image.asset(
                        AppImages.doc,
                        scale: 9,
                      )),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth * 0.5,
                        height: SizeConfig.screenWidth * 0.05,
                        child: Text(
                          "${namewithout}",
                          // "${controller.documentPath}",

                          // controller.pdf_viewer_model[index].name,
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      // verticalSpace(SizeConfig.blockSizeVertical * 0),
                      Text(
                        "${date}",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                            color: Colors.grey),
                      ),
                      verticalSpace(SizeConfig.blockSizeHorizontal * 1),
                      Text(
                        controller.getReadableFileSize(
                            controller.pdf_viewer_model[index].size),
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 2.5,
                            color: Colors.grey),
                      )
                    ],
                  ),
                  Spacer(),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       top: SizeConfig.blockSizeHorizontal * 5),
                  //   child: PopupMenuButton(
                  //     icon: Icon(
                  //       Icons.more_horiz_outlined,
                  //     ),
                  //     itemBuilder: (BuildContext) {
                  //       return [
                  //         PopupMenuItem(
                  //             child: GestureDetector(
                  //           onTap: () {
                  //             controller.selectedindex.value = index;
                  //             Get.toNamed(Routes.SHOW_P_D_F);
                  //           },
                  //           child: Row(
                  //             children: [
                  //               Icon(
                  //                 Icons.folder_open_outlined,
                  //                 color: Colors.blue,
                  //               ),
                  //               horizontalSpace(
                  //                   SizeConfig.blockSizeHorizontal * 2),
                  //               Text(
                  //                 "Open",
                  //                 style: TextStyle(color: Colors.grey.shade700),
                  //               ),
                  //             ],
                  //           ),
                  //         )),
                  //         //   PopupMenuItem(
                  //         //       child: GestureDetector(
                  //         //     onTap: () {
                  //         //       controller.selectedindex.value = index;

                  //         // //       Get.toNamed(Routes.PDF_EDITOR,arguments: "${controller
                  //         // // .pdf_viewer_model[controller.selectedindex.value].path}");
                  //         //     },
                  //         //     child: Row(
                  //         //       children: [
                  //         //         Icon(
                  //         //           Icons.edit,
                  //         //           color: Colors.orangeAccent,
                  //         //         ),
                  //         //         horizontalSpace(
                  //         //             SizeConfig.blockSizeHorizontal * 2),
                  //         //         Text(
                  //         //           "Edit",
                  //         //           style: TextStyle(color: Colors.grey.shade700),
                  //         //         ),
                  //         //       ],
                  //         //     ),
                  //         //   )),
                  //         PopupMenuItem(
                  //             child: GestureDetector(
                  //           onTap: () {
                  //             print(
                  //                 "${controller.pdf_viewer_model[index].path}");
                  //             controller.ShareFile(controller
                  //                 .pdf_viewer_model[index].path
                  //                 .toString());

                  //             //! share file using unitlist
                  //             // Share.shareXFiles([
                  //             //   XFile.fromData(
                  //             //     controller.pdf_viewer_model[index].file,
                  //             //   )
                  //             // ]);
                  //           },
                  //           child: Row(
                  //             children: [
                  //               Icon(
                  //                 Icons.share,
                  //                 color: Colors.green,
                  //               ),
                  //               horizontalSpace(
                  //                   SizeConfig.blockSizeHorizontal * 2),
                  //               Text(
                  //                 "Share",
                  //                 style: TextStyle(color: Colors.grey.shade700),
                  //               ),
                  //             ],
                  //           ),
                  //         )),

                  //         PopupMenuItem(
                  //             child: GestureDetector(
                  //           onTap: () {
                  //             controller.selectedindex.value = index;

                  //             controller.deleteFile(
                  //                 controller
                  //                     .pdf_viewer_model[
                  //                         controller.selectedindex.value]
                  //                     .path,
                  //                 index);
                  //             Get.back();

                  //             //       Get.toNamed(Routes.PDF_EDITOR,arguments: "${controller
                  //             // .pdf_viewer_model[controller.selectedindex.value].path}");
                  //           },
                  //           child: Row(
                  //             children: [
                  //               Icon(
                  //                 Icons.delete,
                  //                 color: Colors.orangeAccent,
                  //               ),
                  //               horizontalSpace(
                  //                   SizeConfig.blockSizeHorizontal * 2),
                  //               Text(
                  //                 "Delete",
                  //                 style: TextStyle(color: Colors.grey.shade700),
                  //               ),
                  //             ],
                  //           ),
                  //         )),
                  //       ];
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Padding pdfdocitem(PDFModel person) {
    DateTime d =
        //!
        // person.File.lastModified ??
        DateTime.now();
    String date = d.toString();
    // String date = formatDateTime(d);
//!
    final namewithout =
        // "NAME";
        basenameWithoutExtension(person.name.toString());

    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 1,
          right: SizeConfig.blockSizeHorizontal * 1,
          top: SizeConfig.blockSizeHorizontal * 0,
          bottom: SizeConfig.blockSizeHorizontal * 0),
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            // openDocumentFile(controller.pdf_viewer_model[index].File.uri);

            controller.selectedindex.value =
                controller.pdf_viewer_model.indexOf(person);

            Get.toNamed(Routes.SHOW_P_D_F);
            print("Passing object: ${person.path}");
            AppLovinProvider.instance.showInterstitial(() {});
            // Get.toNamed(Routes.ShowPPTView, arguments: person);
          },
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 1,
                right: SizeConfig.blockSizeHorizontal * 1),
            child: Container(
              height: SizeConfig.blockSizeHorizontal * 18,
              width: SizeConfig.blockSizeHorizontal * 99,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.screenWidth * 0.01),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.blockSizeHorizontal * 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.red.shade100,
                        ),
                        child: Image.asset(
                          AppImages.doc,
                          scale: 9,
                        )),
                    horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeConfig.screenWidth * 0.5,
                          height: SizeConfig.screenWidth * 0.05,
                          child: Text(
                            "${namewithout}",
                            // "${controller.documentPath}",

                            // controller.pdf_viewer_model[index].name,
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color: Color(0xFF1E1E1E)),
                          ),
                        ),
                        verticalSpace(SizeConfig.blockSizeVertical * 1),
                        Row(
                          children: [
                            Text(
                              "${date}",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 3,
                                  color: Colors.grey),
                            ),
                            horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                            Text(
                              controller.getReadableFileSize(person.size),
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 2.5,
                                  color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
