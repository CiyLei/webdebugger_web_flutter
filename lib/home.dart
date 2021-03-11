import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'expand.dart';
import 'module.dart';

class HomeProvider with ChangeNotifier {
  Module currentModule;
  bool isExpand;

  HomeProvider(this.currentModule, {this.isExpand = true});

  /// 选择模块
  void selectModule(Module module) {
    currentModule = module;
    notifyListeners();
  }

  /// 切换扩展
  void toggleExpand() {
    isExpand = !isExpand;
    notifyListeners();
  }
}

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
          icon: Icon(context.watch<HomeProvider>().isExpand
              ? Icons.wb_incandescent_sharp
              : Icons.wb_incandescent_outlined),
          onPressed: () => context.read<HomeProvider>().toggleExpand(),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expand(
            selectModule: context.watch<HomeProvider>().currentModule,
            isExpand: context.watch<HomeProvider>().isExpand,
            onSelectModule: (module) =>
                context.read<HomeProvider>().selectModule(module),
          ),
          Container(
            width: 1,
            height: double.maxFinite,
            color: Theme.of(context).dividerColor,
          ),
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
