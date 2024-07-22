import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:slide_maker/app/utills/size_config.dart';

Container buildMarkdown(BuildContext context, String data,
    {required double width}) {
  // final isDark = Theme.of(context).brightness == Brightness.dark;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final config =
      isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
  final codeWrapper =
      (child, text, language) => CodeWrapperWidget(child, text, language);

  // PreConfig(textStyle: );
  return Container(
    width: width,
    // height: SizeConfig.blockSizeVertical * 50,
    // decoration:
    //     BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
    child: MarkdownWidget(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      data: data,
      config: config.copy(configs: [
        isDark
            ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
            : PreConfig(
                    textStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary))
                .copy(wrapper: codeWrapper)
      ]),
    ),
  );
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
