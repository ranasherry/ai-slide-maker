import 'dart:io';
import 'dart:typed_data';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:lottie/lottie.dart';
import '../../routes/app_pages.dart';
import '../../utills/app_strings.dart';
import '../../utills/colors.dart';
import '../../utills/images.dart';
import '../../utills/size_config.dart';
import '../../utills/style.dart';
import '../controllers/slide_maker_controller.dart';

class SlideMakerView extends GetView<SlideMakerController> {
  const SlideMakerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: Drawer(
        width: SizeConfig.blockSizeHorizontal * 75,
        child: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 30,
              color: AppColors.neonBorder,
              child: Image.asset(
                AppImages.drawer,
                scale: 5,
              ),
            ),
            GestureDetector(
                onTap: () {
                  LaunchReview.launch(
                    androidAppId: "com.genius.aislides.generator",
                  );
                },
                child: drawer_widget(Icons.thumb_up, "Rate Us")),
            GestureDetector(
                onTap: () {
                  controller.ShareApp();
                },
                child: drawer_widget(Icons.share, "Share")),
            GestureDetector(
                onTap: () {
                  controller
                      .openURL("https://sites.google.com/view/appgeniusx/home");
                },
                child: drawer_widget(Icons.privacy_tip, "Privacy Policy"))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Slide Maker'),
        centerTitle: true,
        leading: Obx(
          () => controller.showSlides.value
              ? GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_back_ios_new,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    controller.scaffoldKey.currentState!.openDrawer();
                  },
                  child: Icon(Icons.menu)),
        ),
        actions: [
          Obx(() =>

              // RevenueCatService().currentEntitlement.value == Entitlement.paid?
              //     Container()
              //     :
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.convertToPPT();
                      controller.Toster("Opening...", AppColors.Green_color);
                    },
                    child: controller.showSlides.value
                        ? Platform.isAndroid
                            ? Card(
                                color: AppColors.foreground_color2,
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Share",
                                    style: StyleSheet.Intro_Sub_heading_black,
                                  ),
                                ),
                              )
                            : Container()
                        : Container(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.GemsView);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.gems,
                          scale: 30,
                        ),
                        Text(" ${controller.gems.value}"),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.03,
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
      body: Obx(() => Center(
            child: Stack(children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.showSlides.value
                        ? slideShow()
                        : AnimatedContainer(
                            width: controller.input_box_width.value,
                            height: controller.input_box_height.value,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.icon_color),
                            ),
                            child: controller.showInside.value
                                ? Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        outField(),
                                        Divider(),
                                        inputField(),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        createButton(),
                        controller.outlineTitleFetched.value
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: SizeConfig.screenWidth * 0.15,
                                  ),
                                  NextButton(),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: Colors.amber,
                  child: Center(
                    child: MaxAdView(
                        adUnitId: AppStrings.MAX_BANNER_ID,
                        adFormat: AdFormat.banner,
                        listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                          print(
                              'Banner widget ad loaded from ' + ad.networkName);
                        }, onAdLoadFailedCallback: (adUnitId, error) {
                          print(
                              'Banner widget ad failed to load with error code ' +
                                  error.code.toString() +
                                  ' and message: ' +
                                  error.message);
                        }, onAdClickedCallback: (ad) {
                          print('Banner widget ad clicked');
                        }, onAdExpandedCallback: (ad) {
                          print('Banner widget ad expanded');
                        }, onAdCollapsedCallback: (ad) {
                          print('Banner widget ad collapsed');
                        })),
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  Padding drawer_widget(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 5,
          top: SizeConfig.blockSizeVertical * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: SizeConfig.blockSizeHorizontal * 7,
            color: AppColors.neonBorder,
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 12),
          Text(
            text,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }

  Widget slideShow() {
    return SingleChildScrollView(
      child: Container(
        height: SizeConfig.screenHeight * 0.8,
        child: ListView.builder(
            itemCount: controller.outlineTitles.length,
            cacheExtent: 99999,
            // addAutomaticKeepAlives: true, // the number of items in the list
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  singleSlide(index),
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      color: AppColors.Green_color,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Slide ${index + 1}",
                          style: StyleSheet.Intro_Sub_heading,
                        ),
                      ),
                    ),
                  )
                ],
              );
              // ListTile(
              //   title: Text('Item ${index + 1}'), // the title of each item
              // );
            }),
      ),
    );
    // singleSlide();
  }

  Widget singleSlide(index) {
    String title = controller.slideResponseList[index].slideTitle;
    String dis = controller.slideResponseList[index].slideDescription;
    String imagePrompt = "Create an image of $title";
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        color: AppColors.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // adjust the value as you like
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  // width: 200,
                  // height: 250,
                  width: SizeConfig.screenWidth * 0.5,
                  height: SizeConfig.screenHeight * 0.3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // "The Future of AI and evolving AI",
                          "${controller.slideResponseList[index].slideTitle}",
                          style: StyleSheet.Subscription_heading,
                        ),
                        Divider(),
                        Text(
                            // "Artificial Intelligence (AI) is a rapidly advancing field of computer science that empowers machines to mimic human intelligence, enabling them to learn from data, reason, make decisions, and solve complex problems. AI is transforming industries, from healthcare to finance, by automating tasks, improving efficiency, and driving innovation.",
                            "${controller.slideResponseList[index].slideDescription}",
                            style: StyleSheet.Intro_Sub_heading),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(height: SizeConfig.screenHeight *0.1,),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // adjust the value as you like
                    ),
                    elevation: 10.0, // adjust the value as you like
                    child: SlideImageContainer(
                        controller: controller, imagePrompt: imagePrompt),
                  ),
                ],
              )

              // )

              // Card(
              //   child:
              // Container(
              //   width: SizeConfig.screenWidth *0.3,
              //   child: Image.network("https://cdn.britannica.com/47/246247-050-F1021DE9/AI-text-to-image-photo-robot-with-computer.jpg"))
              //   // child: Image.network("https://stackoverflow.com/questions/73336313/exception-invalid-image-data"))
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget NextButton() {
    return GestureDetector(
      onTap: () {
        // controller.increaseOutputHeight();
        controller.hide_outlines();
      },
      child: AnimatedContainer(
        width: controller.create_box_width.value,
        height: controller.create_box_height.value,
        // color: AppColors.Bright_Pink_color,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: AppColors.icon_color),
          color: AppColors.Green_color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              // controller.outlineTitleFetched.value?
              // "Recreate"
              // :
              "Next",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget outField() {
    return SingleChildScrollView(
      child: Column(
        children: [
          controller.outlineTitleFetched.value
              ? Column(
                  children: [
                    Text(
                      "Outlines of the topic",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          color: Colors.black),
                    ),
                    Container(
                      // height: SizeConfig.screenHeight*0.32,
                      height: 290,
                      child: ListView.builder(
                          itemCount: controller.slideResponseList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                leading: const Icon(Icons.arrow_forward),
                                // trailing: const Text(
                                //   "GFG",
                                //   style: TextStyle(color: Colors.green, fontSize: 15),
                                // ),
                                title: Text(
                                  "${controller.slideResponseList[index].slideTitle}",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                      color: Colors.black),
                                ));
                          }),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    height: SizeConfig.screenHeight * 0.03,
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.slides,
                          color: AppColors.icon_color,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Create presentation about.....",
                          style: TextStyle(
                              // fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.black),
                        ),
                        // Container(
                        //   color: AppColors.greybox,
                        //   child:
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(children: [
                        //     Image.asset(AppImagesPack2.slides,color: AppColors.icon_color,),
                        //     Text("6 pages",
                        //   style: TextStyle(
                        //   // fontSize: SizeConfig.blockSizeHorizontal * 4,
                        //   color: Colors.white),
                        //   ),
                        //   ],),
                        // ),)
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget outlineTitle() {
    return Container();
  }

  Widget createButton() {
    return GestureDetector(
      onTap: () {
        // controller.increaseOutputHeight();
        controller.validate_user_input();
      },
      child: AnimatedContainer(
        width: controller.create_box_width.value,
        height: controller.create_box_height.value,
        // color: AppColors.Bright_Pink_color,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: AppColors.icon_color),
          color: AppColors.neonBorder,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              controller.outlineTitleFetched.value ? "Recreate" : "Create",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextField(
        controller: controller.inputTextCTL,
        cursorColor: Colors.black,
        style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal * 4, color: Colors.black),
        decoration: InputDecoration(
          // hintText: text,
          // "Product Name",
          labelStyle: TextStyle(color: AppColors.black_color),
          labelText: "What is the presentation about?",
          hintText: "Example: What is AI?",
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
            // borderSide: BorderSide(
            //   color: Color(0xFF0095B0), // Border color
            //   width: 1.0, // Border width
            // ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
            borderSide: BorderSide(
              color: Color(0xFF0095B0), // Border color when focused
              width: 3.0, // Border width when focused
            ),
          ),
        ),
        // cursorColor: Colors.white,
        //               style: TextStyle(
        //                   // fontSize: SizeConfig.blockSizeHorizontal * 4,
        //                   color: Colors.white),
        // decoration: InputDecoration(labelText:
        // "Product Name",
        // // fillColor: Colors.white
        // // colo
        // ),
        onChanged: (value) {
          print(value);
          controller.userInput.value = value;
        },
      ),
    );
  }
}

class SlideImageContainer extends StatefulWidget {
  const SlideImageContainer({
    Key? key, // Corrected
    required this.controller,
    required this.imagePrompt,
  }) : super(key: key); // Corrected

  final SlideMakerController controller;
  final String imagePrompt;

  @override
  State<SlideImageContainer> createState() => _SlideImageContainerState();
}

class _SlideImageContainerState extends State<SlideImageContainer> {
  Future<Uint8List?>? imageFuture;
  SlideMakerController slideMakerController = Get.find();
  // image.

  @override
  void initState() {
    super.initState();
    imageFuture = widget.controller.makeArtRequest(widget.imagePrompt);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth *
            0.3, // Assuming SizeConfig is defined and screenWidth is accessible
        // width: 150, // Assuming SizeConfig is defined and screenWidth is accessible
        height: SizeConfig.screenHeight *
            0.2, // Assuming SizeConfig is defined and screenWidth is accessible
        // height: 150, // Assuming SizeConfig is defined and screenWidth is accessible
        child: FutureBuilder<Uint8List?>(
          // future: widget.controller.makeArtRequest(widget.imagePrompt),
          future: imageFuture,

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is running, show a loading indicator or placeholder.
              // return CircularProgressIndicator();
              return Lottie.asset('assets/lottie/fBBmyrlUDl.json');
            } else if (snapshot.hasError) {
              // If the future encounters an error, display an error message.
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final imageBytes = snapshot.data!;
              slideMakerController.imageslist.add(imageBytes);
              //  imagesList.add(imageBytes);

              // If the future completes successfully and provides imageBytes, display the image.
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              // If no data is available yet, you can show a placeholder or an empty container.
              return Container();
            }
          },
        )
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10.0), // Same as the Card's borderRadius for rounded corners
        //   child: Image.network(
        //     "https://cdn.britannica.com/47/246247-050-F1021DE9/AI-text-to-image-photo-robot-with-computer.jpg",
        //     fit: BoxFit.cover, // You can adjust this to control how the image fits within the container
        //   ),
        // ),
        );
  }
}
