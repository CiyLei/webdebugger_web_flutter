import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 选中按钮的widget
class SelectedButton extends StatelessWidget {
  final Widget child;

  /// 是否选中
  final bool selected;

  /// 选中改变的回调
  final ValueChanged<bool> selectedCallback;

  SelectedButton(
      {Key key,
      @required this.child,
      @required this.selectedCallback,
      @required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selected
        ? ElevatedButton(
            onPressed: () {
              this.selectedCallback(false);
            },
            child: this.child,
          )
        : OutlinedButton(
            child: this.child,
            onPressed: () {
              this.selectedCallback(true);
            },
          );
  }
}
