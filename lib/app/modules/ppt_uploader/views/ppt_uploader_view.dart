import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ppt_uploader_controller.dart';

class PptUploaderView extends GetView<PptUploaderController> {
  PptUploaderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white, title: Text('Admin Image Uploader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text("Upload Image"),
                trailing: Obx(() => Checkbox(
                    value: controller.imageEnabled.value,
                    onChanged: (value) {
                      controller.imageEnabled.value = value ?? false;
                    })),
              ),
              Obx(() => controller.imageEnabled.value
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: controller.pickImage,
                          child: Text('Pick Image'),
                        ),
                        Obx(() => controller.imageFile.value != null
                            ? kIsWeb
                                ? controller.memoryImageFile.value != null
                                    ? Container(
                                        width: 200,
                                        height: 200,
                                        child: Image.memory(
                                            controller.memoryImageFile.value!))
                                    : Container()
                                : Image.file(
                                    File(controller.imageFile.value!.path))
                            : Container()),
                      ],
                    )
                  : TextFormField(
                      controller: controller.ImageLink,
                      decoration: InputDecoration(labelText: 'Image Link'),
                    )),
              TextFormField(
                controller: controller.title,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: controller.description,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: controller.firstMessage,
                decoration: InputDecoration(labelText: 'First Message'),
              ),
              TextFormField(
                controller: controller.intro,
                decoration: InputDecoration(labelText: 'Intro'),
              ),
              // Obx(() => DropdownButtonFormField<String>(
              //       value: controller.selectedCategory.value,
              //       items: APPConstants.categoryList.map((category) {
              //         return DropdownMenuItem(
              //           value: category,
              //           child: Text(category),
              //         );
              //       }).toList(),
              //       onChanged: (value) {
              //         controller.selectedCategory.value = value!;
              //       },
              //     )),
              ElevatedButton(
                onPressed: () {
                  if (controller.imageEnabled.value) {
                    controller.uploadData();
                  } else {
                    controller.uploadWithImageLink();
                  }
                },
                child: Obx(() =>
                    Text(controller.loading ? 'Uploading...' : 'Upload Data')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
