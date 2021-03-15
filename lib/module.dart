import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 模块抽象的模型
class Module {
  /// 模块的标题
  final String title;

  /// 模块的图标
  final IconData iconData;

  /// 模块的widget
  final Widget child;

  Module(this.title, this.iconData, this.child);
}
