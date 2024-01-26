import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libre_doc_converter/libre_doc_converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_maker/app/utills/images.dart';

class PptUploaderController extends GetxController {
  //TODO: Implement PptUploaderController

  final selectedCategory = "";
  final title = TextEditingController();
  final ImageLink = TextEditingController();
  final description = TextEditingController();
  final firstMessage = TextEditingController();
  final intro = TextEditingController();
  final imageFile = Rx<XFile?>(null);
  Rx<Uint8List?> memoryImageFile = Rx<Uint8List?>(null);

  RxBool imageEnabled = true.obs;

  final _loading = false.obs;
  bool get loading => _loading.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imageFile.value = pickedImage;
      if (kIsWeb) {
        memoryImageFile.value = await pickedImage.readAsBytes();
      }
    }

    // FilePickerResult? result = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   memoryImageFile.value = result.files.single.bytes;
    //   print("Picked Bytes: ${memoryImageFile.value}");
    //   // File file = File(result.files.single.path!);
    // }
  }

  void uploadData() async {
    print("Upload Call..");
    if (imageFile.value != null && title.text.isNotEmpty || true) {
      _loading.value = true;

      try {
        if (!kIsWeb) {
          String audioasset = "assets/abc.pptx";
          ByteData bytes = await rootBundle.load(audioasset);
          Uint8List yourUint8List = bytes.buffer
              .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

          Directory temporaryAddress = await getTemporaryDirectory();
          print("Temporary path: ${temporaryAddress.path}");
          final file = File(temporaryAddress.path + "/temp.pptx");
          await file.writeAsBytes(yourUint8List);
          print("Temporary File: ${file.path}");

          final converter = LibreDocConverter(
            inputFile: file,
            // inputFile: File('assets/ppt_bg/abc.pptx'),
          );

          final pdfFile = await converter.toPdf();

          print("Converted PDF PAth: ${pdfFile.path}");
          // print("Converted PDF PAth: ${pdfFile.path}");
          // print("Platform is Android");

          // // Upload image to Firebase Storage
          // final ref = FirebaseStorage.instance
          //     .ref()
          //     .child('images/${imageFile.value!.name}');
          // final uploadTask = ref.putFile(File(imageFile.value!.path));
          // final url = await (await uploadTask).ref.getDownloadURL();

          // // Save data to Firebase Firestore
          // final data = FirebaseCharecter(
          //   title: title.text,
          //   description: description.text,
          //   firstMessage: firstMessage.text,
          //   intro: intro.text,
          //   category: selectedCategory.value,
          //   imageUrl: url,
          // );
          // await FirebaseFirestore.instance
          //     .collection(APPConstants.CharecterCollection)
          //     .doc(APPConstants
          //         .CatagoriesCollection) // Use the category as the document ID
          //     .collection(selectedCategory
          //         .value) // Create a subcollection with the same name
          //     .add(data.toJson());

          // Get.snackbar('Success', 'Data uploaded successfully!');
          // resetFields();
        } else {
          // final converter = LibreDocConverter(
          //   inputFile: File('assets/ppt_bg/abc.pptx'),
          // );

          // final pdfFile = await converter.toPdf();
          // print("Converted PDF PAth: ${pdfFile.path}");
          print("Platform is web");
          final ref = FirebaseStorage.instance
              .ref()
              .child('images/${imageFile.value!.name}');
          final metadata = SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'picked-file-path': imageFile.value!.path},
          );

          final uploadTask = ref.putData(memoryImageFile.value!);
          final url = await (await uploadTask).ref.getDownloadURL();

          print("Uploaded Image Url: $url");
          final httpsReference = FirebaseStorage.instance.refFromURL(
              "https://firebasestorage.googleapis.com/b/YOUR_BUCKET/o/images%20stars.jpg");

          // Save data to Firebase Firestore
          // final data = FirebaseCharecter(
          //   title: title.text,
          //   description: description.text,
          //   firstMessage: firstMessage.text,
          //   intro: intro.text,
          //   category: selectedCategory.value,
          //   imageUrl: url,
          // );

          // await addCharacter(data);
          // await FirebaseFirestore.instance
          //     .collection(APPConstants.CharecterCollection)
          //     .doc(APPConstants
          //         .CatagoriesCollection) // Use the category as the document ID
          //     .collection(selectedCategory
          //         .value) // Create a subcollection with the same name
          //     .add(data.toJson());

          Get.snackbar('Success', 'Data uploaded successfully!');
          // resetFields();
        }
      } catch (e) {
        print("FirebaseError: $e");
        Get.snackbar('Error', 'Failed to upload data: $e');
      } finally {
        _loading.value = false;
      }
    } else {
      Get.snackbar(
          'Error', 'Please select an image and fill in the required fields.');
    }
  }

  void resetFields() {
    title.text = '';
    description.text = '';
    firstMessage.text = '';
    intro.text = '';
    // selectedCategory.value = APPConstants.categoryList[0];
    imageFile.value = null;
  }

  // Future<void> addCharacter(FirebaseCharecter character) async {
  //   final categoriesRef = FirebaseFirestore.instance
  //       .collection(APPConstants.CharecterCollection)
  //       .doc(APPConstants.CatagoriesCollection)
  //       .collection('categories');

  //   final categoryDoc = await categoriesRef.doc(character.category).get();

  //   if (categoryDoc.exists) {
  //     // Category exists, add character to its list
  //     await categoryDoc.reference.update({
  //       'characters': FieldValue.arrayUnion([character.toJson()])
  //     });
  //   } else {
  //     // Category doesn't exist, create it with the character
  //     await categoriesRef.doc(character.category).set({
  //       'characters': [character.toJson()]
  //     });
  //   }
  // }

  void uploadWithImageLink() async {
    print("Upload Call..");
    if (title.text.isNotEmpty && ImageLink.text.isNotEmpty) {
      _loading.value = true;

      try {
        final url = ImageLink.text;

        // Save data to Firebase Firestore
        // final data = FirebaseCharecter(
        //   title: title.text,
        //   description: description.text,
        //   firstMessage: firstMessage.text,
        //   intro: intro.text,
        //   category: selectedCategory.value,
        //   imageUrl: url,
        // );

        // await addCharacter(data);
        // await FirebaseFirestore.instance
        //     .collection(APPConstants.CharecterCollection)
        //     .doc(APPConstants
        //         .CatagoriesCollection) // Use the category as the document ID
        //     .collection(selectedCategory
        //         .value) // Create a subcollection with the same name
        //     .add(data.toJson());

        Get.snackbar('Success', 'Data uploaded successfully!');
        resetFields();
      } catch (e) {
        print("FirebaseError: $e");
        Get.snackbar('Error', 'Failed to upload data: $e');
      } finally {
        _loading.value = false;
      }
    } else {
      Get.snackbar(
          'Error', 'Please select an image and fill in the required fields.');
    }
  }
}
