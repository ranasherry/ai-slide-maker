import 'dart:io';
import 'dart:typed_data';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:get/get.dart';

import 'package:slide_maker/app/data/pdf_viewer_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ShowPPTController extends GetxController {
  //TODO: Implement ShowPDFController

  // final count = 0.obs;

  // RxBool isUploaded = false.obs;
  // RxString uploadedUrl = "".obs;

  // PDFModel? pdfModel;

  // @override
  // void onInit() {
  //   super.onInit();

  //   print("ShowPPTController init start");
  //   pdfModel = Get.arguments as PDFModel;
  //   if (pdfModel != null) {
  //     print("file path: ${pdfModel!.path}");
  //     uploadFileToFirebase(pdfModel!.path);
  //   } else {
  //     print("Argument is null");
  //   }
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {}
  // void increment() => count.value++;

  // uploadFileToFirebase(String path) async {

  //   print("FileUploading Start Path: $path");
  //   Uri uri = Uri.parse(path);
  //   Uint8List? memoryFile = await getDocumentContent(uri);

  //   // return;

  //   try {
  //     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child(
  //             'ppt_files/${DateTime.now().millisecondsSinceEpoch}.pptx'); // Adjust path as needed
  //     // ref.putData(memoryFile!);
  //     // firebase_storage.UploadTask uploadTask = ref.putFile(File(path));
  //     firebase_storage.UploadTask uploadTask = ref.putData(memoryFile!);
  //     print("FileUploading Put File");

  //     firebase_storage.TaskSnapshot snapshot = await uploadTask;

  //     String downloadUrl = await snapshot.ref.getDownloadURL();

  //     String a = Uri.encodeFull("$downloadUrl");

  //     uploadedUrl.value = a;
  //     isUploaded.value = true;

  //     print('File uploaded successfully: $downloadUrl');
  //   } on firebase_storage.FirebaseException catch (e) {
  //     print('Firebase storage error: $e');
  //     // Handle error appropriately, e.g., display an error message to the user
  //   }
  // }
}
