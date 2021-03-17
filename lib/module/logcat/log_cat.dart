import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/provider/logcat_provider.dart';
import 'package:webdebugger_web_flutter/common/selected.dart';
import 'package:provider/provider.dart';

/// “日志”模块
class LogCat extends StatefulWidget {
  @override
  _LogCatState createState() => _LogCatState();
}

class _LogCatState extends State<LogCat> {

  @override
  Widget build(BuildContext context) {
    var logcatProvider = context.read<LogcatProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ElevatedButton(
                onPressed: () {
                  logcatProvider.clear();
                },
                child: Text("清空")),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: SelectedButton(
                child: Text("置底"),
                selectedCallback: (value) {
                  setState(() {
                    logcatProvider.isAlwaysScrollToEnd =
                        !logcatProvider.isAlwaysScrollToEnd;
                  });
                },
                selected: logcatProvider.isAlwaysScrollToEnd),
          ),
        ]),
        Expanded(
            child: LogCatListView(
          scrollController: logcatProvider.scrollController,
        ))
      ],
    );
  }
}

/// 日志列表
class LogCatListView extends StatelessWidget {
  final ScrollController scrollController;

  LogCatListView({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: ListView(
          controller: scrollController,
          children: [SelectableText(context.watch<LogcatProvider>().logcat)],
        ));
  }
}
