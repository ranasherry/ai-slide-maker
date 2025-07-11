import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/data/slideResponce.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/big_fact_slides.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/layout_structure_slide.dart';
import 'package:slide_maker/app/utills/SlidesWidgets/title_slide.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class FlutterDeckExample extends StatelessWidget {
  // const FlutterDeckExample({super.key});
  RxList<SlideResponse> slideResponseList;
  final int NoOfSlides;

  // bool showExtra;

  FlutterDeckExample({
    required this.slideResponseList,
    required this.NoOfSlides,
    // required this.showExtra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: SizeConfig.blockSizeVertical * 75,
      // decoration: BoxDecoration(color: Colors.red),
      child: FlutterDeckApp(
        themeMode: ThemeMode.light,
        // You could use the default configuration or create your own.
        configuration: FlutterDeckConfiguration(
          controls: FlutterDeckControlsConfiguration(),
          // Define a global background for the light and dark themes separately.
          background: FlutterDeckBackgroundConfiguration(
              light: FlutterDeckBackground.image(Image.asset(
            AppImages.PPT_BG3,
            fit: BoxFit.fill,
          ))
              // light: FlutterDeckBackground.gradient(
              //   LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [Color(0xFFFFDEE9), Color(0xFFB5FFFC)],
              //   ),
              // ),
              // dark: FlutterDeckBackground.gradient(
              //   LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [Color(0xFF16222A), Color(0xFF3A6073)],
              //   ),
              // ),
              ),
          // Set defaults for the footer.
          footer: const FlutterDeckFooterConfiguration(
            showSlideNumbers: true,
            showSocialHandle: true,
          ),
          // Set defaults for the header.
          header: const FlutterDeckHeaderConfiguration(
            showHeader: false,
          ),
          // Override the default marker configuration.
          marker: const FlutterDeckMarkerConfiguration(
            color: Colors.cyan,
            strokeWidth: 8.0,
          ),
          // Show progress indicator with specifc gradient and background color.
          progressIndicator: const FlutterDeckProgressIndicator.gradient(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink, Colors.purple],
            ),
            backgroundColor: Colors.blue,
          ),
          // Use a custom slide size.
          slideSize: FlutterDeckSlideSize.fromAspectRatio(
            aspectRatio: NoOfSlides == 1
                ? FlutterDeckAspectRatio.custom(3 / 4)
                : FlutterDeckAspectRatio.ratio16x9(),
            resolution: const FlutterDeckResolution.fhd(),
          ),
          // Use a custom transition between slides.
          transition: const FlutterDeckTransition.fade(),
        ),
        // You can also define your own light...
        lightTheme: FlutterDeckThemeData.fromTheme(
          ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFB5FFFC),
            ),
            textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 200)),
            useMaterial3: true,
          ),
        ),
        // ...and dark themes.
        darkTheme: FlutterDeckThemeData.fromTheme(
          ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF16222A),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
        ),
        // Presentation is build automatically from the list of slides.
        slides: List.generate(
          NoOfSlides,
          (index) => singleSlide(index),
        ),
        // Do not forget to introduce yourself!
        // speakerInfo: const FlutterDeckSpeakerInfo(
        //   name: 'Flutter Deck',
        //   description: 'The power of Flutter, in your presentations.',
        //   socialHandle: 'flutter_deck',
        //   imagePath: 'assets/flutter_logo.png',
        // ),
      ),
    );
  }

  singleSlide(index) {
    String title = slideResponseList[index].slideTitle;
    String dis = slideResponseList[index].slideDescription;
    String imagePrompt = "Create an image of $title";

    // if (index == 0) {
    //   return LayoutStructureSlide(
    //     customData1: title,
    //     customData2: dis,
    //     configuration: FlutterDeckSlideConfiguration(
    //       route: '/big-fact/$index',
    //       // route: '/$title',

    //       // header: FlutterDeckHeaderConfiguration(
    //       //   title: 'Big fact slide template',
    //       // ),
    //     ),
    //   );
    // } else {
    //   return BigFactSlide(
    //     customData1: title,
    //     customData2: dis,
    //     configuration: FlutterDeckSlideConfiguration(
    //       route: '/big-fact/$index',
    //       // route: '/$title',

    //       // header: FlutterDeckHeaderConfiguration(
    //       //   title: 'Big fact slide template',
    //       // ),
    //     ),
    //   );
    // }

    return BigFactSlide(
      customData1: title,
      customData2: dis,
      configuration: FlutterDeckSlideConfiguration(
        route: '/big-fact/$index',
        // route: '/$title',

        // header: FlutterDeckHeaderConfiguration(
        //   title: 'Big fact slide template',
        // ),
      ),
    );
  }
}
