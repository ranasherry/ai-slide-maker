import 'package:get/get.dart';
import 'package:slide_maker/app/modules/book_writer/controllers/book_generated_ctl.dart';

import '../controllers/book_writer_controller.dart';

class BookGeneratedBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<BookGeneratedCTL>(
    //   () => BookGeneratedCTL(),
    // );

    Get.put(BookGeneratedCTL());
  }
}
