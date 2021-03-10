import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/module/db/db.dart';

import 'home.dart';
import 'module.dart';
import 'module/device/device.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppProvider(),
    lazy: false,
    child: Webdebugger(),
  ));
}

final List<Module> moduleList = [
  Module('设备信息', Icons.perm_device_info, Device()),
  Module('界面', Icons.account_tree, SelectableText('界面')),
  Module('控制台', Icons.pest_control, SelectableText('控制台')),
  Module('网络日志', Icons.network_check, SelectableText('网络日志')),
  Module('截屏/录屏', Icons.add_a_photo, SelectableText('截屏/录屏')),
  Module('数据库', Icons.admin_panel_settings, DB()),
  Module('切换环境', Icons.account_balance, SelectableText('切换环境')),
  Module('日志', Icons.assignment, SelectableText('日志')),
  Module('API列表', Icons.list_alt, SelectableText('API列表')),
  Module('安装APK', Icons.adb, SelectableText('安装APK')),
];

class Webdebugger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebDebugger',
      home: ChangeNotifierProvider(
        create: (_) => HomeProvider(moduleList.first),
        child: Home(),
      ),
    );
  }
}
