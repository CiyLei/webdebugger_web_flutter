import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/idea.dart';

/// 代码编辑器的原理是在HighlightView上面套上一个透明的编辑器，改变内容时实时渲染
///
/// HighlightView：一个支持高亮的文本框
class CodeEditor extends StatelessWidget {
  /// 编辑框控制器
  final TextEditingController textEditingController;

  /// 代表改变的回调
  final ValueChanged<String> onChange;

  /// 是否高亮语法
  final isHighlight;

  /// 高亮语法主题
  var codeTheme = ideaTheme.map((key, value) => MapEntry(
      key,
      value.copyWith(
          fontWeight: FontWeight.normal, fontStyle: FontStyle.normal)));

  CodeEditor(
      {Key key,
      this.textEditingController,
      this.onChange,
      this.isHighlight = false})
      : super(key: key) {
    // 将背景色改为透明
    codeTheme['root'] =
        codeTheme['root'].copyWith(backgroundColor: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          children: [
            Stack(
              children: [
                isHighlight
                    ? HighlightView(textEditingController.text,
                        language: 'java',
                        theme: codeTheme,
                        padding: EdgeInsets.all(0),
                        textStyle: TextStyle(fontSize: 16))
                    : SizedBox(),
                TextField(
                  controller: textEditingController,
                  onChanged: onChange,
                  style: isHighlight
                      ? TextStyle(fontSize: 16, color: Colors.transparent)
                      : TextStyle(fontSize: 16),
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
