import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RCVariables {
  static RxString AppName = "Presentation AI".obs;

  static RxBool isNewSLideUI = false.obs;
  static String GeminiAPIKey = "";
  static double discountPercentage = 90;
  static int discountTimeLeft = 123;
  static RxInt slotLeft = 20.obs;
  static List<String> geminiAPIKeys = [];
}
