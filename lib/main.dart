import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webdebugger_web_flutter/common/provider/api_list_provider.dart';
import 'package:webdebugger_web_flutter/common/provider/device_provider.dart';
import 'package:webdebugger_web_flutter/common/provider/logcat_provider.dart';
import 'package:webdebugger_web_flutter/common/provider/media_provider.dart';
import 'package:webdebugger_web_flutter/common/provider/view_provider.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/module/console/console.dart';
import 'package:webdebugger_web_flutter/module/db/db.dart';
import 'package:webdebugger_web_flutter/module/network/net_work_log.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

import 'common/provider/console_provider.dart';
import 'common/provider/net_provider.dart';
import 'home.dart';
import 'module.dart';
import 'module/api/api_view.dart';
import 'module/device/device.dart';
import 'module/env/environment.dart';
import 'module/install/install.dart';
import 'module/view/interface.dart';
import 'module/logcat/log_cat.dart';
import 'module/media/media.dart';

void main() {
  runApp(Webdebugger());
}

/// 模块信息
final List<Module> moduleList = [
  Module('设备信息', Icons.perm_device_info, Device()),
  Module('界面', Icons.account_tree, Interface()),
  Module('控制台', Icons.pest_control, Console()),
  Module('网络日志', Icons.network_check, NetWorkLog()),
  Module('截屏/录屏', Icons.add_a_photo, Media()),
  Module('数据库', Icons.admin_panel_settings, DB()),
  Module('切换环境', Icons.account_balance, Environment()),
  Module('日志', Icons.assignment, LogCat()),
  Module('API列表', Icons.list_alt, ApiView()),
  Module('安装APK', Icons.adb, Install()),
];

class Webdebugger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebDebugger',
      home: DefaultTextStyle(
        style: TextStyle(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 判断设备宽度，决定默认是否展开模块列表
            return ChangeNotifierProvider(
              create: (_) => HomeProvider(moduleList.first,
                  isExpand: constraints.maxWidth > 600),
              child: RequestApi(
                  apiFunction: ApiStore.instance.getDeviceInfo,
                  dataWidgetBuilder: (context, response) =>
                      MultiProvider(providers: [
                        // 设备模块的状态存储
                        ChangeNotifierProvider(
                            create: (_) => DeviceProvider(response.data)),
                        // 界面模块的状态存储
                        ChangeNotifierProvider(
                            create: (_) => ViewProvider(response.data)),
                        // 控制台模块的状态存储
                        ChangeNotifierProvider(
                            create: (_) => ConsoleProvider()),
                        // 网络日志模块的状态存储
                        ChangeNotifierProvider(
                            create: (_) => NetWorkProvider(response.data)),
                        // 截屏录屏模块的状态存储
                        ChangeNotifierProvider(
                            create: (_) => MediaProvider(response.data)),
                        // 日志模块的状态存储
                        ChangeNotifierProvider(
                            create: (_) => LogcatProvider(response.data)),
                        // Api列表模块的状态存储
                        ChangeNotifierProvider(
                            create: (_) => ApiListProvider()),
                      ], child: Home())),
            );
          },
        ),
      ),
    );
  }
}
