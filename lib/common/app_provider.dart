import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/model/fps_info.dart';
import 'package:webdebugger_web_flutter/model/net_work.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// 全局的状态存储处
class AppProvider with ChangeNotifier {
  /// 设备信息，应用进入首先会获取此信息
  ///
  /// 里面还存储了数据库页面的端口和WebSocket的端口
  BaseResponse<DeviceInfo> deviceInfo;

  /// 接收fps和内存信息的WebSocket
  WebSocket deviceWebSocket;

  /// 存储fps和内存信息的Map，只保存一定的数量
  ///
  /// key：当前时间戳，value：信息
  Map<int, FpsInfo> fpsMap = LinkedHashMap();

  /// 在“界面”模块中，当开启手动触摸选择时，实时接收触摸的view的id
  WebSocket monitorWebSocket;

  /// 在“界面”模块中，当前选择的view的id
  String selectViewId = "";

  /// “控制台”模块，默认的导入代码
  var codeImport = '''
import android.widget.Toast;
import java.util.Random;
''';

  /// “控制台”模块，默认的执行代码
  var code = '''
int i = 0;
while(i < 10) {
    System.out.println(new Random().nextInt());
    i++;
}
Toast.makeText(getContext(), "测试吐司", Toast.LENGTH_SHORT).show();
  ''';

  /// “控制台”模块，默认的返回结果
  var result = "";

  /// “控制台”模块，控制代码是否运行在主线程中
  var isRunMainThread = true;

  /// “网络日志”模块中的实时接收网络请求的WebSocket
  WebSocket netWorkLogWebSocket;

  /// 网络请求列表
  List<NetWork> netWorkList = [];

  /// 获取设备信息
  Future<BaseResponse<DeviceInfo>> getDeviceInfo() async {
    if (deviceInfo != null && deviceInfo.success) {
      return deviceInfo;
    } else {
      deviceInfo = await ApiStore.instance.getDeviceInfo();
      // 获取完设备信息，里面有WebSocket的端口，所以初始化WebSocket
      _initWebSocket();
      notifyListeners();
      return deviceInfo;
    }
  }

  /// 初始化WebSocket
  _initWebSocket() {
    if (deviceInfo != null && deviceInfo.success) {
      var webSocketPort = deviceInfo.data.port;
      _initDeviceWebSocket(webSocketPort);
      _initMonitorWebSocket(webSocketPort);
      _initNetWorkLogWebSocket(webSocketPort);
    }
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
