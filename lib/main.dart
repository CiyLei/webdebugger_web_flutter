import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/module/console/console.dart';
import 'package:webdebugger_web_flutter/module/db/db.dart';
import 'package:webdebugger_web_flutter/module/network/net_work_log.dart';

import 'home.dart';
import 'module.dart';
import 'module/device/device.dart';
import 'module/env/environment.dart';
import 'module/interface/interface.dart';
import 'module/media/media.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppProvider(),
    lazy: false,
    child: Webdebugger(),
  ));
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
  Module('日志', Icons.assignment, SelectableText('日志')),
  Module('API列表', Icons.list_alt, SelectableText('API列表')),
  Module('安装APK', Icons.adb, SelectableText('安装APK')),
];

class Webdebugger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebDebugger',
      home: LayoutBuilder(
        builder: (context, constraints) {
          // 判断设备宽度，决定默认是否展开模块列表
          return ChangeNotifierProvider(
            create: (_) => HomeProvider(moduleList.first,
                isExpand: constraints.maxWidth > 600),
            child: Home(),
          );
        },
      ),
    );
  }
}
