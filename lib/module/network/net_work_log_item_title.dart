import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NetWorkLogItemTitle extends StatelessWidget {
  final String title;
  final bool showText;
  final ValueChanged onShowTextChanged;
  final _titleMap = {true: Text("文本"), false: Text("json")};

  NetWorkLogItemTitle(
      {Key key,
      @required this.title,
      @required this.showText,
      @required this.onShowTextChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: Colors.blueAccent)),
        SizedBox(width: 8),
        CupertinoSlidingSegmentedControl<bool>(
          groupValue: showText,
          children: _titleMap,
          onValueChanged: onShowTextChanged,
        )
      ],
    );
  }
}
