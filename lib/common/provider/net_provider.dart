import 'dart:convert';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/model/net_work.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// “网络日志”模块的状态存储
class NetWorkProvider with ChangeNotifier {
  /// 设备信息
  ///
  /// 里面还存储了数据库页面的端口和WebSocket的端口
  DeviceInfo deviceInfo;

  /// “网络日志”模块中的实时接收网络请求的WebSocket
  WebSocket netWorkLogWebSocket;

  /// 网络请求列表
  List<NetWork> netWorkList = [];

  NetWorkProvider(this.deviceInfo) {
    _initNetWorkLogWebSocket(deviceInfo.port);
  }

  /// 初始化“网络”模块中接收网络请求的WebSocket
  void _initNetWorkLogWebSocket(int webSocketPort) {
    if (netWorkLogWebSocket != null) {
      netWorkLogWebSocket.close();
    }
    netWorkLogWebSocket =
        WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/logcat/net");
    netWorkLogWebSocket.onMessage.listen((event) {
      netWorkList.insert(
          0, NetWork.fromJson(json.decode(event.data.toString())));
      notifyListeners();
    });
    // 如果断开了，直接尝试重连
    netWorkLogWebSocket.onClose.listen((event) {
      _initNetWorkLogWebSocket(webSocketPort);
    });
  }

  /// 清除网络日志
  void clearNetWorkLog() {
    netWorkList.clear();
    notifyListeners();
  }
}
