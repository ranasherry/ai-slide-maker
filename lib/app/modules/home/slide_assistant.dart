import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/modules/controllers/slide_assistant_controller.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/provider/meta_ads_provider.dart';
import 'package:slide_maker/app/utills/colors.dart';
import 'package:slide_maker/app/utills/images.dart';
import 'package:slide_maker/app/utills/nointernet_widget.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../../provider/connectivity_provider.dart';

class AiSlideAssistant extends GetView<AiSlideAssistantCTL> {
  const AiSlideAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = context.watch<ConnectivityProvider>().isConnected;

    return isConnected
        ? WillPopScope(
            onWillPop: () async {
              log("backed");
              final FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                // If no widget has focus, close the keyboard (optional)
                FocusManager.instance.primaryFocus?.unfocus();
                return true; // Allow back navigation
              }

              final bool isKeyboardVisible =
                  await KeyboardVisibilityController().isVisible;

              if (isKeyboardVisible) {
                // Close the keyboard
                currentFocus.unfocus();
                return false; // Prevent immediate back navigation
              } else {
                log("backed");
                return true; // Allow back navigation
              }
            },
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, SizeConfig.screenHeight * 0.04, 0, 0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Obx(() => controller.chatList.length == 0
                                ? Center(
                                    child: Container(
                                      child: Text(
                                        "No Chat Yet!",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    4,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        // style: StyleSheet.Intro_heading,
                                      ),
                                    ),
                                  )
                                :
                                // controller.
                                Container(
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.blockSizeVertical * 8),
                                    child: Obx(() => ListView.builder(
                                          reverse: true,
                                          itemCount: controller
                                                  .isWaitingForResponse.value
                                              ? controller.chatList.length + 1
                                              : controller.chatList.length,
                                          itemBuilder: (context, index) {
                                            int adjustedIndex = controller
                                                    .isWaitingForResponse.value
                                                ? index - 1
                                                : index;

                                            String message = "";
                                            bool isSender = true;
                                            RxBool isFeedback = false.obs;
                                            RxBool isGood = false.obs;

                                            if (adjustedIndex == -1) {
                                              // When waiting for response (show dummy loading bubble maybe)
                                              isSender = false;
                                              message =
                                                  "Waiting for response...";
                                            } else {
                                              isSender = controller
                                                      .chatList[adjustedIndex]
                                                      .senderType ==
                                                  SenderType.User;
                                              message = controller
                                                  .chatList[adjustedIndex]
                                                  .message;
                                              isFeedback.value = controller
                                                  .chatList[adjustedIndex]
                                                  .isFeedBack
                                                  .value;
                                              isGood.value = controller
                                                  .chatList[adjustedIndex]
                                                  .isGood
                                                  .value;
                                            }

                                            return Obx(() => _MessageBubble(
                                                  isSender,
                                                  message,
                                                  adjustedIndex,
                                                  context,
                                                  isFeedback.value,
                                                  isGood.value,
                                                ));
                                          },
                                        )),
                                  )),
                          ),
                          _InputField(context),
                          // SizedBox(
                          //   height: SizeConfig.screenHeight * 0.01,
                          // )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      // color: Colors.black,
                      height: SizeConfig.screenHeight * 20,
                      child: _CustomeAppBar(context)),
                ],
              ),
            ),
          )
        : NoInternetWidget();
  }

  Widget _CustomeAppBar(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 3),
        // height: Get.statusBarHeight * SizeConfig.blockSizeVertical * 20,
        // color: const Color.fromARGB(26, 0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 5,
              ),
              // color: const Color.fromARGB(26, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
                        MetaAdsProvider.instance.showInterstitialAd();
                      } else {
                        AppLovinProvider.instance.showInterstitial(() {});
                      }
                      controller.current_index.value = 0;
                      // controller.chatList.clear();
                      controller.conversation.clear();
                      controller.gender_title.value = "AI Assistant";
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      }
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: SizeConfig.blockSizeHorizontal * 7,
                      // color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 20),
                  Expanded(
                    child: Obx(() => Text(
                          controller.gender_title.value,
                          style: TextStyle(
                            // color: Theme.of(context).colorScheme.primary,
                            fontSize: SizeConfig.blockSizeHorizontal * 6,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
              child: Text(
                "Note: This is AI Generated Content",
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 3,
                  // color: Theme.of(context).colorScheme.onPrimary
                ),
                // style: StyleSheet.noteHeading,
              ),
            ),
            verticalSpace(SizeConfig.blockSizeVertical)
          ],
        ),
      ),
    );
  }

  Widget _InputField(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2,
          right: SizeConfig.blockSizeHorizontal * 2,
          bottom: SizeConfig.blockSizeVertical * 0.5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .primary, // Set the border color here
          width: 1.0, // Set the border width here
        ),
        borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6),
      ),

      // ),
      child: Container(
        // color: Colors.red,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 3,
              vertical: SizeConfig.blockSizeVertical * 0.5),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: controller.textFieldFocusNode,
                      maxLength: 500,
                      onChanged: (value) {
                        print("value: $value");
                        if (value == "") {
                          controller.userIsTyping.value = false;
                        } else {
                          controller.userIsTyping.value = true;
                        }
                      },
                      controller: controller.textEditingController,
                      cursorColor: Theme.of(context).colorScheme.primary,
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // WhatsApp text color
                      ),
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).colorScheme.primary,
                        // hintMaxLines: 10,
                        hintText: "Write Your Message here...",
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),

                        border: InputBorder.none, // Remove the border
                        counterStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(
                                "Send Message ${controller.textEditingController.text}");
                            if (!controller.wait.value) {
                              if (controller
                                  .textEditingController.text.isNotEmpty) {
                                controller.isWaitingForResponse.value = true;
                                // ? Commented by jamal start
                                controller.sendMessage(
                                    "${controller.textEditingController.text}",
                                    context);
                                //// ? Commented by jamal end
                                controller.lastMessage.value =
                                    controller.textEditingController.text;
                                controller.textEditingController.clear();
                              }
                            }
                          },
                          icon: Container(
                            height: SizeConfig.blockSizeVertical * 6,
                            width: SizeConfig.blockSizeHorizontal * 12,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.send_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ), // WhatsApp send button icon
                        )
                        // :
                        // Container()

                        ,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _MessageBubble(bool isSender, String message, int index,
      BuildContext context, bool isFeedback, bool isGood) {
    double iconSize = SizeConfig.blockSizeHorizontal * 5;

    return Container(
      width: SizeConfig.screenWidth,
      // color: Colors.black,
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            //? Avatar image for Bot
            if (!isSender) ...[
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1),
                child: Container(
                  height: SizeConfig.blockSizeVertical * 10,
                  width: SizeConfig.blockSizeHorizontal * 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(AppImages.ai_assistan))),
                ),
              )
            ],
            Column(
              crossAxisAlignment: isSender
                  ? message.length <= 30
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  width: message.length <= 30
                      ? null
                      : SizeConfig.screenWidth * 0.7,
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 0.5,
                      horizontal: SizeConfig.blockSizeHorizontal * 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 4),
                  ),
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: index == -1 &&
                                controller.isWaitingForResponse.value
                            // true
                            ? _typingIndicator()
                            : isSender || (message.length <= 60 && !isSender)
                                ? Text(
                                    controller.chatList[index].message,
                                  )
                                : buildMarkdown(context, index),
                      ),
                    ],
                  ),
                ),
                !(index == -1 && controller.isWaitingForResponse.value)
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 5),
                        child: Row(
                          mainAxisAlignment: isSender
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                                padding: EdgeInsets.zero,
                                color: Theme.of(context).colorScheme.primary,
                                tooltip: "Share",
                                onPressed: () {
                                  controller.ShareMessage(
                                      controller.chatList[index].message);
                                },
                                icon: Icon(Icons.share)),
                            // horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                            IconButton(
                                padding: EdgeInsets.zero,
                                color: Theme.of(context).colorScheme.primary,
                                tooltip: "Copy",
                                onPressed: () {
                                  controller.CopyMessage(
                                      controller.chatList[index].message);
                                },
                                icon: Icon(Icons.copy_rounded)),
                            Obx(() {
                              bool feedbackGiven =
                                  controller.chatList[index].isFeedBack.value;
                              bool positive =
                                  controller.chatList[index].isGood.value;

                              return !isSender && !(feedbackGiven && !positive)
                                  ? IconButton(
                                      onPressed: () {
                                        if (!feedbackGiven) {
                                          controller.GoodResponse(
                                              controller
                                                  .chatList[index].message,
                                              index);
                                        }
                                      },
                                      icon: Icon(
                                        feedbackGiven && positive
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_alt_outlined,
                                        size: iconSize,
                                      ),
                                    )
                                  : Visibility(
                                      visible: false, child: Container());
                            }),

                            Obx(() {
                              bool feedbackGiven =
                                  controller.chatList[index].isFeedBack.value;
                              bool positive =
                                  controller.chatList[index].isGood.value;

                              return !isSender && !(feedbackGiven && positive)
                                  ? IconButton(
                                      onPressed: () {
                                        if (!feedbackGiven) {
                                          controller.reportMessage(
                                              Get.context!,
                                              controller
                                                  .chatList[index].message,
                                              index);
                                        }
                                      },
                                      icon: Icon(
                                        feedbackGiven && !positive
                                            ? Icons.thumb_down
                                            : Icons.thumb_down_alt_outlined,
                                        size: iconSize,
                                      ),
                                    )
                                  : Visibility(
                                      visible: false, child: Container());
                            }),
                          ],
                        ),
                      )
                    : Visibility(
                        visible: false,
                        child: Container(),
                      ),
              ],
            ),
            if (isSender) ...[
              Padding(
                  padding: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 1),
                  child: Icon(
                    Icons.person,
                    color: AppColors.mainColor,
                    size: 30,
                  )
                  //  Image.asset(
                  //   AppImages.bot,
                  //   // scale: 12,
                  // ),
                  )
            ],
          ],
        ),
      ),
    );
  }

  Container buildMarkdown(BuildContext context, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    final codeWrapper =
        (child, text, language) => CodeWrapperWidget(child, text, language);

    // PreConfig(textStyle: );
    return Container(
      width: SizeConfig.screenWidth,
      // height: SizeConfig.blockSizeVertical * 50,
      child: MarkdownWidget(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        data: controller.chatList[index].message,
        config: config.copy(configs: [
          isDark
              ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
              : PreConfig(
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary))
                  .copy(wrapper: codeWrapper)
        ]),
      ),
    );
  }

  Widget _typingIndicator() {
    print("Type Indicator..");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _animatedDot(0),
          SizedBox(width: 8.0),
          _animatedDot(1),
          SizedBox(width: 8.0),
          _animatedDot(2),
        ],
      ),
    );
  }

  Widget _animatedDot(int index) {
    return AnimatedBuilder(
      animation: controller.typingAnimation!,
      builder: (context, child) {
        return Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0
                ? Colors.grey.shade600
                : controller.typingAnimation!.value < (index / 3)
                    ? Colors.grey.withOpacity(0.3)
                    : Colors.grey.shade400,
          ),
        );
      },
    );
  }
}

