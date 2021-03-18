import 'package:flutter/widgets.dart';

/// “api列表”模块的状态存储
class ApiListProvider with ChangeNotifier {

  /// 最小宽度
  final minWidth = 1000.0;

  /// 是否查看详细返回结构
  bool isDetailedReturn = false;
}
