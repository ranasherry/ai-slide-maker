import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_maker/app/provider/applovin_ads_provider.dart';
import 'package:slide_maker/app/routes/app_pages.dart';

class BookWriterController extends GetxController {
  //TODO: Implement BookWriterController

  final count = 0.obs;
  var titleController = TextEditingController();
  var topicController = TextEditingController();
  var languageController = TextEditingController();
  var authorController = TextEditingController();
  var pagesController = TextEditingController();
  var descriptionController = TextEditingController();

  var selectedChips = <String>[].obs;

  var nameSelectedOptions = <String>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> chipLabels = [
    'Reflective',
    'Persuasive',
    'Scientific',
    'Expository',
    'Descriptive',
  ];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Method to toggle chip selection
  void toggleChip(String chipLabel) {
    if (selectedChips.contains(chipLabel)) {
      selectedChips.remove(chipLabel);
    } else {
      selectedChips.add(chipLabel);
    }
  }

  void selectChip(String chipLabel) {
    if (!selectedChips.contains(chipLabel)) {
      selectedChips.add(chipLabel);
    }

    // Method to check if a chip is selected
    bool isChipSelected(String chipLabel) {
      return selectedChips.contains(chipLabel);
    }

    void increment() => count.value++;
  }

  void generateBook() {
    String requestString =
        '''Generate the Outlines for the Book with the following detailes.
    Book Title: ${titleController.text}
    Subtitle: ${topicController.text}
    Style: ${selectedChips} 
    description: ${descriptionController.text}

    Note: The Outlines must be comma seperated only chapter names and must contains only 5 chapters.
    ''';

    String mainDetail = '''
       Book Title: ${titleController.text}
    Subtitle: ${topicController.text}
    Style: ${selectedChips} 
    description: ${descriptionController.text}
    ''';

    AppLovinProvider.instance.showInterstitial(() {});
    Get.toNamed(
      Routes.BOOK_GENERATED,
      arguments: [
        requestString,
        authorController.text,
        mainDetail,
        titleController.text
      ],
    );
  }
}
