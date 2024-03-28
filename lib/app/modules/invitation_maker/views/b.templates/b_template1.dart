import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/utills/images.dart';

class BirthdayTemplate extends StatelessWidget {
  const BirthdayTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Birthday Card",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.primary,
            )),
        // backgroundColor: Color(0xFFE7EBFA),
      ),
      // backgroundColor: Color(0xFFE7EBFA),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
                child: Image.asset(
              AppImages.commingSoon,
              scale: 3,
            )),
          )
        ],
      ),
    );
  }
}
