import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github-gist.dart';

/// 代码编辑器的原理是在HighlightView上面套上一个透明的编辑器，改变内容时实时渲染
///
/// HighlightView：一个支持高亮的文本框
class CodeEditor extends StatefulWidget {
  /// 编辑框控制器
  final TextEditingController textEditingController;

  /// 代表改变的回调
  final ValueChanged<String> onChange;

  CodeEditor({Key key, this.textEditingController, this.onChange})
      : super(key: key);

  @override
  _CodeEditorState createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  var codeTheme = githubGistTheme.map((key, value) => MapEntry(
      key,
      value.copyWith(
          fontWeight: FontWeight.normal, fontStyle: FontStyle.normal)));

  @override
  void initState() {
    // 将背景色改为透明
    codeTheme['root'] =
        codeTheme['root'].copyWith(backgroundColor: Colors.transparent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          children: [
            Stack(
              children: [
                HighlightView(widget.textEditingController.text,
                    language: 'java',
                    theme: codeTheme,
                    padding: EdgeInsets.all(0),
                    textStyle: TextStyle(fontSize: 16)),
                TextField(
                  controller: widget.textEditingController,
                  onChanged: widget.onChange,
                  style: TextStyle(fontSize: 16, color: Colors.transparent),
                  decoration: null,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )
              ],
            )
          ],
        ));
  }
}
