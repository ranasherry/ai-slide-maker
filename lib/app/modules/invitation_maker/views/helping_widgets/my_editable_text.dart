import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyEditableText extends StatefulWidget {
  MyEditableText({super.key, required this.text});

  String text;

  @override
  State<MyEditableText> createState() => _MyEditableTextState();
}

class _MyEditableTextState extends State<MyEditableText> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    textEditingController.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: EditableText(
        controller: textEditingController,
        maxLines: 100,
        focusNode: FocusNode(),
        onChanged: (value) {
          setState(() {
            widget.text = value;
          });
        },
        style: TextStyle(
          color: const Color.fromARGB(255, 194, 59, 59),
          fontSize: 20, // Adjust font size as needed
        ),
        cursorColor: Colors.black,
        backgroundCursorColor: Colors.red,
      ),
    );
  }
}
