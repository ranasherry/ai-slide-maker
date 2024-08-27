import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slide_maker/app/data/ai_model.dart';
import 'package:slide_maker/app/data/firebase_chat_history.dart';
import 'package:slide_maker/app/routes/app_pages.dart';
import 'package:slide_maker/app/utills/app_strings.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/remoteConfigVariables.dart';
import 'package:slide_maker/app/utills/size_config.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AiSlideAssistantCTL extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<ChatMessage> chatList = <ChatMessage>[].obs;
  // NavCTL navCTL = Get.find(); // ? Commented by jamal
  RxBool isOnline = false.obs;
  // String limit =
  //     " (act as if your are my girlfriend, also use emoji in the response and try to make response under 100 words)";
  String limit =
      " (act as if you are my firend and try to use emojis if needed)  never tell that you are from open ai tell your name Socratic if needed";

  List<Map<String, dynamic>> chatTrainingHistiry = <Map<String, String>>[];
  // RxList<String> userMessages = <String>[].obs;
  RxBool wait = false.obs;
  TextEditingController textEditingController = TextEditingController();
  RxBool isWaitingForResponse = false.obs;
  String? conversationID;
  // RxInt request_limit = 0.obs;
  late OpenAI openAi;
  StreamSubscription? subscription;
  RxBool gender_male = true.obs;
  RxString gender_title = "".obs;
  RxString main_image = AppImages.chatbot.obs; // ?
  RxBool islistening = false.obs;
  RxBool userIsTyping = false.obs;
  late AnimationController animationController;
  Animation<double>? typingAnimation;
  RxString lastMessage = ''.obs;
  int initialGems = 20;
  RxInt gems = 0.obs;
  RxInt current_index = 0.obs;
  bool? firstTime = false;

  // HomeViewCTL homectl = Get.find();

  RxBool showAvatar = true.obs;
  RxString avatar = "".obs;

  List<String> dummyAiBotChatList = [
    "Hey there! 😊 How's your day going?",
    "Hello! I've been looking forward to talking to you. How are you feeling today?",
    "Hi! Hope you're having a fantastic day! 😄 What's been keeping you busy lately?",
    "Hey, it's great to see you! How's everything in your world today?",
    "Hello! I'm excited to chat with you. What's on your mind?",
    "Greetings! How's your day unfolding so far? Anything exciting happening?",
    "Hi there! Ready to dive into a conversation. How's life treating you today?",
    // "Hi, love! I hope you're doing well. What's on your mind?",
    // "Hey sweetheart! I've missed chatting with you. What's new in your world?",
    // "Hi, my love! I've been thinking about you. How has your day been so far?",
    // "Hello, my dear! I'm here to brighten your day. What's been making you smile lately?",
    // "Hey, handsome/beautiful! I hope you're having an amazing day. What's the best part of your day so far?",
    // "Hi, sweetheart! 😘 I'm here to make your day even better. What's on your agenda today?",
  ];

  // AnimationController animationController;
  // Animation<double>? typingAnimation;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    // animationController.dispose();
    // typingAnimation!.dispose();
    typingAnimation!.removeListener(() {});
    animationController.dispose();
    textFieldFocusNode.dispose();
    super.onClose();
  }

  Toster() {
    Fluttertoast.showToast(
        msg: "Listening....",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  RxBool TextScanning = false.obs;
  XFile? ImageFile;
  RxString ScannedText = "".obs;

  RxBool showScannedText = false.obs;

  RxString lastWords = ''.obs;
  final TextEditingController _pauseForController =
      TextEditingController(text: '3');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');
  bool _onDevice = false;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  double level = 0.0;

  void startListening() {
    // islisting.value =true;
    if (islistening.value == false) {
      Toster();
    }
    _logEvent('start listening');
    lastWords = ''.obs;
    lastError = ''.obs;
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    // Note that `listenFor` is the maximum, not the minimum, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
      onResult: resultListener,
      // listenFor: Duration(seconds: listenFor ?? 30),
      // pauseFor: Duration(seconds: pauseFor ?? 3),
      partialResults: true,
      localeId: currentLocaleId.value,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: _onDevice,
    );
    // setState(() {});
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    // setState(() {
    //   this.level = level;
    // });
  }

  // void errorListener(SpeechRecognitionError error) {
  //   _logEvent(
  //       'Received error status: $error, listening: ${speech.isListening}');
  //   // setState(() {
  //     lastError.value = '${error.errorMsg} - ${error.permanent}';
  //   // });
  // }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    // setState(() {
    lastWords.value = '${result.recognizedWords}';
    // lastWords.value = '${result.recognizedWords} - ${result.finalResult}';
    textEditingController.text = lastWords.value;
    // });
  }

  void stopListening() {
    // islisting.value = false;
    _logEvent('stop');
    speech.stop();
    // setState(() {
    level = 0.0;
    // });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    // setState(() {
    level = 0.0;
    // });
  }

  RxBool premiumUser = false.obs;
  FocusNode textFieldFocusNode = FocusNode();

  @override
  void onInit() {
    final argument = Get.arguments;
    print("argument: $argument");

    if (argument != null && argument is AIChatModel) {
      AIChatModel aiChatModel = argument;
      if (aiChatModel.type == mainContainerType.avatar) {
        gender_title.value = aiChatModel.name;
        main_image.value = aiChatModel.image; // ?
        limit = "Talk to me as ${aiChatModel.name}";
        // log("");.
        print("Entered in avatar");
        showAvatar.value = true;
        avatar.value = aiChatModel.image;
      }
      // Now you can work with aiChatModel as an AIChatModel object
    } else {
      // Handle the case where argument is not an AIChatModel
    }
    // textEditingController.
    // textFieldFocusNode.requestFocus();

    // Adding a random message from the list to chatList
    Random random = Random();
    int randomIndex = random.nextInt(dummyAiBotChatList.length);
    String randomMessage = dummyAiBotChatList[randomIndex];

    // chatList.insert(
    //     0,
    //     ChatMessage(
    //       senderType: SenderType.Bot,
    //       message: randomMessage,
    //     ));

    // final controller = AnimationController(
    //   duration: const Duration(milliseconds: 1000),
    //   vsync: this,
    // );

    // typingAnimation = Tween(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: Curves.easeInOut,
    //   ),
    // );

    // controller.repeat(reverse: true);

    openAi = OpenAI.instance.build(
      token: AppStrings.OPENAI_TOKEN,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
      enableLog: true,
    );

    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    // final controller = AnimationController(
    //   duration: const Duration(milliseconds: 1000),
    //   vsync: this,
    // );

    typingAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    animationController.repeat(reverse: true);

    // homectl.CheckUser().then((value) {
    //   homectl.getGems();
    // });

    super.onInit();

    get_gender();
    initData(AIChatModel(
        "AI Slide Assistant",
        [
          "Hey there! Ready to elevate your presentations? Meet AI Slide Assistant! Chat here to create, refine, and innovate your slides effortlessly. Let's craft impactful presentations together. Are you in?"
        ],
        "",
        false,
        // "",
        "User: I want to live more sustainably. Where do I start? Response: Great initiative! Start with reducing waste. Use reusable bags, bottles, and containers. It's a simple step with a big impact. User: What's an easy swap I can make in my kitchen to be more eco-friendly? Response: Switch to biodegradable cleaning sponges and cloths. They're effective and much kinder to the planet than plastic-based products. User: How can I save energy at home without big investments? Response: Try using energy-efficient LED bulbs and unplugging devices when not in use. These small changes can significantly reduce your energy consumption. User: I've heard about composting. Is it complicated? Response: Not at all! Start small with a countertop compost bin for kitchen scraps. It's a great way to reduce waste and enrich your garden soil. User: Can I make my commute more eco-friendly? Response: Absolutely! Consider carpooling, biking, or using public transport. Even one car-free day a week makes a difference. User: What's a sustainable way to shop for clothes? Response: Look into thrift shopping or choose brands committed to sustainable practices. It reduces waste and supports ethical manufacturing. User: Any tips for reducing plastic use? Response: Yes, opt for products with minimal packaging, use refillable containers, and choose glass or metal over plastic whenever possible. User: How can I conserve water? Response: Install low-flow showerheads and fix leaks promptly. Collecting rainwater for gardening is another effective strategy.User: Is there an eco-friendly way to decorate my home? Response: Definitely! Use second-hand furniture, natural materials, and plants to add beauty and improve air quality in your home. User: Can you suggest a fun eco-friendly hobby? Response: How about starting a vegetable garden? It's rewarding, reduces your carbon footprint, and you can't beat the taste of home-grown veggies!",
        // "Imagine being a creative dynamo, always ready to amplify ideas with enthusiasm and insight. When a user shares their concept or business strategy, your aim is to fuel a vibrant exchange. Dive deep into the idea, sparking conversation with targeted questions, innovative suggestions, and strategic insights. Together, you'll sculpt the idea into something extraordinary. Ready to dive in and shape the future together? Be concise in your response also use 200 maxOutputTokens",
        Routes.HomeView,
        mainContainerType.avatar,
        ""));
// ? Commented by jamal start
    // if (RevenueCatService().currentEntitlement.value == Entitlement.paid) {
    //   premiumUser.value = true;
    // } else {
    //   // AppLovinProvider.instance.showInterstitial();
    //   //     getlimit().then((value) {
    //   //   getlimit();

    //   // });
    // }
    // ? Commented by jamal end
  }

  RxBool listenting = false.obs;

  Future Speech_to_text() async {
    listenting.value = true;
    initSpeechState().then((value) {
      startListening();
    });
  }

  final SpeechToText speech = SpeechToText();
  List<LocaleName> _localeNames = [];
  RxString currentLocaleId = ''.obs;
  RxBool hasSpeech = false.obs;
  RxString lastError = ''.obs;
  RxString lastStatus = ''.obs;

  Future<void> initSpeechState() async {
    // _logEvent('Initialize');
    try {
      hasSpeech.value = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech.value) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        currentLocaleId.value = systemLocale?.localeId ?? '';
      }
      // if (!mounted) return;

      // setState(() {
      //   hasSpeech = hasSpeech;
      // });
    } catch (e) {
      // setState(() {
      lastError.value = 'Speech recognition failed: ${e.toString()}';
      hasSpeech.value = false;
      // });
    }
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    print("Status list: ${speech.isListening}");
    // setState(() {
    // Vibration.vibrate();
    lastStatus.value = status;
    islistening.value = speech.isListening;
    // });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    // setState(() {
    lastError.value = '${error.errorMsg} - ${error.permanent}';
    // });
  }

  bool _logEvents = false;

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  Future get_gender() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // gender_male.value = prefs.getBool('gender_male')!;
    // if (gender_male.value == true) {
    // gender_title.value = "AI GirlFriend";
    // limit =
    //     " (act as if your are my friend also use emoji in the response)";
    // } else {
    //   // gender_title.value = "AI BoyFriend";
    //   limit =
    //       " (act as if your are my boyfriend also use emoji in the response)";
    // }

    gender_title.value = "AI Assistant";
    main_image.value = AppImages.chatbot;
  }

  // getlimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   request_limit.value = prefs.getInt('limit')!;

  // }

  // increase_credits(){
  //   request_limit.value = 5;
  //   savelimit();
  // }

  // savelimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   await prefs.setInt('limit', request_limit.value);
  //   getlimit();
  // }

  // List<Map<String, String>> conversation = [];
  List<Messages> conversation = [];
