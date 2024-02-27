import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:slide_maker/app/modules/invitation_maker/views/helping_widgets/my_editable_text.dart';
import 'package:slide_maker/app/utills/images.dart';

class DraggableText extends StatefulWidget {
  const DraggableText({super.key});

  @override
  State<DraggableText> createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  late Rect rect = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 100,
    height: 100,
  );
  String text = "Hello";

  @override
  Widget build(BuildContext context) {
    return TransformableBox(
      debugPaintHandleBounds: true,
      visibleHandles: {
        ...HandlePosition
            .values, // Convenient list that contains only corner handles.
      },
      flip: Flip.none,
      rect: rect,
      clampingRect: Offset.zero & MediaQuery.sizeOf(context),
      onChanged: (result, event) {
        setState(() {
          rect = result.rect;
        });
      },
      contentBuilder: (context, rect, flip) {
        return Container(
            width: rect.width, // Set width to match container
            height: rect.height, // Set height to match container
            child: MyEditableText(
              text: "Hello",
            ));
      },
    );
  }
}
