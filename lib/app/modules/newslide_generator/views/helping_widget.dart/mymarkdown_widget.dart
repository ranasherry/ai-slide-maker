import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:slide_maker/app/data/book_page_model.dart';

class MyMarkDownWidget extends StatelessWidget {
  const MyMarkDownWidget({
    super.key,
    required this.page,
  });

  final BookPageModel page;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // padding: const mat.EdgeInsets.all(30.0),
        // decoration: mat.BoxDecoration(
        //   border: mat.Border.all(color: mat.Colors.blueAccent, width: 5.0),
        //   color: mat.Colors.redAccent,
        // ),

        child: MarkdownWidget(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          data: page.ChapData,
          // config: config.copy(configs: [
          //   isDark
          //       ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
          //       : PreConfig(
          //               textStyle: TextStyle(
          //                   color: Theme.of(context).colorScheme.primary))
          //           .copy(wrapper: codeWrapper)
          // ]),
        ),
        //  buildMarkdown(Get.context!, page.ChapData),
      ),
    );
  }
}
