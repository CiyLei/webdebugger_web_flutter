import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// “日志”模块的状态存储
class LogcatProvider with ChangeNotifier {
  /// 设备信息
  ///
  /// 里面还存储了数据库页面的端口和WebSocket的端口
  DeviceInfo deviceInfo;

  /// “日志”模块的日志是否滚动置底
  bool _isAlwaysScrollToEnd = true;

  bool get isAlwaysScrollToEnd => _isAlwaysScrollToEnd;

  set isAlwaysScrollToEnd(bool value) {
    if (value) {
      _scrollToEnd();
    }
    _isAlwaysScrollToEnd = value;
  }

  /// “日志”模块的实时接收日志的WebSocket
  WebSocket logcatWebSocket;

  /// 日志
  String logcat = "";

  // 滚动控制
  final ScrollController scrollController = ScrollController();

  LogcatProvider(this.deviceInfo) {
    _initLogcatWebSocket(deviceInfo.port);
  }

  /// 初始化“日志”模块中接收日志的WebSocket
  void _initLogcatWebSocket(int webSocketPort) {
    if (logcatWebSocket != null) {
      logcatWebSocket.close();
    }
    logcatWebSocket =
        WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/logcat");
    logcatWebSocket.onMessage.listen((event) {
      logcat += "${event.data.toString()}\n";
      notifyListeners();
      if (_isAlwaysScrollToEnd) {
        _scrollToEnd(duration: Duration(milliseconds: 100));
      }
    });
    // 如果断开了，直接尝试重连
    logcatWebSocket.onClose.listen((event) {
      _initLogcatWebSocket(webSocketPort);
    });
  }

  /// 清空日志
  void clear() {
    logcat = "";
    notifyListeners();
  }

  /// 滚到到底部（可延迟）
  _scrollToEnd({Duration duration}) async {
    if (duration == null) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else {
      await Future.delayed(duration);
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }
}