class CodeWrapperWidget extends StatefulWidget {
  final Widget child;
  final String text;
  final String language;

  const CodeWrapperWidget(this.child, this.text, this.language, {Key? key})
      : super(key: key);

  @override
  State<CodeWrapperWidget> createState() => _PreWrapperState();
}

class _PreWrapperState extends State<CodeWrapperWidget> {
  late Widget _switchWidget;
  bool hasCopied = false;

  @override
  void initState() {
    super.initState();
    _switchWidget = Icon(Icons.copy_rounded, key: UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        widget.child,
        Align(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.language.isNotEmpty)
                  SelectionContainer.disabled(
                      child: Container(
                    child: Text(widget.language),
                    margin: EdgeInsets.only(right: 2),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            width: 0.5,
                            color: isDark ? Colors.white : Colors.black)),
                  )),
                InkWell(
                  child: AnimatedSwitcher(
                    child: _switchWidget,
                    duration: Duration(milliseconds: 200),
                  ),
                  onTap: () async {
                    // if (hasCopied) return;
                    // await Clipboard.setData(ClipboardData(text: widget.text));
                    // _switchWidget = Icon(Icons.check, key: UniqueKey());
                    // refresh();
                    // Future.delayed(Duration(seconds: 2), () {
                    //   hasCopied = false;
                    //   _switchWidget =
                    //       Icon(Icons.copy_rounded, key: UniqueKey());
                    //   refresh();
                    // });
                  },
                ),
              ],
            ),
          ),
          alignment: Alignment.topRight,
        )
      ],
    );
  }

  void refresh() {
    if (mounted) setState(() {});
  }
}
