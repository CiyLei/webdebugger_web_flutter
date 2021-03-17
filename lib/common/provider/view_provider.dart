import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// “界面”模块的状态存储
class ViewProvider with ChangeNotifier {
  DeviceInfo deviceInfo;

  /// 在“界面”模块中，当开启手动触摸选择时，实时接收触摸的view的id
  WebSocket monitorWebSocket;

  /// 在“界面”模块中，当前选择的view的id
  String selectViewId = "";

  ViewProvider(this.deviceInfo) {
    _initMonitorWebSocket(deviceInfo.port);
  }

  /// 初始化“界面”模块的WebSocket，实时监听触摸选择了哪些view
  void _initMonitorWebSocket(int webSocketPort) {
    if (monitorWebSocket != null) {
      monitorWebSocket.close();
    }
    monitorWebSocket =
        WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/view/monitor");
    monitorWebSocket.onMessage.listen((event) {
      // 只会传过来一个view的id
      selectViewId = event.data.toString();
      notifyListeners();
    });
    // 如果断开了，直接尝试重连
    monitorWebSocket.onClose.listen((event) {
      _initMonitorWebSocket(webSocketPort);
    });
  }
}