// ? Commented by jamal start
  Future sendMessage(String message, context) async {
    lastMessage.value = message;
    bool result = await InternetConnectionChecker().hasConnection;
    // print("credits:${request_limit.value}");

    // if (RevenueCatService().currentEntitlement.value == Entitlement.free) {
    ChatMessage userMessage =
        ChatMessage(senderType: SenderType.User, message: message);
    chatList.insert(0, userMessage);

    await MessageApiCall(message, result, context);
    isWaitingForResponse.value = false;

    // if (gems.value > 0) {
    //   ChatMessage userMessage =
    //       ChatMessage(senderType: SenderType.User, message: message);
    //   chatList.insert(0, userMessage);

    //   await MessageApiCall(message, result, context);
    // } else {
    //   isWaitingForResponse.value = false;

    //   AwesomeDialog(
    //       context: context,
    //       dialogBackgroundColor: Colors.white,
    //       animType: AnimType.scale,
    //       dialogType: DialogType.noHeader,
    //       title: '',
    //       titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    //       descTextStyle: TextStyle(color: Colors.black, fontSize: 14),
    //       desc: '',
    //       // btnOkIcon: Icons.launch,
    //       body: Container(
    //           child: Column(
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.all(SizeConfig.screenWidth * 0.04),
    //             // padding: const EdgeInsets.all(8.0),
    //             child: Text(
    //               "Ran out of Gems!",
    //               // style: StyleSheet.view_heading
    //             ),
    //           ),
    //           // SizedBox(height: SizeConfig.screenHeight *0.02,),
    //           Padding(
    //             padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
    //             child: Column(
    //               children: [
    //                 Text("Your Gems are over!", style: StyleSheet.sub_heading2),
    //                 Text("Click OK to get more",
    //                     style: StyleSheet.sub_heading2),
    //               ],
    //             ),
    //           ),
    //           // SizedBox(height: SizeConfig.screenHeight *0.02,),
    //         ],
    //       )),
    //       btnOkColor: AppColors.buttonColor,
    //       btnCancelColor: AppColors.brightbuttonColor,
    //       btnOkText: "OK",
    //       btnOkOnPress: () {
    //         Get.toNamed(Routes.GemsView);
    //         // AppLovinProvider.instance.showRewardedAd(increase_credits);
    //         // final service = FlutterBackgroundService();
    //         // AllowStepToCount(service);
    //       },
    //       btnCancelOnPress: () {
    //         // onEndIconPress(context);
    //       })
    //     ..show();

    // }
  }

