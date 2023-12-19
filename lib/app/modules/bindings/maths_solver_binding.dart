import 'package:get/get.dart';

import '../controllers/maths_solver_controller.dart';

class MathsSolverBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<MathsSolverController>(
    //   () => MathsSolverController(),
    // );
    Get.put(MathsSolverController());

  }
}
