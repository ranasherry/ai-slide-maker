import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/presentation_home_controller.dart';

class PresentationHomeView extends GetView<PresentationHomeController> {
  const PresentationHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 244, 244),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 55),
            // color: Colors.blue,
            // height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.menu_rounded,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.search,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _noPreviousPresentation(),
        ],
      ),
    );
  }

  Column _noPreviousPresentation() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            height: 100,
            width: 400,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 232, 232),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.deepPurple,
                      size: 65,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          // color: Colors.black87,
                          child: Text(
                            "Unlock Slidey Pro",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.deepPurple),
                          ),
                        ),
                        Container(
                            width: 200,
                            // color: Colors.red,
                            child: Text(
                              "Up to 30 AI generation per day, up to 12 AI generation slides, Pro styles and much more",
                              style: TextStyle(color: Colors.grey),
                            ))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 150,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.all(30),
                  child: Text(
                    "Create your first presentation",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(1),
                  child: Text(
                    "Press plus button to create your first project. it wont take too much time Just Select the template, personalize it and fill the content",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
