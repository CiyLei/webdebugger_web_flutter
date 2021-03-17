import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/flashing_point.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/model/media_info.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// “截屏录屏”模块的状态存储
class MediaProvider with ChangeNotifier {
  /// 设备信息
  ///
  /// 里面还存储了数据库页面的端口和WebSocket的端口
  DeviceInfo deviceInfo;

  /// 录屏控制器
  FlashingPointController flashingPointController =
      FlashingPointController(duration: Duration(milliseconds: 500));

  /// “截屏/录屏”模块中的实时接收媒体信息的WebSocket
  WebSocket mediaWebSocket;

  /// 媒体地址的端口
  int mediaPort;

  /// 媒体列表
  Set<String> mediaPathList = LinkedHashSet();

  MediaProvider(this.deviceInfo) {
    _initMediaWebSocket(deviceInfo.port);
  }

  /// 初始化“截屏录屏”模块中接收媒体信息的WebSocket
  void _initMediaWebSocket(int webSocketPort) {
    if (mediaWebSocket != null) {
      mediaWebSocket.close();
    }
    mediaWebSocket =
        WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/media/add");
    mediaWebSocket.onMessage.listen((event) {
      var mediaInfo = MediaInfo.fromJson(json.decode(event.data.toString()));
      mediaPort = mediaInfo.port;
      mediaPathList.addAll(mediaInfo.list);
      notifyListeners();
    });
    // 如果断开了，直接尝试重连
    mediaWebSocket.onClose.listen((event) {
      _initMediaWebSocket(webSocketPort);
    });
  }

  /// 重置媒体列表
  void resetMediaList(MediaInfo mediaInfo) {
    mediaPort = mediaInfo.port;
    mediaPathList.clear();
    mediaPathList.addAll(mediaInfo.list);
    notifyListeners();
  }

  /// 清空媒体列表
  void clearMediaList() {
    mediaPathList.clear();
    notifyListeners();
  }
}
