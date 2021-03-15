import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expand.dart';
import 'module.dart';

/// 脚手架框架的状态存储处
class HomeProvider with ChangeNotifier {
  /// 当前选中的模块
  Module currentModule;

  /// 是否展开模块列表
  bool isExpand;

  HomeProvider(this.currentModule, {this.isExpand = true});

  /// 选择模块
  void selectModule(Module module) {
    currentModule = module;
    notifyListeners();
  }

  /// 切换展开、收缩模块列表
  void toggleExpand() {
    isExpand = !isExpand;
    notifyListeners();
  }
}

/// 整个模块列表脚手架的搭建
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebDebugger"),
        leading: IconButton(
          // 用一个图标展示和控制模块列表的展开
          icon: Icon(context.watch<HomeProvider>().isExpand
              ? Icons.wb_incandescent_sharp
              : Icons.wb_incandescent_outlined),
          onPressed: () => context.read<HomeProvider>().toggleExpand(),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 模块列表
          Expand(
            selectModule: context.watch<HomeProvider>().currentModule,
            isExpand: context.watch<HomeProvider>().isExpand,
            onSelectModule: (module) =>
                context.read<HomeProvider>().selectModule(module),
          ),
          // 分割线
          Container(
            width: 1,
            height: double.maxFinite,
            color: Theme.of(context).dividerColor,
          ),
          // 展示模块详情
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(8),
            child: context.read<HomeProvider>().currentModule.child,
          ))
        ],
      ),
    );
  }
}