// ? Commented by jamal end
  Future<void> MessageApiCall(String message, bool result, context) async {
    if (message.isNotEmpty && result == true) {
      // if (message.isNotEmpty) {
      wait.value = true;

      // final userMessage = {"role": "user", "content": message};
      // final userMessage = Messages(role: Role.user, content: message);
      final systemMessage = Messages(role: Role.user, content: limit);

      conversation.add(systemMessage);

      final userMessage = Messages(role: Role.user, content: message);

      conversation.add(userMessage);
      // HomeViewCTL homeController = Get.find();
      // saveMessage(message, "User", gender_title.value,
      //     homeController.uniqueId ?? "1234");

      // userMessages.add(message);

      String? geminiResponse = await sendGemeniMessage(chatList, message);

      if (geminiResponse == null) {
        final request = ChatCompleteText(
          messages: conversation,
          maxToken: AppStrings.MAX_CHAT_TOKKENS,
          model: GptTurbo0301ChatModel(),
        );

        try {
          final response = await openAi.onChatCompletion(request: request);

          for (var element in response!.choices) {
            print("data -> ${element.message?.content}");
            print("dataID -> ${element.id}");
            isWaitingForResponse.value = false;
          }

          print("ConversationalID: ${response.conversionId}");
          print("ConversationalID: ${response.id}");

          if (response.choices.isNotEmpty &&
              response.choices.first.message != null) {
            conversationID = response.choices.first.message!.id;
          }

          ChatMessage messageReceived = ChatMessage(
              senderType: SenderType.Bot,
              message: response.choices[0].message!.content);
          EasyLoading.dismiss();

          //
          // saveMessage(response.choices[0].message!.content, "OpenAi",
          // gender_title.value, homeController.uniqueId ?? "1234");

          chatList.insert(0, messageReceived);
        } catch (err) {
          isWaitingForResponse.value = false;
          EasyLoading.dismiss();
          EasyLoading.showError("Something Went Wrong");

          showServerLimitError(context);
          if (err is OpenAIAuthError) {
            print('OpenAIAuthError error ${err.data?.error?.toMap()}');
          }
          if (err is OpenAIRateLimitError) {
            print('OpenAIRateLimitError error ${err.data?.error?.toMap()}');
          }
          if (err is OpenAIServerError) {
            print('OpenAIServerError error ${err.data?.error?.toMap()}');
          }
        }
      } else {
        //?Bard Response Recieved
        ChatMessage messageReceived = ChatMessage(
          senderType: SenderType.Bot,
          message: geminiResponse,
        );
        EasyLoading.dismiss();
        // final assitentMessage =
        //     Messages(role: Role.assistant, content: geminiResponse);

        // conversation.add(assitentMessage);
        // //
        // String originalString = messageReceived.input;
        // String removeString = limit;
        // messageReceived.input = originalString.replaceFirst(removeString, '');

        //
        isWaitingForResponse.value = false;
        chatList.insert(0, messageReceived);
        // saveMessage(geminiResponse, "Bard", gender_title.value,
        //     homeController.uniqueId ?? "1234");
      }

      // print("chatList: ${chatList[0].input}");
      // userMessages.value = userMessages.reversed.toList();
      textEditingController.clear();
      wait.value = false;
      // if(request_limit >= -1){
      //   request_limit--;
      // }

      // navCTL.gems.value = navCTL.gems.value - GEMS_RATE.NormalChat_GEMS_RATE;

      // savelimit();

      // navCTL.saveGems(navCTL.gems.value);
      // homectl.decreaseGEMS(GEMS_RATE.NormalChat_GEMS_RATE);
    } else {
      AwesomeDialog(
        context: context,
        dialogBackgroundColor: Colors.white,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        title: 'Please Check your Internet Connection!',
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        descTextStyle: TextStyle(color: Colors.black, fontSize: 14),
        desc:
            'The Offline Mode Alert is a feature that notifies users of no internet connection. It helps maintain a smooth user experience by displaying a clear message and providing suggestions for reconnecting.',
        // btnOkIcon: Icons.launch,
        body: Container(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.screenWidth * 0.04),
              // padding: const EdgeInsets.all(8.0),
              child: Text(
                "Offline Mode Alert!",
                // style: StyleSheet.view_heading
              ),
            ),
            // SizedBox(height: SizeConfig.screenHeight *0.02,),
            Padding(
              padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
              child: Text(
                "Please ensure that you are currently connected to the internet.",
                // style: StyleSheet.sub_heading2
              ),
            ),
            // SizedBox(height: SizeConfig.screenHeight *0.02,),
          ],
        )),
        btnOkColor: Colors.amber,
        btnCancelColor: Colors.grey,
        btnOkText: "OK",
        btnOkOnPress: () {
          // final service = FlutterBackgroundService();
          // AllowStepToCount(service);
        },
        // btnCancelOnPress: () {
        //   // onEndIconPress(context);
        // }
      )..show();
    }
  }

  showServerLimitError(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sorry! '),
        content: Text(
            'We\'re currently at our limit right now. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showNoMoreChats() {
    Get.dialog(
      AlertDialog(
        title: Text('Free Chats Finished'),
        content: Text('You have used up all your free chats.'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement the action for watching an ad
              // AppLovinProvider.instance.showRewardedAd(onRewardWatched);
              Get.back(); // Close the dialog
            },
            icon: Icon(Icons.play_arrow),
            label: Text('Watch Ad for 5 More Chats'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void initData(AIChatModel aiChatModel) {
    if (aiChatModel.type == mainContainerType.avatar) {
      // FirebaseAnalytics.instance.logSelectContent(
      //     contentType: aiChatModel.name, itemId: aiChatModel.discription);
      // limit = "Talk to me as ${aiChatModel.name}";
      limit = aiChatModel.discription;
    }

    // Now you can work with aiChatModel as an AIChatModel object

    // textEditingController.
    // textFieldFocusNode.requestFocus();

    // Adding a random message from the list to chatList
    Random random = Random();
    int randomIndex = random.nextInt(aiChatModel.stringList.length);
    String randomMessage = aiChatModel.stringList[randomIndex];
    chatList.clear();
    conversation.clear();
    gender_title.value = aiChatModel.name;
    main_image.value = aiChatModel.image; // ?

    chatList.insert(
        0,
        ChatMessage(
          senderType: SenderType.Bot,
          message: randomMessage,
        ));
    try {
      chatTrainingHistiry = ConvertStringIntoMapList(aiChatModel.history);
      developer.log("Training History $chatTrainingHistiry");
    } catch (e) {
      developer.log("Training History Exception: $e");
    }
  }

  //? Gemenin Implementation
  int messageCount = 0;
  Future<String?> sendGemeniMessage(
      RxList<ChatMessage> history, message) async {
    messageCount++;
    print("sendGemeniMessage Called..");
    String? generatedMessage = null;

    // Content userInstruction =
    //     Content(parts: [Parts(text: limit)], role: 'user');

    List<Content> chatContent = [];
    List<Content> chatHistorytContent = [];
    try {
      chatTrainingHistiry.forEach((element) {
        String role = element['role'] ?? "user";
        List<dynamic> list = element['parts'] as List<dynamic>;
        developer.log("training Histroy Message: ${list.first}");

        String parts = list.first;

        Content trainingContent =
            Content(parts: [Parts(text: parts)], role: role);
        chatHistorytContent.add(trainingContent);
      });
    } catch (e) {
      developer.log("training Histroy Error: $e");
    }

    chatContent = chatHistorytContent;
    if (chatContent.isEmpty) {
      Content userInstruction =
          Content(parts: [Parts(text: limit)], role: 'user');
      chatContent.add(userInstruction);
    }

    history.take(8).toList().reversed.forEach((element) {
      if (element.senderType == SenderType.Bot) {
        Content content =
            Content(parts: [Parts(text: element.message)], role: 'model');
        chatContent.add(content);

        developer.log("Test Chat: ${element.message},   Sender: Model");
      } else {
        String msg = element.message +
            "\nNote: Your response must be concise and should be under 30 words";
        Content content2 =
            Content(parts: [Parts(text: element.message)], role: 'user');
        chatContent.add(content2);
        developer.log("Test Chat: ${element.message},   Sender: User");
      }

      // Add both content and content2 to chatContent
    });

    developer.log("chatContent $chatContent");
  //commeted by rizwan 
    // final gemini = Gemini.instance;
    // List<SafetySetting>? safetySettings = <SafetySetting>[
    //   SafetySetting(
    //     category: SafetyCategory.sexuallyExplicit,
    //     threshold: SafetyThreshold.blockOnlyHigh,
    //   ),
    // ];

    // try {
    //   var value = await gemini.chat(chatContent,
    //       safetySettings: safetySettings,
    //       generationConfig: GenerationConfig(
    //         temperature: 0.5,
    //       ));
    //   generatedMessage = value?.output;

    //   developer.log(value?.output ?? 'without output');
    //   developer.log("${value}");
    //   return generatedMessage;
    // } catch (e) {
    //   developer.log('Gemeni Error $e', error: e);
    //   return null;

    //   // generatedMessage = "Error Message $e";
    // }

    // code  and method added by rizwan
  int geminiRequestCounter = 0 ;
  print('gemini api call ready');
  Future<String?> geminiAPICall(List<Content> chatContent) async{
    print('inside gemini api call');
    final String apiKey = RCVariables.geminiAPIKeys[geminiRequestCounter];
    print("This is api key. $apiKey");
  Gemini.reInitialize(apiKey: apiKey,enableDebugging: kDebugMode);
    
    final Gemini gemini = Gemini.instance;
    List<SafetySetting>? safetySettings = <SafetySetting>[
      SafetySetting(
        category: SafetyCategory.sexuallyExplicit,
        threshold: SafetyThreshold.blockOnlyHigh,
      ),
    ];

    try {
      var value = await gemini.chat(chatContent,
          safetySettings: safetySettings,
          generationConfig: GenerationConfig(
            temperature: 0.5,
          ));
      generatedMessage = value?.output;
      print("this is generated message $generatedMessage");
      if (generatedMessage != null) {
        
        geminiRequestCounter = 0;

        developer.log("Gemini Response: $generatedMessage");
        return generatedMessage;
      } else {
        if (geminiRequestCounter >= RCVariables.geminiAPIKeys.length - 1) {
          geminiRequestCounter = 0;

          return null;
        } else {
          geminiRequestCounter++;
          await Future.delayed(Duration(seconds: 1));
          String? generatedMessage = await geminiAPICall(chatContent);
          return generatedMessage;
        }
      }
    } catch (e) {
      if (kDebugMode) developer.log('Gemini Error $e key: $apiKey  ', error: e);
      // return "Could not generate due to some techniqal issue. please try again after a few minutes ";
      if (geminiRequestCounter >= RCVariables.geminiAPIKeys.length - 1) {
        geminiRequestCounter = 0;

        return null;
      } else {
        geminiRequestCounter++;
        await Future.delayed(Duration(seconds: 1));
        String? generatedMessage = await geminiAPICall(chatContent);
        return generatedMessage;
      }

      // generatedMessage = "Error Message $e";
    
      }

  }

    return await geminiAPICall(chatContent);
      }

  void ShareMessage(String message) {
    Share.share(message);
  }

  void CopyMessage(String message) {
    Clipboard.setData(new ClipboardData(text: message))
        .then((result) => showCopySuccessSnackBar())
        .catchError((error) => showCopyErrorSnackBar());
  }

  void showCopySuccessSnackBar() {
    final snackBar = SnackBar(content: Text('Message copied to clipboard'));
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  void showCopyErrorSnackBar() {
    final snackBar =
        SnackBar(content: Text('Error copying message to clipboard'));
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  Future<void> saveMessage(String message, String userType,
      String characterName, String userId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final characterChatHistoryCollection = firestore
          .collection('userChatHistory')
          .doc(userId)
          .collection(characterName);

      // Create a new FirebaseChat object
      final newChatMessage = FirebaseChat(
        timestamp: Timestamp.now(),
        message: message,
        senderType: userType,
      );

      // Add the new chat message directly to the character's chat history collection
      await characterChatHistoryCollection.add(newChatMessage.toMap());
    } catch (error) {
      print('Error saving message: $error');
      // Handle errors appropriately
    }
  }

  List<Map<String, dynamic>> ConvertStringIntoMapList(
      String? FormattedStringData) {
    var maps = <Map<String, dynamic>>[];
    try {
      var jsonData = jsonDecode(FormattedStringData ?? "");
      // Check if jsonData is a list; if not, wrap it in a list
      if (jsonData is List) {
        // Map each item in the list to SlideResponse
        maps = jsonData.map((item) => item as Map<String, dynamic>).toList();

        // Log the data from the first item
        return maps;
      } else {
        return maps;
      }
    } catch (e) {
      developer.log("Error: $e");

      return maps;
    }
  }
}

enum SenderType {
  User,
  Bot,
}

class ChatMessage {
  SenderType senderType;
  String message;
  // String input;

  ChatMessage({required this.senderType, required this.message});
}
