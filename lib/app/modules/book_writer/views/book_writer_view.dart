import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_maker/app/utills/size_config.dart';

import '../controllers/book_writer_controller.dart';

class BookWriterView extends GetView<BookWriterController> {
  const BookWriterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Book Writer",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(
                    right: SizeConfig.blockSizeHorizontal * 3,
                    left: SizeConfig.blockSizeHorizontal * 3),
                color: Theme.of(context).colorScheme.primary,
                height: 1.5,
              ),
              preferredSize: Size.fromHeight(6.0)),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 2,
            left: SizeConfig.blockSizeVertical * 1,
            right: SizeConfig.blockSizeVertical * 1,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        fontWeight: FontWeight.bold)),
                createTextField(context, controller.titleController, 50,
                    "Title Name", null),
                Text("Topic",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        fontWeight: FontWeight.bold)),
                createTextField(context, controller.topicController, 50,
                    "Topic Name", null),
                // // //  Add Stlye UI Designs // // //
                Text("Style",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        fontWeight: FontWeight.bold)),
                Obx(() => Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: controller.chipLabels
                          .map(
                            (option) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: ChoiceChip(
                                  label: Text(option),
                                  labelStyle: TextStyle(
                                    color: controller.nameSelectedOptions
                                            .contains(option)
                                        ? Colors.blue
                                        : Colors.white,
                                    letterSpacing: 1,
                                  ),
                                  selected: controller.nameSelectedOptions
                                      .contains(option),
                                  onSelected: (selected) {
                                    if (selected) {
                                      controller.nameSelectedOptions.clear();
                                      controller.nameSelectedOptions
                                          .add(option);
                                    }
                                  },
                                  // ? Commented by jamal start
                                  // onSelected: (selected) {
                                  //   if (selected) {
                                  //     if (controller.nameSelectedOptions.length <
                                  //         1) {
                                  //       controller.nameSelectedOptions.add(option);
                                  //       controller.avatarNameTextCTL.text = option;
                                  //     } else {
                                  //       EasyLoading.showError(
                                  //           "Please Select one name");
                                  //     }
                                  //   } else {
                                  //     controller.selectedOptions.remove(option);
                                  //   }
                                  // },
                                  // ? Commented by jamal end
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors
                                          .white, // set border color to white
                                      width: 1, // set border width
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary
                                  //   Theme.of(context)
                                  // .scaffoldBackgroundColor, // set background color to transparent
                                  // selectedColor: Colors.white,
                                  ),
                            ),
                          )
                          .toList(),
                    )),
                verticalSpace(SizeConfig.blockSizeVertical * 1),
                Text("Author Name",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        fontWeight: FontWeight.bold)),

                createTextField(context, controller.authorController, 50,
                    "Auther name", null),
                Text("Description",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        fontWeight: FontWeight.bold)),
                createTextField(context, controller.descriptionController, 500,
                    "Description", 5),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.blockSizeVertical * 2),
                    height: SizeConfig.blockSizeVertical * 5,
                    width: SizeConfig.blockSizeHorizontal * 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.indigoAccent, Colors.indigo],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3)),
                    child: Center(
                      child: Text(
                        "Generate",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget createTextField(BuildContext context, TextEditingController controller,
      int maxlength, String text, int? maxlines) {
    return TextField(
      maxLength: maxlength,
      onChanged: (value) {},
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primary,
      style: TextStyle(
        fontSize: SizeConfig.blockSizeHorizontal * 4,
        color: Theme.of(context).colorScheme.primary,
      ),
      decoration: InputDecoration(
        // labelText: text,
        // labelStyle: TextStyle(color: Colors.grey),
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4),
            borderSide: BorderSide.none
            // borderSide: BorderSide(
            //   color: Color(0xFF0095B0), // Border color
            //   width: 1.0, // Border width
            // ),
            ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            // Color(0xFF0095B0), // Border color when focused
            width: 1.0, // Border width when focused
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      minLines: null, // Null or 1 for single-line TextField
      maxLines: maxlines, // Null means infinite number of lines
      keyboardType: TextInputType.multiline, // Enable multiline input
    );
  }
}
