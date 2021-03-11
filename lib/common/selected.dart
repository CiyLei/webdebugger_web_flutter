import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Selected extends StatelessWidget {
  Widget child;
  bool selected = false;
  ValueChanged<bool> selectedCallback;

  Selected(
      {Key key,
      @required this.child,
      @required this.selectedCallback,
      this.selected})
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
