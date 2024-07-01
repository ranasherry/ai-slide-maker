// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:slide_maker/app/data/book_page_model.dart';
import 'package:slide_maker/app/data/helping_enums.dart';
import 'package:slide_maker/app/modules/home/slide_assistant.dart';
import 'package:slide_maker/app/modules/newslide_generator/views/helping_widget.dart/helping_widget_methods.dart';
import 'dart:math' as math;

import 'package:slide_maker/app/services/revenuecat_service.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class MyMarkDownWidget extends StatelessWidget {
  MyMarkDownWidget({
    super.key,
    required this.page,
    required this.size,
    required this.isTitle,
  });

  final BookPageModel page;
  final Size size;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDark = true;

    final lightTextColor = Colors.black;
    final darkTextColor = Colors.white;
    final config = !isDark
        // ignore: dead_code
        ? MarkdownConfig(configs: [
            PreConfig(textStyle: TextStyle(fontSize: 60)),
            H1Config(
                style: TextStyle(
              fontSize: 60,
              height: 80 / 60,
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            )),
            H2Config(
                style: TextStyle(
              fontSize: 52,
              height: 65 / 52,
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            )),
            H3Config(
                style: TextStyle(
              fontSize: 50,
              height: 60 / 50,
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            )),
            H4Config(
                style: TextStyle(
              fontSize: 48,
              height: 60 / 48,
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            )),
            H5Config(
                style: TextStyle(
              fontSize: 46,
              height: 52 / 46,
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            )),
            H4Config(
                style: TextStyle(
              fontSize: 44,
              height: 50 / 44,
              color: lightTextColor,
              fontWeight: FontWeight.bold,
            )),
            PConfig(
                textStyle: TextStyle(
              fontSize: 42,
              color: lightTextColor,
            ))
          ])
        : MarkdownConfig(configs: [
            PreConfig(textStyle: TextStyle(fontSize: 60)),
            H1Config(
                style: TextStyle(
              fontSize: 60,
              height: 80 / 60,
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            )),
            H2Config(
                style: TextStyle(
              fontSize: 52,
              height: 65 / 52,
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            )),
            H3Config(
                style: TextStyle(
              fontSize: 50,
              height: 60 / 50,
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            )),
            H4Config(
                style: TextStyle(
              fontSize: 48,
              height: 60 / 48,
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            )),
            H5Config(
                style: TextStyle(
              fontSize: 46,
              height: 52 / 46,
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            )),
            H4Config(
                style: TextStyle(
              fontSize: 44,
              height: 50 / 44,
              color: darkTextColor,
              fontWeight: FontWeight.bold,
            )),
            PConfig(
                textStyle: TextStyle(
              fontSize: 42,
              color: darkTextColor,
            ))
          ]);

    final codeWrapper =
        (child, text, language) => CodeWrapperWidget(child, text, language);

    return Localizations(
      locale: const Locale('en', 'US'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
      ],
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Overlay(
          initialEntries: [
            OverlayEntry(
                builder: (context) => isTitle
                    ? titleLayout(isDark, context, size)
                    : mdLayout(config, isDark, codeWrapper, context, size))
          ],
          // child: mdLayout(config, isDark, codeWrapper, context),
        ),
      ),
    );
  }

  Widget mdLayout(
      MarkdownConfig config,
      bool isDark,
      CodeWrapperWidget codeWrapper(
          dynamic child, dynamic text, dynamic language),
      BuildContext context,
      Size size) {
    return Stack(
      children: [
        page.containsImage
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: size.width / 2,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black87 : Colors.white,
                  ),
                ),
              )
            : Container(),
        Container(
          width: page.containsImage ? size.width / 2 : size.width,
          height: size.height,

          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: isDark ? Colors.black87 : Colors.white,
          ),

          child: Container(
            width: page.containsImage ? size.width * 0.63 : size.width,
            child: MarkdownWidget(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                data: page.ChapData,
                config: config),
          ),
          //  buildMarkdown(Get.context!, page.ChapData),
        ),
        page.containsImage
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black87 : Colors.white,
                  ),
                  child: myAllImageProvider(
                      page: page, width: size.width * 0.3, height: size.height),
                ),
              )
            : Container(),
        Obx(() =>
            RevenueCatService().currentEntitlement.value == Entitlement.paid
                ? Container()
                : _waterMark())
      ],
    );
  }

  Widget titleLayout(bool isDark, BuildContext context, Size size) {
    log("Title Page1: ${page.ChapName} \n AppImage: ${Image.asset(AppImages.Theme2_horizontal[0])}");
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: isDark ? Colors.black87 : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: size.width,
                  height: size.height / 2,
                  child: myAllImageProvider(
                      page: page, width: size.width, height: size.height / 2)
                  // SvgPicture.asset(
                  //   AppImages.Theme2_horizontal[0],
                  //   height: size.height / 2,
                  //   fit: BoxFit.cover,
                  //   // colorFilter:
                  //   // ColorFilter.mode(Colors.green, BlendMode.softLight),
                  //   semanticsLabel: 'Acme Logo',
                  //   placeholderBuilder: (BuildContext context) => Container(
                  //       padding: const EdgeInsets.all(30.0),
                  //       child: const CircularProgressIndicator()),
                  // ),
                  ),
              Container(
                width: size.width,
                // height: size.height / 2,

                padding: EdgeInsets.only(top: size.height * 0.2),
                // decoration: BoxDecoration(
                //   color: isDark ? Colors.black87 : Colors.white,
                // ),
                child: Text(
                  page.ChapName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      // color: Colors.black,
                      fontSize: 60,
                      fontWeight: FontWeight.bold),
                ),

                //  buildMarkdown(Get.context!, page.ChapData),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Text("Created By:"),
              Text(
                "Presentation AI Maker | 💬 consoleai360@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange, fontSize: 30),
              ),
            ],
          ),
        ),
        Obx(() =>
            RevenueCatService().currentEntitlement.value == Entitlement.paid
                ? Container()
                : _waterMark())
      ],
    );
  }

  Align _waterMark() {
    return Align(
      alignment: Alignment.center,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationZ(math.pi / 6),
        child: Container(
          child: Text(
            "Generated By AI Slide - AppGeniusX",
            style: TextStyle(
                fontSize: 90,
                color: Color.fromARGB(141, 179, 175, 175),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
