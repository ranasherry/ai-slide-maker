import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardAdDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No Reward Ads Available'),
      content: Text('Sorry, there are no reward ads available at the moment.'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}