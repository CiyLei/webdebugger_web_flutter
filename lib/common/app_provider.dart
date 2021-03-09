import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

class AppProvider with ChangeNotifier {
  BaseResponse<DeviceInfo> deviceInfo;
  WebSocket deviceWebSocket;

  /// 获取设备信息
  Future<BaseResponse<DeviceInfo>> getDeviceInfo() async {
    if (deviceInfo != null && deviceInfo.success) {
      return deviceInfo;
    } else {
      deviceInfo = await ApiStore.instance.getDeviceInfo();
      _initWebSocket();
      notifyListeners();
      return deviceInfo;
    }
  }

  _initWebSocket() {
    if (deviceInfo != null && deviceInfo.success && deviceWebSocket == null) {
      var webSocketPort = deviceInfo.data.port;
      deviceWebSocket =
          WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/device");
    }
  }
}
