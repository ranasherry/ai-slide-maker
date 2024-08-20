import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_maker/app/modules/controllers/poll_screen_controller.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/helprer_widgets/main_header_bg.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class PollScreenView extends GetView<pollScreenCTL> {
  const PollScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Stack(
        children: [
          MainHeaderBG(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 40),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 5,
                top: SizeConfig.blockSizeVertical * 4,
              ),
              height: SizeConfig.blockSizeVertical * 6,
              width: SizeConfig.blockSizeHorizontal * 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Icon(
                Icons.close,
                color: AppColors.textfieldcolor,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 16),
            child: Text(
              "Shape the Future of Our App",
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textfieldcolor)),
            ),
          ),
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 22),
            child: Text(
              "Your feedback will help us enhance the app. Please take a moment to fill out this form.",
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      // fontWeight: FontWeight.bold,
                      color: AppColors.textfieldcolor)),
            ),
          ),
          Obx(() {
            return Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 40),
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: ListView.builder(
                itemCount: controller.polls.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> poll = controller.polls[index];

                  final int days = DateTime(
                    poll['end_date'].year,
                    poll['end_date'].month,
                    poll['end_date'].day,
                  )
                      .difference(DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ))
                      .inDays;

                  bool hasVoted = poll['hasVoted'] ?? false;

                  return Container(
                    child: FlutterPolls(
                      pollId: poll['id'].toString(),
                      hasVoted: hasVoted,
                      userVotedOptionId:
                          poll['userVotedOptionId']?.toString() ?? '',
                      onVoted:
                          (PollOption pollOption, int newTotalVotes) async {
                        return await controller.onVoted(
                            poll['id'].toString(), pollOption.toString());
                      },
                      votedBackgroundColor: AppColors.textfieldcolor,
                      votedProgressColor: Color(0xFFF8875E),
                      pollOptionsFillColor: AppColors.textfieldcolor,
                      leadingVotedProgessColor: AppColors.mainColor,
                      votedPollOptionsBorder:
                          Border.all(color: AppColors.mainColor),
                      pollOptionsSplashColor: AppColors.mainColor,
                      voteInProgressColor: Color(0xFFF8875E),
                      pollOptionsBorderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 7),
                      votedPollOptionsRadius:
                          Radius.circular(SizeConfig.blockSizeHorizontal * 7),
                      votedCheckmark: Icon(
                        Icons.verified_outlined,
                        color: Colors.orange,
                      ),
                      pollOptionsBorder: Border(),
                      pollOptionsHeight: SizeConfig.blockSizeVertical * 6,
                      pollEnded: days < 0,
                      pollTitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(poll['question'],
                            style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.5,
                                    fontWeight: FontWeight.bold))),
                      ),
                      pollOptions: List<PollOption>.from(
                        poll['options'].map(
                          (option) => PollOption(
                            id: option['id'].toString(),
                            title: Text(option['title'],
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                                ))),
                            votes: option['votes'],
                          ),
                        ),
                      ),
                      votedPercentageTextStyle: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                              fontWeight: FontWeight.bold)),
                      metaWidget: Row(
                        children: [
                          const SizedBox(width: 6),
                          const Text('•'),
                          const SizedBox(width: 6),
                          Text(
                            days < 0 ? "ended" : "ends in $days days",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    ));
  }
}
