import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 扩展widget
class Expand extends StatelessWidget {
  final bool isExpand;
  final VoidCallback onExpandValueChanged;
  final Widget titleChild;
  final Widget child;

  Expand(
      {Key key,
      @required this.titleChild,
      @required this.child,
      @required this.isExpand,
      @required this.onExpandValueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            titleChild,
            Expanded(child: SizedBox()),
            IconButton(
                onPressed: onExpandValueChanged,
                icon: Icon(isExpand
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right))
          ],
        ),
        isExpand ? child : SizedBox()
      ],
    );
  }
}
