import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:slide_maker/app/modules/presentaion_generator/presentation_home/controllers/presentation_edit_ctl.dart';

class PresentationEditIndividualSlideView extends GetView<PresentationEditCtl> {
  const PresentationEditIndividualSlideView({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              
            )
          ],
        ),
      ),
    );
  }
}