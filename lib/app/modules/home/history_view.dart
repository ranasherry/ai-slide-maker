import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7EBFA),
      appBar: AppBar(
        title: Text(
          // "History",
          "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded)),
        backgroundColor: Color(0xFFE7EBFA),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 20,
            left: SizeConfig.blockSizeHorizontal * 27),
        child: Column(
          children: [
            Image.asset(
              AppImages.commingSoon,
              scale: 3,
            )
          ],
        ),
      ),
    );
  }
}
