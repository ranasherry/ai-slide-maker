import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/newslide_generator_controller.dart';

class NewslideGeneratorView extends GetView<NewslideGeneratorController> {
  const NewslideGeneratorView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewslideGeneratorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NewslideGeneratorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
