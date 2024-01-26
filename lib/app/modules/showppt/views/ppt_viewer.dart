import 'package:easy_docs_viewer/easy_docs_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:convert' show utf8;

class CustomPDFViewer extends StatelessWidget {
  CustomPDFViewer({super.key});

  @override
  Widget build(BuildContext context) {
    // url = URLEncoder.encode(url, "UTF-8");
    // utf8.encode(
    //     "https://firebasestorage.googleapis.com/v0/b/ai-slide-generator.appspot.com/o/ppt%2Fsamplepptx.pptx?alt=media");
    String a = Uri.encodeFull(
        "https://firebasestorage.googleapis.com/v0/b/ai-slide-generator.appspot.com/o/ppt%2Fsamplepptx.pptx?alt=media&token=3475892f-9001-4734-accf-b890e33c9b57");
    print("URL: $a");
    return SizedBox(
      height: 150,
      width: 150,
      child: EasyDocsViewer(
        url: a,
      ),
    );
  }
}
