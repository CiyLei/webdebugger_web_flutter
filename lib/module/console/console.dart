import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/module/console/code_editor.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

class Console extends StatefulWidget {
  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  TextEditingController _importController;
  TextEditingController _codeController;

  // @override
  // void initState() {
  //   _importController = TextEditingController(text: _codeImport);
  //   _codeController = TextEditingController(text: _code);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var appProvider = context.read<AppProvider>();
    if (_importController == null) {
      _importController = TextEditingController(text: appProvider.codeImport);
      _codeController = TextEditingController(text: appProvider.code);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: _buildEditorItem(
                        context,
                        Text("import"),
                        CodeEditor(
                          textEditingController: _importController,
                          onChange: (value) {
                            setState(() {
                              appProvider.codeImport = value;
                            });
                          },
                        ))),
                Expanded(
                    flex: 6,
                    child: _buildEditorItem(
                        context,
                        Text("code"),
                        CodeEditor(
                          textEditingController: _codeController,
                          onChange: (value) {
                            setState(() {
                              appProvider.code = value;
                            });
                          },
                        )))
              ],
            )),
            Expanded(
                child: _buildEditorItem(
                    context,
                    Text("运行结果"),
                    ListView(
                      children: [
                        SelectableText(context.watch<AppProvider>().result)
                      ],
                    )))
          ],
        )),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  execute(appProvider);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Text("运行"),
                )),
            Checkbox(
                value: appProvider.isRunMainThread,
                onChanged: (value) {
                  setState(() {
                    appProvider.isRunMainThread = value;
                  });
                }),
            Text("运行在主线程")
          ],
        )
      ],
    );
  }

  Widget _buildEditorItem(BuildContext context, Widget title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor)),
          child: child,
        ))
      ],
    );
  }

  execute(AppProvider appProvider) async {
    var response = await ApiStore.instance.execute(
        appProvider.code, appProvider.codeImport, appProvider.isRunMainThread);
    setState(() {
      appProvider.result = response.data;
    });
  }
}