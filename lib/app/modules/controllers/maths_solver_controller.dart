import 'dart:convert';
import 'dart:io';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/mathpix_response.dart';
import '../../data/response_state.dart';
import '../../routes/app_pages.dart';
import '../../utills/Gems_rates.dart';
import '../../utills/app_strings.dart';
import '../../utills/colors.dart';
import '../../utills/comm_widgets.dart';
import '../../utills/size_config.dart';

class MathsSolverController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement MathsSolverController
  // NavCTL navCTL = Get.find();////////[j.]
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int initialGems = 20;
  RxInt gems = 0.obs;
  bool? firstTime = false;
  final count = 0.obs;
  var appToken = "".obs;
  var appTokenExpiresAt = 0.obs;

  RxString output = "".obs;
  Rx<bool> shimmerEffect = true.obs;
  XFile? selectedImage;
  RxBool isImageSelected = false.obs;
  RxString selectedImagePath = "".obs;

  RxDouble demo_height = 0.0.obs;
  RxBool show_demo = false.obs;
  List<String> imgList = [
    AppImages.MathSlider1,
    AppImages.MathSlider2,
    AppImages.MathSlider3
  ];
  RxBool isTextFieldFilled = false.obs;
  // RxString textEditingController = "".obs;
  RxString questionText = "".obs;
  // RxInt request_limit = 0.obs;
  //  RxInt gems = 0.obs;
  //  int gems_rate = 3;

  Rx<ResponseState> responseState = ResponseState.idle.obs;
  //  Rx<ResponseState> responseState= ResponseState.success.obs;

  late OpenAI openAi;

  @override
  void onInit() {
    super.onInit();

    // AppLovinProvider.instance.init();
    // if (RevenueCatService().currentEntitlement.value == Entitlement.paid) {
    //   print("User Plan print: ${RevenueCatService().currentEntitlement.value}");
    //   // premiumUser.value = true;
    // } else {
    //   print(
    //       "User Plan not print: ${RevenueCatService().currentEntitlement.value}");
    // } ////////[j.]
    openAi = OpenAI.instance.build(
      token: AppStrings.OPENAI_TOKEN,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
    );
    // checkAppToken();  //? We dont need APPTOKEN Now
    //  getlimit();
    getGems();

    Future.delayed(Duration(milliseconds: 500), () {
      demo_height.value = SizeConfig.screenHeight * 0.5;
      Future.delayed(Duration(milliseconds: 500), () {});
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Future getlimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   request_limit.value = prefs.getInt('mathLimit')!;
  // }
  // Future getlimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   gems.value = prefs.getInt('gems')!;
  // }

  // increase_credits(){
  //   print("Rewarded increase credits");
  //   request_limit.value = 5;
  //   savelimit();
  // }

  // savelimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   await prefs.setInt('mathLimit', request_limit.value);
  // }

  // savelimit() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   await prefs.setInt('gems', gems.value);
  // }

  void alert() {
    Get.dialog(
      AlertDialog(
        title: Text('Credits Finished'),
        content: Text('You have used up all your credits.'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement the action for watching an ad
              // AppLovinProvider.instance.showRewardedAd(onRewardWatched);
              Get.back(); // Close the dialog
            },
            icon: Icon(Icons.dangerous),
            label: Text('You have reached to the limit'),
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

  valid(ImageSource) async {
    if (gems.value > 0) {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        // sendMessage(formattedJson);
        getImage(ImageSource);
        print("Internet ON");
      } else {
        Toster("No internet Connection", AppColors.Lime_Green_color);
        print("Internet OFF");
      }
    } else {
      // GemsFinished();
      Toster("No More Gems Available", AppColors.Electric_Blue_color);
      Get.toNamed(Routes.GemsView);
    }
  }

  Toster(msg, color) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: AppColors.white_color,
        fontSize: 16.0);
  }

  void getImage(ImageSource source) async {
    print("Entered to the getImage function");
    try {
      print("Entered to the getImage try catch");
      // final pickedImage = await ImagePicker().pickImage(source: source);
      selectedImage = await ImagePicker().pickImage(source: source);
      if (selectedImage != null) {
        isImageSelected.value = true;

        selectedImagePath.value = selectedImage!.path;
        print("Entered to the getImage try catch if");
        // uploadImageToFirebase(selectedImage!);
        // TextScanning.value = true;
        // ImageFile = pickedImage;
        // recognizedText(pickedImage);
        // .then((value){
        //   // print("Entered ScannedText:$ScannedText");
        //   // TextScanning.value = false;
        // });
        // setState();
      }
    } catch (e) {
      print("Entered to the getImage catch");
      print(e);
      // TextScanning.value = false;
      // ImageFile = null;
      // ScannedText.value = "Error occured while scanning";
    }
  }

  Future uploadImageToFirebase(XFile image) async {
    EasyLoading.show(status: "Detecting Math Problems..", dismissOnTap: false);
    // String fileName = basename(image.path);
    // StorageReference firebaseStorageRef =
    //     FirebaseStorage.instance.ref().child('uploads/$fileName');
    // StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    // taskSnapshot.ref.getDownloadURL().then(
    //       (value) => print("Done: $value"),
    //     );
    final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Get a reference to the Firebase Storage bucket
    final storage = FirebaseStorage.instance;

    // Create a reference to the image file location in Firebase Storage
    final ref = storage.ref().child('MathImages/$filename');

    // Upload the image file to Firebase Storage
    final uploadTask = ref.putFile(File(image.path));

    // Wait for the upload to complete and print the download URL
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    fetchMathpixData(downloadUrl);

    print("url:$downloadUrl");
  }

  // final ImagePicker _picker = ImagePicker();
  // Future<void> uploadImageToFirebase() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile == null) return; // User canceled picking image

  //   // Create a reference to the Firebase Storage bucket
  //   final firebase_storage.Reference storageRef = firebase_storage
  //       .FirebaseStorage.instance
  //       .ref()
  //       .child('images/${DateTime.now().toString()}');

  //   // Upload the image to Firebase Storage
  //   await storageRef.putFile(File(pickedFile.path));

  //   // Get the download URL of the uploaded image
  //   final String downloadURL = await storageRef.getDownloadURL();

  //   // You can now use the downloadURL to display the image or store it in Firestore, etc.
  //   print("Image uploaded. Download URL: $downloadURL");
  // }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    try {
      // Get a reference to the Firebase Storage bucket
      final storage = FirebaseStorage.instance;

      // Get the StorageReference for the image file from the download URL
      final ref = storage.refFromURL(imageUrl);

      // Delete the image file from Firebase Storage
      await ref.delete();

      print('Image deleted successfully');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> checkAppToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('app_token');
    final expiryTime = prefs.getInt('app_token_expires_at') ?? 0;

    if (token != null && expiryTime >= DateTime.now().millisecondsSinceEpoch) {
      // Token exists and has not expired
      appToken.value = token;
      appTokenExpiresAt.value = expiryTime;

      print("Math Pix App Token Already Exist");
      print("MathPix App Token: ${appToken.value}");
    } else {
      // Token does not exist or has expired, fetch a new token
      getAppToken();
    }
  }

  Future<void> getAppToken() async {
    final url = "https://api.mathpix.com/v3/app-tokens";
    final headers = {"app_key": AppStrings.MATHPIX_APIKEY};

    try {
      final response = await http.post(Uri.parse(url), headers: headers);
      final responseData = json.decode(response.body);

      // Save the app token and expiry time to shared preferences
      await saveAppToken(
          responseData['app_token'], responseData['app_token_expires_at']);

      // Store the app token and expiry time in the GetX controller's local variables
      appToken.value = responseData['app_token'];
      appTokenExpiresAt.value = responseData['app_token_expires_at'];

      print("AppToken Value: ${appToken.value}");
    } catch (e) {
      print("Error fetching app token: $e");
    }
  }

  Future<void> saveAppToken(String token, int expiryTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_token', token);
    await prefs.setInt('app_token_expires_at', expiryTime);
  }

  Future<void> getAppTokenFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('app_token') ?? "";
    final expiryTime = prefs.getInt('app_token_expires_at') ?? 0;
    appToken.value = token;
    appTokenExpiresAt.value = expiryTime;
  }

  Future<void> fetchMathpixData(String imageUrl) async {
    EasyLoading.show(status: "Generating Solution...");
    responseState.value = ResponseState.waiting;
    print("fetch MathpixData Called");
    final String apiUrl = 'https://api.mathpix.com/v3/text';
    // final String appId = 'YOUR_APP_ID';
    // final String appKey = 'YOUR_APP_KEY';

    final Map<String, String> headers = {
      'app_id': AppStrings.MATHPIX_APPID,
      'app_key': AppStrings.MATHPIX_APIKEY,
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      "src": "$imageUrl",
      "formats": ["text", "data"],
      "data_options": {"include_asciimath": true}
    };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(requestBody));

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print("MathPix CompleteResponse: ${decodedResponse}");

        MathpixResponse mathpixResponse =
            MathpixResponse.fromJson(decodedResponse);
        print("Math Formula: ${mathpixResponse.data.first.value}");
        sendMessage(mathpixResponse.text);
        questionText.value = mathpixResponse.text;
        print("questionText");

        deleteImageFromFirebase(imageUrl);
        // update(); // Notify the listeners about the change in the controller data
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError("Could not extract Math Problems",
            duration: Duration(milliseconds: 3000));
        // Handle error case
        print('MathPix Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      // Handle error case
      EasyLoading.showError("Something went Wrong");

      print('Error occurred in MathPix: $e');
    }
  }

  Future sendMessage(String text) async {
// String message="try to give response using under ${AppStrings.MAX_MATHPIXTOKEN} Tokens.  Solve all Math Problem in below Text if exist. Also explain and write math notation into LaTeX notation also use latex notation if it occur in explanation sentence. Text:  $text";
    String message =
        "Try to give a response using under ${AppStrings.MAX_MATHPIXTOKEN} tokens. Solve all math problems in the below text if they exist. Also, explain and write math notation into LaTeX notation. Use LaTeX notation if it occurs in the explanation sentence and alway use double dollar symbol so my textview can recognize all latex notation in text in .\n\nText: $text";

    print("Solve the Math Problem if Exisit in following  $text");

    final userMessage = Messages(role: Role.user, content: message);
    final request = ChatCompleteText(
      messages: [userMessage],
      // maxToken: AppStrings.MAX_CHAT_TOKKENS,
      maxToken: AppStrings.MAX_MATHPIXTOKEN,
      model: GptTurbo0301ChatModel(),
    );

    try {
      final response = await openAi.onChatCompletion(request: request);

      for (var element in response!.choices) {
        print("data -> ${element.message?.content}");
        print("dataID -> ${element.id}");
        // isWaitingForResponse.value = false;
        // shimmerEffect.value = false;
      }
      EasyLoading.dismiss();

      print("ConversationalID: ${response.conversionId}");
      print("ConversationalID: ${response.id}");

      if (response.choices.isNotEmpty &&
          response.choices.first.message != null) {
        // responseState.value=ResponseState.success;
        // conversationID = response.choices.first.message!.id;
      } else {
        responseState.value = ResponseState.failure;
      }

      ChatMessage messageReceived = ChatMessage(
          senderType: SenderType.Bot,
          message: response.choices[0].message!.content,
          input: message);

      // EasyLoading.dismiss();
      //
      String originalString = messageReceived.message;
      output.value = originalString;
      questionText.value = text;
      responseState.value = ResponseState.success;
      print("OutPut Value: ${output.value}");

      // String removeString = limit;
      // messageReceived.input = originalString.replaceFirst(removeString, '');
      //
      // chatList.insert(0, messageReceived);

      // request_limit.value--;
      // gems.value = gems.value - gems_rate;
      // navCTL.gems.value = navCTL.gems.value - GEMS_RATE.MATH_GEMS_RATE;
      // // savelimit();
      // navCTL.saveGems(navCTL.gems.value);
      decreaseGEMS(GEMS_RATE.MATH_GEMS_RATE);
    } catch (err) {
      EasyLoading.dismiss();
      EasyLoading.showError("Could not solve the problem");
      // EasyLoading.dismiss();
      // EasyLoading.showError("Something Went Wrong");
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
  }

  void showNoRewarded() {
    if (Platform.isAndroid) {
      // NavCTL navCTL = Get.find();/////[j.]
      // navCTL.subscriptionCall();/////[j.]
      // Get.toNamed(Routes.SUBSCRIPTION);
    } else {
      Get.dialog(RewardAdDialog());
    }
  }

  Future<int> getGems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      gems.value = prefs.getInt('gems') ?? 100;
    } else {
      gems.value = prefs.getInt('gems') ?? GEMS_RATE.FREE_GEMS;
    }
    print("GEMS value: ${gems.value}");
    return gems.value;
  }

  decreaseGEMS(int decrease) async {
    print("value: $decrease");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value - decrease;
    if (gems.value < 0) {
      gems.value = 0;
      await prefs.setInt('gems', gems.value);
    } else {
      await prefs.setInt('gems', gems.value);
    }

    print("inters");
    getGems();
  }

  increaseGEMS(int increase) async {
    print("value: $increase");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value + increase;
    await prefs.setInt('gems', gems.value);
    print("inters");
    getGems();
  }

  Future CheckUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('first_time');

    // var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime!) {
      // Not first time
      gems.value = prefs.getInt('gems')!;
      print("Not First time");
      print("${firstTime}");
      //     Timer(Duration(seconds: 3), () {
      //       // CheckUser();
      //       // AppLovinProvider.instance.init();
      //       Get.offNamed(Routes.NAV,arguments: false);
      // });
    } else {
      // First time
      prefs.setBool('first_time', false);
      print("First time");
      print("${firstTime}");
      await prefs.setInt('limit', 5);
      await prefs.setInt('mathLimit', 3);
      await prefs.setInt('gems', initialGems).then((value) {
        gems.value = prefs.getInt('gems')!;
      });
    }
  }

  void onTextChanged(String text) {
    isTextFieldFilled.value = text.isNotEmpty;
  }

  void showDialogBox() {
    Get.defaultDialog(
      title: "Short Question",
      titleStyle: TextStyle(
          color: Color(0xFF202965),
          fontSize: SizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.bold),
      backgroundColor: Color(0xFFE7EBFA),
      content: Container(
        height: SizeConfig.blockSizeVertical * 8,
        width: SizeConfig.blockSizeHorizontal * 65,
        child: DottedBorder(
          borderType: BorderType.RRect,
          strokeCap: StrokeCap.round,
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
          color: Color(0xFF202965),
          // dashPattern: [19, 2, 6, 3],
          dashPattern: [6, 1, 8, 11],
          radius: Radius.circular(SizeConfig.blockSizeHorizontal * 4),
          strokeWidth: 2,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  onChanged: onTextChanged,
                  cursorColor: Color(0xFF202965),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              horizontalSpace(SizeConfig.blockSizeHorizontal * 1),
              Obx(() => isTextFieldFilled.value
                  ? GestureDetector(
                      onTap: () {
                        if (gems.value > 0) {
                          Get.toNamed(Routes.ShortQuestionView);
                          // controller.sendMessage(controller.res.value);
                          if (gems.value < GEMS_RATE.MATH_GEMS_RATE) {
                            //TODO: Route to Coins Page
                            Get.toNamed(Routes.GemsView);

                            Toster("You Dont have enough Gems",
                                AppColors.Electric_Blue_color);
                          } else {
                            responseState.value = ResponseState.waiting;
                            questionText.value =
                                textEditingController.text.toString();
                            sendMessage(textEditingController.text.toString());
                            // uploadImageToFirebase(selectedImage!);
                          }
                        } else {
                          Toster("No More Gems Available",
                              AppColors.Electric_Blue_color);
                        }

                        // Get.toNamed(Routes.ShortQuestionView);
                        //  EasyLoading.show(status: "Detecting Math Problems..", dismissOnTap: false);
                      },
                      child: Container(
                          height: SizeConfig.blockSizeVertical * 10,
                          width: SizeConfig.blockSizeHorizontal * 12,
                          decoration: BoxDecoration(
                              color: Color(0xFF202965), shape: BoxShape.circle),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )),
                    )
                  : Image.asset(
                      AppImages.pencil,
                      scale: 12,
                      color: Color(0xFF00598D),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}

enum SenderType {
  User,
  Bot,
}

class ChatMessage {
  SenderType senderType;
  String message;
  String input;

  ChatMessage(
      {required this.senderType, required this.message, required this.input});
}
