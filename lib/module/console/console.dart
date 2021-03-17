import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/provider/console_provider.dart';
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
    var consoleProvider = context.read<ConsoleProvider>();
    if (_importController == null) {
      _importController =
          TextEditingController(text: consoleProvider.codeImport);
      _codeController = TextEditingController(text: consoleProvider.code);
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
                          isHighlight: consoleProvider.isHighlight,
                          textEditingController: _importController,
                          onChange: (value) {
                            setState(() {
                              consoleProvider.codeImport = value;
                            });
                          },
                        ))),
                Expanded(
                    flex: 6,
                    child: _buildEditorItemWidget(
                        context,
                        Text("code"),
                        CodeEditor(
                          isHighlight: consoleProvider.isHighlight,
                          textEditingController: _codeController,
                          onChange: (value) {
                            setState(() {
                              consoleProvider.code = value;
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
                        SelectableText(context.watch<ConsoleProvider>().result)
                      ],
                    )))
          ],
        )),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  _executeCode(consoleProvider);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Text("运行"),
                )),
            Checkbox(
                value: consoleProvider.isRunMainThread,
                onChanged: (value) {
                  setState(() {
                    consoleProvider.isRunMainThread = value;
                  });
                }),
            Text("运行在主线程"),
            SizedBox(
              width: 8,
            ),
            Checkbox(
                value: consoleProvider.isHighlight,
                onChanged: (value) {
                  setState(() {
                    consoleProvider.isHighlight = value;
                  });
                }),
            Text("高亮语法（实验）"),
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
  _executeCode(ConsoleProvider consoleProvider) async {
    var response = await ApiStore.instance.execute(consoleProvider.code,
        consoleProvider.codeImport, consoleProvider.isRunMainThread);
    setState(() {
      consoleProvider.result = response.data;
    });
  }
}
