import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RCVariables {
  static RxString AppName = "Presentation AI".obs;

  static RxBool isNewSLideUI = false.obs;
  static RxBool showBothInApp = true.obs;
  static RxBool showNewInapp = true.obs;
  static RxBool showCreations = false.obs;

  static String GeminiAPIKey = "";
  static double discountPercentage = 90;
  static int discountTimeLeft = 123;
  static String discountTimeStamp = "";
  static RxInt slotLeft = 20.obs;
  static List<String> geminiAPIKeys = [];
  // line added by rizwan
  static List<String> geminiAPIKeysSlideAssistant = [];

  static int delayMinutes = 60;

  static int maxPublicPresentations = 2;

  static int interCounter = 1;
  static int interCounter1 = 2; //TODO:  Experimental

  static String slidyStyles = "";
  static String geminiModel = "";
}
