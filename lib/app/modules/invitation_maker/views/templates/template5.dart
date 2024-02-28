import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/modules/invitation_maker/controllers/weddinginvitation_controller.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class Template5 extends StatefulWidget {
  Template5({super.key, required this.controller});
  WeddingInvitationController controller;
  @override
  State<Template5> createState() => _Template5State();
}

class _Template5State extends State<Template5> {
  String groomName = "";
  String brideName = "";
  String MonthName = "";
  String date = "";
  String day = "Sunday";
  String year = "";
  String time = "";
  String address = "";
  String contact = "";

  TextStyle mainText = TextStyle(
      fontSize: 60.sp, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      initdata();
    });

    super.initState();
  }

  initdata() {
    groomName = widget.controller.groomNameTextController.text;
    brideName = widget.controller.brideNameTextController.text;
    address = widget.controller.addressTextController.text;
    contact = widget.controller.contactNoController.text;

    // Extract date information from the selected DateTime object
    final selectedDate = widget.controller.dateTime;

    // Extract individual components
    MonthName = DateFormat('MMMM').format(selectedDate); // Full month name
    date = selectedDate.day.toString();
    year = selectedDate.year.toString();

    // Format time if needed (replace with your desired format)
    time =
        DateFormat('hh:mm a').format(selectedDate); // 12-hour format with AM/PM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7EBFA),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/ai-slide-generator.appspot.com/o/cards%2FBlack%20Gold%20Simple%20Wedding%20Invitation%20(2)%201%201.png?alt=media&token=22b0b1e8-3889-4198-9ca8-b1f1750f2bd4",
                errorWidget: (context, url, error) {
                  return Container(child: Image.asset(AppImages.PPT_BG2));
                },
              )),
          Column(
            children: [
              verticalSpace(SizeConfig.blockSizeVertical * 10),
              Text(
                "SAVE THE DATE",
                style: GoogleFonts.raleway(color: Colors.white),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Text(
                "The Wedding of",
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 3),
              Text(
                groomName,
                style: mainText,
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Text(
                "&",
                style: GoogleFonts.caveat(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeHorizontal * 6,
                    fontWeight: FontWeight.bold),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Text(
                brideName,
                style: mainText,
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 4.2),
              Text(
                MonthName,
                style: mainText,
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      day,
                      style: mainText,
                    ),
                    // Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4,
                          right: SizeConfig.blockSizeHorizontal * 0),
                      child: Text(
                        date,
                        style: mainText,
                      ),
                    ),
                    // Spacer(),
                    Text(
                      time,
                      style: mainText,
                    ),
                  ],
                ),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 0.5),
              Text(
                year,
                style: mainText,
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 1.5),
              Text(
                address,
                style: mainText,
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Text("Contact: ${contact}",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 3,
                      color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}
