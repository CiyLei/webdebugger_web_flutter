import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/children.dart';

// 展示节点列表的widget
class ViewTree extends StatefulWidget {
  /// 所有的节点列表
  final List<Children> childrenList;

  /// 选中节点的回调
  final ValueChanged<Children> onSelectedCallback;

  /// 选中的节点
  final Children selectChildren;

  ViewTree(
      {Key key,
      this.childrenList,
      this.onSelectedCallback,
      this.selectChildren})
      : super(key: key);

  @override
  _ViewTreeState createState() => _ViewTreeState();
}

class _ViewTreeState extends State<ViewTree> {
  /// 滚动的控制器
  final ScrollController _scrollController = ScrollController();

  /// 记录节点列表中最大的宽度的widget，让widget宽度小于item的宽度时，不会变形
  double _maxWidth = 0.0;

  /// 节点文字的样式
  final TextStyle _textStyle = TextStyle(fontSize: 14);

  /// 计算节点列表widget的最大宽度
  double calcMaxChildrenWidth(BuildContext context) {
    var maxWidth = 0.0;
    // 遍历节点，计算最大宽度
    for (var value in widget.childrenList) {
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
    // 只计算一遍
    if (_maxWidth == 0) {
      _maxWidth = calcMaxChildrenWidth(context);
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
              width: max(constraints.maxWidth, _maxWidth),
              child: ListView(
                children: widget.childrenList
                    // 同一级的节点在一个ListView中的一个Item去渲染，其子节点用Column去渲染
                    .map((e) => ViewTreeItem(
                          // 节点的宽度
                          constraintsWidth: constraints.maxWidth,
                          // 节点的文字样式
                          textStyle: _textStyle,
                          // 节点的等级（父节点的等级+1，控制左边的padding）
                          level: 0,
                          // 节点
                          children: e,
                          // 选中的节点
                          selectChildren: widget.selectChildren,
                          // 选中节点的回调
                          onSelectedCallback: widget.onSelectedCallback,
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

/// 展示节点的widget
class ViewTreeItem extends StatefulWidget {
  /// 当前节点
  final Children children;

  // 节点的等级（父节点的等级+1，控制左边的padding）
  final int level;

  // 节点的文字样式
  final TextStyle textStyle;

  // 节点的宽度
  final double constraintsWidth;

  // 选中的节点
  final Children selectChildren;

  // 选中节点的回调
  final ValueChanged<Children> onSelectedCallback;

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
    // 当前渲染的节点是否是选中的节点
    var selected = widget.children == widget.selectChildren;
    return GestureDetector(
      onTap: () {
        // 选中节点的回调
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
        // 子节点收缩动画
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
