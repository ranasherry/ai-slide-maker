// import 'package:flutter/material.dart';
// import 'package:flutter_box_transform/flutter_box_transform.dart';
// import 'package:slide_maker/app/utills/images.dart';

// class Template1 extends StatefulWidget {
//   const Template1({super.key});

//   @override
//   State<Template1> createState() => _Template1State();
// }

// class _Template1State extends State<Template1> {
//   late Rect rect = Rect.fromCenter(
//     center: MediaQuery.of(context).size.center(Offset.zero),
//     width: 100,
//     height: 100,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           TransformableBox(
//             rect: rect,
//             clampingRect: Offset.zero & MediaQuery.sizeOf(context),
//             onChanged: (result, event) {
//               setState(() {
//                 rect = result.rect;
//               });
//             },
//             contentBuilder: (context, rect, flip) {
//               return DecoratedBox(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   image: const DecorationImage(
//                     image: AssetImage(AppImages.PPT_BG1),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:slide_maker/app/modules/invitation_maker/controllers/weddinginvitation_controller.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/helping_widgets/draggable_text.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class Template1 extends StatefulWidget {
  Template1({super.key, required this.controller});
  WeddingInvitationController controller;
  @override
  State<Template1> createState() => _Template1State();
}

class _Template1State extends State<Template1> {
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
      fontSize: 60.sp, fontWeight: FontWeight.bold, color: Colors.green);

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

    day = DateFormat('EEEE').format(selectedDate);
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
                    "https://firebasestorage.googleapis.com/v0/b/ai-slide-generator.appspot.com/o/cards%2FFrame%2011.png?alt=media&token=0741b55a-fc7c-4aac-9036-71a706cb6104",
                errorWidget: (context, url, error) {
                  return Container(child: Image.asset(AppImages.PPT_BG1));
                },
              )),
          Column(
            children: [
              verticalSpace(SizeConfig.blockSizeVertical * 20),
              Text(
                groomName,
                style: mainText,
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Text(
                "&",
                style: mainText,
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
                    horizontal: SizeConfig.blockSizeHorizontal * 22),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      day,
                      style: mainText,
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 3),
                      child: Text(
                        date,
                        style: mainText,
                      ),
                    ),
                    Spacer(),
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
              verticalSpace(SizeConfig.blockSizeVertical * 5),
              Text(
                contact,
                style: mainText,
              ),
            ],
          )
        ],
      ),
    );
  }
}
