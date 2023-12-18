import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchAdDialog extends StatefulWidget {
  final Function onWatchAd;
  final Function onCancel;
  final RxString timerText; // Observable string

  WatchAdDialog({
    required this.onWatchAd,
    required this.onCancel,
    required this.timerText,
  });

  @override
  _WatchAdDialogState createState() => _WatchAdDialogState();
}

class _WatchAdDialogState extends State<WatchAdDialog> {
  int countdown = 120; // Initial countdown duration in seconds

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    startCountdown();
  }

  void startCountdown() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      setState(() {
        countdown -= 1;
        if (countdown <= 0) {
          timer.cancel();
          // Call onCancel if the countdown reaches zero
          widget.onCancel();
        } else {
          // Update the observable timerText with the formatted time difference
          // widget.timerText.value = formatDuration(Duration(seconds: countdown));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Wait for the Time"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "To skip the waiting time, watch an ad!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Obx(() => Text("Remaining Time: ${widget.timerText.value}")),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Call onWatchAd when the user clicks "Watch Ad"
                  widget.onWatchAd();
                  Get.back(); // Close the dialog
                },
                child: Text("Watch Ad"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Call onCancel when the user clicks "Cancel"
                  widget.onCancel();
                  Get.back(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // String formatDuration(Duration duration) {
  //   int minutes = duration.inMinutes.remainder(60);
  //   int seconds = duration.inSeconds.remainder(60);
  //   return '$minutes:${seconds.toString().padLeft(2, '0')}';
  // }
}

// Method to show the watch ad dialog
void showWatchAdDialog({
  required Function onWatchAd,
  required Function onCancel,
  required RxString timerText,
}) {
  Get.dialog(
    WatchAdDialog(
      onWatchAd: onWatchAd,
      onCancel: onCancel,
      timerText: timerText,
    ),
  );
}

// Example usage:
// RxString timerText = ''.obs; // Define as observable string
// showWatchAdDialog(
//   onWatchAd: () {
//     // Implement logic to handle "Watch Ad" button click
//     print("Watch Ad clicked");
//   },
//   onCancel: () {
//     // Implement logic to handle "Cancel" button click
//     print("Cancel clicked");
//   },
//   timerText: timerText,
// );
