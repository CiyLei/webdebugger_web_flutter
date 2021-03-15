import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/module/console/code_editor.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// “控制台”模块
class Console extends StatefulWidget {
  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  /// 导入代码的编辑控制器
  TextEditingController _importController;

  /// 执行代码的编辑控制器
  TextEditingController _codeController;

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
                    child: _buildEditorItemWidget(
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
                    child: _buildEditorItemWidget(
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
                child: _buildEditorItemWidget(
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
                  _executeCode(appProvider);
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

  /// 编辑框的背景widget
  Widget _buildEditorItemWidget(
      BuildContext context, Widget title, Widget child) {
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

  /// 执行代码
  _executeCode(AppProvider appProvider) async {
    var response = await ApiStore.instance.execute(
        appProvider.code, appProvider.codeImport, appProvider.isRunMainThread);
    setState(() {
      appProvider.result = response.data;
    });
  }
}
