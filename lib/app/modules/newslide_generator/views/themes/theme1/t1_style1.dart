import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slide_maker/app/modules/controllers/history_slide_ctl.dart';
import 'package:slide_maker/app/modules/newslide_generator/controllers/slide_detailed_generated_ctl.dart';
import 'package:slide_maker/app/modules/newslide_generator/views/helping_widget.dart/helping_widget_methods.dart';
import 'package:slide_maker/app/utills/CM.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../../helping_widget.dart/mymarkdown_view.dart';

class T1_Style1 extends StatefulWidget {
  T1_Style1({super.key, required this.index, required this.controller});

  final int index;
  final SlideDetailedGeneratedCTL controller;
  final Size size = Size(
    24384000,
    13716000,
  );

  @override
  State<T1_Style1> createState() => _T1_Style1State();
}

class _T1_Style1State extends State<T1_Style1> {
  bool isTable = true;

  initState() {
    //...
    setState(() {
      if (widget.controller.bookPages.length + 1 != widget.index) {
        // isTable = ComFunction()
        //     .containsTable(widget.controller.bookPages[widget.index].ChapData);
        developer.log(
            "isTable: $isTable ${widget.controller.bookPages[widget.index].ChapData}");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // isTable = ComFunction()
    //     .containsTable(widget.controller.bookPages[widget.index].ChapData);
    return Container(
      // color: Colors.yellow,  // Uncomment for debugging purposes
      // width: widget.size.width * .80,
      // height: widget.size.height,
      height: SizeConfig.screenHeight,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage(
      //         AppImages.PPT_BG1,
      //       ),
      //       fit: BoxFit.cover),
      // ),

      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        // color: Colors.transparent,
        child: SingleChildScrollView(
          child: isTable ? _withTable(context) : _withTable(context)
          //  _withoutTable(context)
          ,
        ),
      ),
    );
    // Replace with your actual widget content
  }

  Column _withoutTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // width: SizeConfig.blockSizeHorizontal * 40,
          // color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.controller.isBookGenerated.value)
                buildMarkdown(context,
                    "${widget.controller.bookPages[widget.index].ChapData}",
                    width: isTable
                        ? SizeConfig.screenWidth
                        : SizeConfig.blockSizeHorizontal * 50)
              else if (widget.controller.bookPages.length + 1 == widget.index)
                //? Book is Not Generated Yet and its Remaining Loading Page

                NextPageLoadingWidget()
              else
                buildMarkdown(context,
                    "${widget.controller.bookPages[widget.index].ChapData} ",
                    width: isTable
                        ? SizeConfig.screenWidth
                        : SizeConfig.blockSizeHorizontal * 50),
              Spacer(),
              Container(
                height: SizeConfig.blockSizeHorizontal * 200,
                width: SizeConfig.screenWidth * .30,
                color: Colors.amber,
                child: SvgPicture.asset(
                  AppImages.Theme2_vertical[0],
                  height: SizeConfig.blockSizeHorizontal * 40,
                  fit: BoxFit.cover,
                  // colorFilter:
                  // ColorFilter.mode(Colors.green, BlendMode.softLight),
                  semanticsLabel: 'Acme Logo',
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator()),
                ),

                // Image.asset(
                //   AppImages.Theme1_vertical[0],
                //   fit: BoxFit.cover,
                //   // height: SizeConfig.blockSizeHorizontal * 100,
                //   // width: SizeConfig.screenWidth * .30,
                // ),
              ),
            ],
          ),
        ),

        // if (widget.controller.isBookGenerated.value)
        //   buildMarkdown(context,
        //       "${widget.controller.bookPages[widget.index].ChapData}",
        //       width: isTable
        //           ? SizeConfig.screenWidth
        //           : SizeConfig.screenWidth)
        // else if (widget.controller.bookPages.length == widget.index)
        //   //? Book is Not Generated Yet and its Remaining Loading Page

        //   NextPageLoadingWidget()
        // else
        //   buildMarkdown(context,
        //       "${widget.controller.bookPages[widget.index].ChapData} ",
        //       width: SizeConfig.screenWidth),

        // Image.asset(
        //   AppImages.Theme1_vertical[0],
        //   fit: BoxFit.cover,
        //   height: SizeConfig.blockSizeHorizontal * 100,
        //   width: SizeConfig.screenWidth * 40,
        // ),
      ],
    );
  }

  Widget _withTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.controller.isBookGenerated.value)
          buildMarkdown(
              context, "${widget.controller.bookPages[widget.index].ChapData}",
              width: isTable
                  ? SizeConfig.screenWidth
                  : SizeConfig.blockSizeHorizontal * 50)
        else if (widget.controller.bookPages.length + 1 == widget.index)
          //? Book is Not Generated Yet and its Remaining Loading Page

          NextPageLoadingWidget()
        else
          buildMarkdown(
              context, "${widget.controller.bookPages[widget.index].ChapData} ",
              width: isTable
                  ? SizeConfig.screenWidth
                  : SizeConfig.blockSizeHorizontal * 50),
      ],
    );
  }
}

