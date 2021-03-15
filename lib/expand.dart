import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'main.dart';
import 'module.dart';

/// 模块列表的扩展widget
class Expand extends StatelessWidget {
  /// 是否处于展开状态
  final isExpand;

  /// 当前选中的模块
  final Module selectModule;

  /// 模块切换的回调
  final ValueChanged<Module> onSelectModule;

  Expand(
      {Key key,
      @required this.selectModule,
      this.isExpand = false,
      @required this.onSelectModule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 展开、收缩的动画时间
    const duration = Duration(milliseconds: 250);
    return AnimatedContainer(
      duration: duration,
      // 展开、收缩的宽度变化
      width: isExpand ? 250 : 60,
      child: ListView(
        children: moduleList
            .map((e) => ListTile(
                  // 模块的图标和提示文字
                  leading: Tooltip(
                    message: e.title,
                    child: Icon(e.iconData),
                  ),
                  // 控制模块是否展示文字
                  title: AnimatedCrossFade(
                    firstChild: Text(
                      e.title,
                      maxLines: 1,
                    ),
                    secondChild: Container(),
                    duration: duration,
                    crossFadeState: isExpand
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                  selected: e == selectModule,
                  onTap: () {
                    onSelectModule(e);
                  },
                ))
            .toList(),
      ),
    );
  }
}
