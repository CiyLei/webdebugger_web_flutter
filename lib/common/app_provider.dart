import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/model/fps_info.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

class AppProvider with ChangeNotifier {
  BaseResponse<DeviceInfo> deviceInfo;
  WebSocket deviceWebSocket;
  Map<int, FpsInfo> fpsMap = LinkedHashMap();
  WebSocket monitorWebSocket;
  String selectViewId = "";

  var codeImport = '''
import android.widget.Toast;
import java.util.Random;
''';
  var code = '''
int i = 0;
while(i < 10) {
    System.out.println(new Random().nextInt());
    i++;
}
Toast.makeText(getContext(), "测试吐司", Toast.LENGTH_SHORT).show();
  ''';

  var result = "";

  var isRunMainThread = true;

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
      _initDeviceWebSocket(webSocketPort);
      _initMonitorWebSocket(webSocketPort);
    }
  }

  void _initDeviceWebSocket(int webSocketPort) {
    deviceWebSocket =
        WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/device");
    deviceWebSocket.onMessage.listen((event) {
      FpsInfo fpsInfo = FpsInfo.fromJson(json.decode(event.data.toString()));
      if (fpsInfo.fps <= 0) return;
      fpsMap[DateTime.now().millisecondsSinceEpoch] = fpsInfo;
      if (fpsMap.length > 10) {
        fpsMap.remove(fpsMap.keys.first);
      }
      notifyListeners();
    });
    deviceWebSocket.onClose.listen((event) {
      _initDeviceWebSocket(webSocketPort);
    });
  }

  void _initMonitorWebSocket(int webSocketPort) {
    monitorWebSocket =
        WebSocket(ApiStore.webSocketUrl(webSocketPort) + "/view/monitor");
    monitorWebSocket.onMessage.listen((event) {
      selectViewId = event.data.toString();
      notifyListeners();
    });
    monitorWebSocket.onClose.listen((event) {
      _initMonitorWebSocket(webSocketPort);
    });
  }
}
