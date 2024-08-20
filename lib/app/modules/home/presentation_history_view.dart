import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/presentation_history_ctl.dart';

class PresentationHistoryView extends GetView<PresentationHistoryCTL>{
  const PresentationHistoryView({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Column(
          children: [
            Obx(()=> controller.presentations.isEmpty ? Container(
              child: Text('isempty'),
            ): Expanded(
              child: ListView.builder(
                  itemCount: controller.presentations.length ,
                  itemBuilder: (context, index){
                    return 
                      Container(
                        child: Text('${controller.presentations[index].slides}' ),
                        // trailing: Text(controller.presentations[index].presentationId as String),
                      
                    );
                  }),
            ),
            ),
          ],
        ),
    );
  }
}