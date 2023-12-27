import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_storage/saf.dart';

class PDFModel {
  String name;
  // Uint8List file;
  // DocumentFile File;
  String path;
  String date;
  int size;

  PDFModel({
    required this.name,
    // required this.file,
    required this.date,
    // required this.File,
    required this.path,
    required this.size,
  });
}
