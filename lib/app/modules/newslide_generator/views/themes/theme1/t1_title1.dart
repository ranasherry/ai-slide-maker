// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_maker/app/modules/controllers/history_slide_ctl.dart';
import 'package:slide_maker/app/modules/newslide_generator/controllers/slide_detailed_generated_ctl.dart';
import 'package:slide_maker/app/modules/newslide_generator/views/helping_widget.dart/helping_widget_methods.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../../helping_widget.dart/mymarkdown_view.dart';

class T1_Title1 extends StatefulWidget {
  const T1_Title1({super.key, required this.index, required this.controller});

  final int index;
  final SlideDetailedGeneratedCTL controller;

  @override
  State<T1_Title1> createState() => _T1_Title1State();
}

class _T1_Title1State extends State<T1_Title1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,  // Uncomment for debugging purposes
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset(
              //   AppImages.Theme2_horizontal[0],
              //   fit: BoxFit.cover,
              //   height: SizeConfig.blockSizeHorizontal * 40,
              // ),
              SvgPicture.asset(
                AppImages.Theme2_horizontal[0],
                height: SizeConfig.blockSizeHorizontal * 40,
                fit: BoxFit.cover,
                // colorFilter:
                // ColorFilter.mode(Colors.green, BlendMode.softLight),
                semanticsLabel: 'Acme Logo',
                placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator()),
              ),
              if (widget.controller.isBookGenerated.value)
                _titleData(widget.controller.Title.value,
                    "A Short Description of the slide will come here", context)
              else if (widget.controller.bookPages.length + 1 == widget.index)
                //? Book is Not Generated Yet and its Remaining Loading Page

                NextPageLoadingWidget()
              else
                _titleData(widget.controller.Title.value,
                    "A Short Description of the slide will come here", context)
            ],
          ),
        ),
      ),
    );
    // Replace with your actual widget content
  }

  Widget _titleData(title, desc, BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpace(SizeConfig.blockSizeVertical * 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 34,
                fontWeight: FontWeight.w700),
          ),
          // Text(desc)
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          Text("Created By:"),
          Text(
            "Presentation AI Maker | 💬 consoleai360@gmail.com",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.orange, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class T1_Title1History extends StatefulWidget {
  const T1_Title1History(
      {super.key, required this.index, required this.controller});

  final int index;
  final HistorySlideCTL controller;

  @override
  State<T1_Title1History> createState() => _T1_Title1HistoryState();
}

class _T1_Title1HistoryState extends State<T1_Title1History> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,  // Uncomment for debugging purposes
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset(
              //   AppImages.Theme2_horizontal[0],
              //   fit: BoxFit.cover,
              //   height: SizeConfig.blockSizeHorizontal * 40,
              // ),
              SvgPicture.asset(
                AppImages.Theme2_horizontal[0],
                height: SizeConfig.blockSizeHorizontal * 40,
                fit: BoxFit.cover,
                // colorFilter:
                // ColorFilter.mode(Colors.green, BlendMode.softLight),
                semanticsLabel: 'Acme Logo',
                placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator()),
              ),
              // if (widget.controller.isBookGenerated.value)
              //   _titleData(widget.controller.Title.value,
              //       "A Short Description of the slide will come here", context)
              // else if (widget.controller.bookPages.length + 1 == widget.index)
              //   //? Book is Not Generated Yet and its Remaining Loading Page

              //   NextPageLoadingWidget()
              // else
              _titleData(widget.controller.slidesHistory!.slideTitle,
                  "A Short Description of the slide will come here", context)
            ],
          ),
        ),
      ),
    );
    // Replace with your actual widget content
  }

  Widget _titleData(title, desc, BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpace(SizeConfig.blockSizeVertical * 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 34,
                fontWeight: FontWeight.w700),
          ),
          // Text(desc)
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          Text("Created By:"),
          Text(
            "Presentation AI Maker | 💬 consoleai360@gmail.com",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.orange, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
