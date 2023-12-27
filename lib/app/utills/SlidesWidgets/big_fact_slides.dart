import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class BigFactSlide extends FlutterDeckSlideWidget {
  final String customData1;
  final String customData2;

  const BigFactSlide({
    required this.customData1,
    required this.customData2,
    required super.configuration,
  });
  //  : super(
  //         configuration: const FlutterDeckSlideConfiguration(
  //           route: '/big-fact$In',
  //           // header: FlutterDeckHeaderConfiguration(
  //           //   title: 'Big fact slide template',
  //           // ),
  //         ),
  //       );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: '$customData1',
      subtitle: '$customData2',
      theme: FlutterDeckTheme.of(context).copyWith(
        bigFactSlideTheme: const FlutterDeckBigFactSlideThemeData(
            titleTextStyle: TextStyle(color: Colors.amber, fontSize: 200),
            subtitleTextStyle:
                TextStyle(fontSize: 200, fontStyle: FontStyle.italic)),
      ),
    );
  }
}
