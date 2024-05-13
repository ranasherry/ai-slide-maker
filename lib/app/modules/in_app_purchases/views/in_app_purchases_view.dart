import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/in_app_purchases_controller.dart';

class InAppPurchasesView extends GetView<InAppPurchasesController> {
  const InAppPurchasesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InAppPurchasesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InAppPurchasesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
