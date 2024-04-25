import 'package:get/get.dart';

import '../controllers/book_writer_controller.dart';

class BookWriterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookWriterController>(
      () => BookWriterController(),
    );
  }
}
