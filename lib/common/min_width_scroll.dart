import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 限制最小宽度的滚动条
class MinWidthScroller extends StatelessWidget {
  final double minWidth;
  final ScrollController scrollController;
  final Widget child;

  MinWidthScroller(
      {Key key,
      @required this.minWidth,
      @required this.scrollController,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Scrollbar(
          isAlwaysShown: true,
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: UnconstrainedBox(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: max(constraints.maxWidth, minWidth),
                    minWidth: min(constraints.maxWidth, minWidth),
                    maxHeight: constraints.maxHeight,
                    minHeight: constraints.minHeight),
                child: child,
              ),
            ),
          ));
    });
  }
}
