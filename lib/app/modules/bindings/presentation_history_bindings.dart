import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/presentation_history_ctl.dart';

class PresentationHistoryBindings extends Bindings{
  @override
  void dependencies(){
  Get.lazyPut(()=>PresentationHistoryCTL());
  }
}