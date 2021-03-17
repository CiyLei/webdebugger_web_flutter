import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/common/selected.dart';
import 'package:provider/provider.dart';

class LogCat extends StatefulWidget {
  @override
  _LogCatState createState() => _LogCatState();
}

class _LogCatState extends State<LogCat> {
  @override
  Widget build(BuildContext context) {
    var appProvider = context.read<AppProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ElevatedButton(onPressed: () {}, child: Text("清空")),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: SelectedButton(
                child: Text("置底"),
                selectedCallback: (value) {
                  setState(() {
                    appProvider.isAlwaysScrollToEnd =
                        !appProvider.isAlwaysScrollToEnd;
                  });
                },
                selected: appProvider.isAlwaysScrollToEnd),
          ),
        ]),
        Expanded(child: LogCatView())
      ],
    );
  }
}

class LogCatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          children: [SelectableText(context.watch<AppProvider>().logcat)],
        ));
  }
}
