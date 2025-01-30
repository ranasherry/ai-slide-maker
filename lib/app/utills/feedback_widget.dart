
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slide_maker/app/services/firebaseFunctions.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/size_config.dart';

class FeedbackWidget extends StatefulWidget {

  const FeedbackWidget({Key? key}) : super(key: key);

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  String? selectedFeedback; // Stores selected feedback
  String? submittedFeedback; // Stores submitted feedback type (up/down)
  
  // Feedback options
  final List<String> negativeOptions = [
    "Hate speech",
    "Contains sexual content",
    "Misinformation",
    "Irrelevant content",
    "Offensive or inappropriate",
    "Poorly structured slides",
    "Other"
  ];
  final List<String> positiveOptions = [
    "Quick response",
    "Well-designed slides",
    "Accurate and relevant content",
    "Easy to understand",
    "Useful and informative",
    "Unique and creative",
    "Other"
  ];



  // Function to show feedback popup
  void showFeedbackDialog(String feedbackType) {
    List<String> options = feedbackType == "thumbs_up" ? positiveOptions : negativeOptions;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Feedback"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedFeedback,
                onChanged: (value) {
                  setState(() {
                    selectedFeedback = value;
                    submittedFeedback = feedbackType; // Save submitted feedback type
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  FirestoreService().submitFeedback(feedbackType, value!); // Submit feedback
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (submittedFeedback != "thumbs_down") // Show thumbs up only if not submitted thumbs down
          IconButton(
            icon: Icon(Icons.thumb_up, color: submittedFeedback == "thumbs_up" ? AppColors.headerContainerColor : Colors.grey, size: submittedFeedback == "thumbs_up" ? SizeConfig.blockSizeHorizontal * 8:  SizeConfig.blockSizeHorizontal * 5),
            onPressed: () => showFeedbackDialog("thumbs_up"),
          ),
        if (submittedFeedback != "thumbs_up") // Show thumbs down only if not submitted thumbs up
          IconButton(
            icon: Icon(Icons.thumb_down, color: submittedFeedback == "thumbs_down" ? AppColors.greybox: Colors.grey, size: submittedFeedback == "thumbs_down" ? SizeConfig.blockSizeHorizontal * 8:  SizeConfig.blockSizeHorizontal * 5),
            onPressed: () => showFeedbackDialog("thumbs_down"),
          ),
      ],
    );
  }
}
