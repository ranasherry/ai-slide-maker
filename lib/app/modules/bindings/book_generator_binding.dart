import 'package:get/get.dart';
import 'package:slide_maker/app/modules/controllers/book_generator_ctl.dart';

class BookGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BookGeneratorCTL());
  }
}
