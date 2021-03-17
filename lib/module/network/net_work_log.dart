import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:webdebugger_web_flutter/common/min_width_scroll.dart';
import 'package:webdebugger_web_flutter/common/provider/net_provider.dart';

import 'net_work_log_item.dart';

Widget buildNetWorkRowBackground(BuildContext context, Widget child) {
  var borderSide = BorderSide(color: Theme.of(context).dividerColor);
  return Container(
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration:
        BoxDecoration(border: Border(right: borderSide, bottom: borderSide)),
    child: Align(child: child, alignment: Alignment.centerLeft),
  );
}

/// “网络日志”模块
class NetWorkLog extends StatefulWidget {
  @override
  _NetWorkLogState createState() => _NetWorkLogState();
}

class _NetWorkLogState extends State<NetWorkLog> {
  /// 竖向滚动条控制器
  ScrollController _scrollController = ScrollController();

  /// 横向滚动条控制器
  ScrollController _horizontalScrollController = ScrollController();
  final minWidth = 1500.0;

  @override
  Widget build(BuildContext context) {
    var netWorkProvider = context.watch<NetWorkProvider>();
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor)),
          // 想手动设置一个最小宽度，但是限制会继承父widget
          // 所以通过LayoutBuilder获取现在的最大宽度，然后在通过UnconstrainedBox取消限制，在手动设置最小宽度
          child: MinWidthScroller(
            minWidth: minWidth,
            scrollController: _horizontalScrollController,
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey.withAlpha(80)),
                  child: Row(
                    children: [
                      buildNetWorkRowBackground(
                          context,
                          Icon(Icons.chevron_right,
                              color: Colors.transparent, size: 40)),
                      Expanded(
                          child: buildNetWorkRowBackground(
                              context, SelectableText("请求方式")),
                          flex: 2),
                      Expanded(
                          child: buildNetWorkRowBackground(
                              context, SelectableText("请求时间")),
                          flex: 5),
                      Expanded(
                          child: buildNetWorkRowBackground(
                              context, SelectableText("请求地址")),
                          flex: 30)
                    ],
                  ),
                ),
                Expanded(
                    child: Scrollbar(
                        controller: _scrollController,
                        isAlwaysShown: true,
                        child: ListView(
                          controller: _scrollController,
                          children: netWorkProvider.netWorkList
                              .map((e) => NetWorkLogItem(
                                    key: ObjectKey(e),
                                    netWork: e,
                                  ))
                              .toList(),
                        )))
              ],
            ),
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              child: Text("清空"),
              onPressed: netWorkProvider.clearNetWorkLog,
            ),
          ),
          alignment: Alignment.bottomRight,
        )
      ],
    );
  }
}
