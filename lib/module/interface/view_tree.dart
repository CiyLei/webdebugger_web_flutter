import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/children.dart';

class ViewTree extends StatelessWidget {
  List<Children> childrenList = [];
  ScrollController _scrollController = ScrollController();
  double maxWidth = 0.0;
  final TextStyle _textStyle = TextStyle(fontSize: 14);
  ValueChanged<Children> onSelectedCallback;
  Children selectChildren;

  ViewTree(
      {Key key,
      this.childrenList,
      this.onSelectedCallback,
      this.selectChildren})
      : super(key: key);

  double calcMaxChildrenWidth(BuildContext context) {
    var maxWidth = 0.0;
    for (var value in childrenList) {
      var width = calcChildrenWidth(context, value, 0);
      maxWidth = width > maxWidth ? width : maxWidth;
    }
    return maxWidth;
  }

  /// 计算节点的文字宽度
  double calcChildrenWidth(BuildContext context, Children children, int level) {
    var textPainter = TextPainter(
        locale: Localizations.localeOf(context),
        maxLines: 1,
        textDirection: TextDirection.ltr,
        text: TextSpan(text: children.label, style: _textStyle));
    textPainter.layout();
    var maxWidth = textPainter.width + (16 * (level + 1)) + 100;
    if (children.children != null) {
      children.children.forEach((element) {
        var childWidth = calcChildrenWidth(context, element, level + 1);
        maxWidth = max(childWidth, maxWidth);
      });
    }
    return maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    if (maxWidth == 0) {
      maxWidth = calcMaxChildrenWidth(context);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              width: max(constraints.maxWidth, maxWidth),
              child: ListView(
                children: childrenList
                    .map((e) => ViewTreeItem(
                          constraintsWidth: constraints.maxWidth,
                          textStyle: _textStyle,
                          level: 0,
                          children: e,
                          selectChildren: this.selectChildren,
                          onSelectedCallback: this.onSelectedCallback,
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ViewTreeItem extends StatefulWidget {
  Children children;
  int level;
  TextStyle textStyle;
  double constraintsWidth;
  Children selectChildren;
  ValueChanged<Children> onSelectedCallback;

  ViewTreeItem(
      {Key key,
      @required this.level,
      @required this.constraintsWidth,
      this.textStyle,
      this.onSelectedCallback,
      this.selectChildren,
      this.children})
      : super(key: key);

  @override
  _ViewTreeItemState createState() => _ViewTreeItemState();
}

class _ViewTreeItemState extends State<ViewTreeItem> {
  @override
  Widget build(BuildContext context) {
    var selected = widget.children == widget.selectChildren;
    return GestureDetector(
      onTap: () {
        if (widget.onSelectedCallback != null) {
          widget.onSelectedCallback(widget.children);
        }
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          color: selected ? Colors.blueAccent : Colors.transparent,
          width: widget.constraintsWidth,
          padding: EdgeInsets.only(
              left: 16.0 * (widget.level + 1), bottom: 8, top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.children.expand = !widget.children.expand;
                  });
                },
                child: widget.children.children != null &&
                        widget.children.children.isNotEmpty
                    ? Icon(
                        widget.children.expand
                            ? Icons.arrow_drop_down
                            : Icons.arrow_right,
                        size: 18,
                        color: selected ? Colors.white : Colors.black,
                      )
                    : SizedBox(width: 18, height: 18),
              ),
              Text(
                widget.children.label,
                maxLines: 1,
                style: selected
                    ? widget.textStyle.copyWith(color: Colors.white)
                    : widget.textStyle,
              )
            ],
          ),
        ),
        AnimatedSwitcher(
          child: widget.children.expand
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.children.children
                          ?.map((e) => ViewTreeItem(
                                onSelectedCallback: widget.onSelectedCallback,
                                selectChildren: widget.selectChildren,
                                constraintsWidth: widget.constraintsWidth,
                                textStyle: widget.textStyle,
                                level: widget.level + 1,
                                children: e,
                              ))
                          ?.toList() ??
                      SizedBox(),
                )
              : SizedBox(),
          duration: Duration(milliseconds: 250),
        )
      ]),
    );
  }
}
