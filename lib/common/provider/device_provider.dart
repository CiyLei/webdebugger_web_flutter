import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/model/fps_info.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// “设备”模块的状态存储
class DeviceProvider with ChangeNotifier {
  /// 设备信息
  /// 
  /// 里面还存储了数据库页面的端口和WebSocket的端口
  DeviceInfo deviceInfo;

  /// 接收fps和内存信息的WebSocket
  WebSocket deviceWebSocket;

  /// 存储fps和内存信息的Map，只保存一定的数量
  ///
  /// key：当前时间戳，value：信息
  Map<int, FpsInfo> fpsMap = LinkedHashMap();

  DeviceProvider(this.deviceInfo) {
    _initDeviceWebSocket(deviceInfo.port);
  }

  /// 初始化“设备信息”模块的WebSocket，实时接收fps和内存信息
  void _initDeviceWebSocket(int webSocketPort) {
    if (deviceWebSocket != null) {
      deviceWebSocket.close();
    }
    deviceWebSocket =
        WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/device");
    deviceWebSocket.onMessage.listen((event) {
      FpsInfo fpsInfo = FpsInfo.fromJson(json.decode(event.data.toString()));
      // 第一次返回的数据有点问题，直接抛弃
      if (fpsInfo.fps <= 0) return;
      fpsMap[DateTime.now().millisecondsSinceEpoch] = fpsInfo;
      // 只保存一定的数量
      if (fpsMap.length > 10) {
        fpsMap.remove(fpsMap.keys.first);
      }
      notifyListeners();
    });
    // 如果断开了，直接尝试重连
    deviceWebSocket.onClose.listen((event) {
      _initDeviceWebSocket(webSocketPort);
    });
  }
}