class T1_Style1History extends StatefulWidget {
  const T1_Style1History(
      {super.key, required this.index, required this.controller});

  final int index;
  final HistorySlideCTL controller;

  @override
  State<T1_Style1History> createState() => _T1_Style1HistoryState();
}

class _T1_Style1HistoryState extends State<T1_Style1History> {
  bool isTable = false;

  initState() {
    //...
    setState(() {
      if (widget.controller.bookPages.length + 1 != widget.index) {
        isTable = ComFunction()
            .containsTable(widget.controller.bookPages[widget.index].ChapData);
        developer.log(
            "isTable: $isTable ${widget.controller.bookPages[widget.index].ChapData}");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // isTable = ComFunction()
    //     .containsTable(widget.controller.bookPages[widget.index].ChapData);
    return Container(
      // color: Colors.yellow,  // Uncomment for debugging purposes
      // width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Card(
        // color: Theme.of(context).colorScheme.primaryContainer,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: SingleChildScrollView(
          child: isTable ? _withTable(context) : _withoutTable(context),
        ),
      ),
    );
    // Replace with your actual widget content
  }

  Column _withoutTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // width: SizeConfig.blockSizeHorizontal * 40,
          // color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (widget.controller.isBookGenerated.value)
              //   buildMarkdown(context,
              //       "${widget.controller.bookPages[widget.index].ChapData}",
              //       width: isTable
              //           ? SizeConfig.screenWidth
              //           : SizeConfig.blockSizeHorizontal * 50)
              // else if (widget.controller.bookPages.length + 1 == widget.index)
              //   //? Book is Not Generated Yet and its Remaining Loading Page

              //   NextPageLoadingWidget()
              // else
              buildMarkdown(context,
                  "${widget.controller.bookPages[widget.index].ChapData} ",
                  width: isTable
                      ? SizeConfig.screenWidth
                      : SizeConfig.blockSizeHorizontal * 50),
              Spacer(),
              Container(
                height: SizeConfig.blockSizeHorizontal * 200,
                width: SizeConfig.screenWidth * .30,
                color: Colors.amber,
                child: SvgPicture.asset(
                  AppImages.Theme2_vertical[0],
                  height: SizeConfig.blockSizeHorizontal * 40,
                  fit: BoxFit.cover,
                  // colorFilter:
                  // ColorFilter.mode(Colors.green, BlendMode.softLight),
                  semanticsLabel: 'Acme Logo',
                  placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator()),
                ),

                // Image.asset(
                //   AppImages.Theme1_vertical[0],
                //   fit: BoxFit.cover,
                //   // height: SizeConfig.blockSizeHorizontal * 100,
                //   // width: SizeConfig.screenWidth * .30,
                // ),
              ),
            ],
          ),
        ),

        // if (widget.controller.isBookGenerated.value)
        //   buildMarkdown(context,
        //       "${widget.controller.bookPages[widget.index].ChapData}",
        //       width: isTable
        //           ? SizeConfig.screenWidth
        //           : SizeConfig.screenWidth)
        // else if (widget.controller.bookPages.length == widget.index)
        //   //? Book is Not Generated Yet and its Remaining Loading Page

        //   NextPageLoadingWidget()
        // else
        //   buildMarkdown(context,
        //       "${widget.controller.bookPages[widget.index].ChapData} ",
        //       width: SizeConfig.screenWidth),

        // Image.asset(
        //   AppImages.Theme1_vertical[0],
        //   fit: BoxFit.cover,
        //   height: SizeConfig.blockSizeHorizontal * 100,
        //   width: SizeConfig.screenWidth * 40,
        // ),
      ],
    );
  }

  Widget _withTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (widget.controller.isBookGenerated.value)
        //   buildMarkdown(
        //       context, "${widget.controller.bookPages[widget.index].ChapData}",
        //       width: isTable
        //           ? SizeConfig.screenWidth
        //           : SizeConfig.blockSizeHorizontal * 50)
        // else if (widget.controller.bookPages.length + 1 == widget.index)
        //   //? Book is Not Generated Yet and its Remaining Loading Page

        //   NextPageLoadingWidget()
        // else
        buildMarkdown(
            context, "${widget.controller.bookPages[widget.index].ChapData} ",
            width: isTable
                ? SizeConfig.screenWidth
                : SizeConfig.blockSizeHorizontal * 50),
      ],
    );
  }
}
