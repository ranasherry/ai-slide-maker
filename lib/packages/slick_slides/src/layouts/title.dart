import 'package:flutter/material.dart';
import 'package:slide_maker/packages/slick_slides/slick_slides.dart';
import 'package:slide_maker/packages/slick_slides/src/deck/theme.dart';

/// The layout of a slide with a title and subtitle.
class TitleLayout extends StatelessWidget {
  /// Creates a layout of a slide with a title and subtitle.
  const TitleLayout({
    this.title,
    this.subtitle,
    this.alignment = Alignment.center,
    this.background,
    super.key,
  });

  /// The title of the slide.
  final Widget? title;

  /// The subtitle of the slide.
  final Widget? subtitle;

  /// The background of the slide.
  final Widget? background;

  /// The alignment of the title and subtitle. Defaults to [Alignment.center]
  /// which centers the title and subtitle on the slide.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: background ?? theme.backgroundBuilder(context),
        ),
        Padding(
          padding: theme.borderPadding,
          child: Align(
            alignment: alignment,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style: theme.textTheme.title,
                    textAlign: TextAlign.center,
                    child: GradientText(
                      gradient: theme.textTheme.titleGradient,
                      child: title!,
                    ),
                  ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DefaultTextStyle(
                      style: theme.textTheme.subtitle,
                      textAlign: TextAlign.center,
                      child: GradientText(
                        gradient: theme.textTheme.subtitleGradient,
                        child: subtitle!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
