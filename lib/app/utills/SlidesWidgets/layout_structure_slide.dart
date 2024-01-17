import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class LayoutStructureSlide extends FlutterDeckSlideWidget {
  final String customData1;
  final String customData2;

  const LayoutStructureSlide({
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
    return FlutterDeckSlide.split(
      leftBuilder: (context) => FlutterDeckBulletList(
        useSteps: false,
        items: const [
          'This is a step',
          'This is another step',
          'This is a third step',
        ],
      ),
      rightBuilder: (context) => Center(
        child: Text(
          '"Steps" is a feature that allows you to navigate through a slide, '
          'well, step by step.\n\nYou can access the current step from any '
          'widget. This way, you can reveal or hide content, run animations, '
          'etc.\n\nFlutterDeckBulletList widget (the one on the left) supports '
          'steps out of the box.',
          style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
