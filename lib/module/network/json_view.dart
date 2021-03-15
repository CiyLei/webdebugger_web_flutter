import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

/// json格式化输出
class JsonView extends StatelessWidget {
  final bool showText;
  final dynamic content;
  final _codeTheme = githubTheme.map((key, value) => MapEntry(
      key,
      value.copyWith(
          fontWeight: FontWeight.normal, fontStyle: FontStyle.normal)));

  /// json格式化输出
  final JsonEncoder _jsonEncoder = JsonEncoder.withIndent('    ');

  JsonView({Key key, @required this.content, @required this.showText})
      : super(key: key) {
    // 将背景色改为透明
    _codeTheme['root'] =
        _codeTheme['root'].copyWith(backgroundColor: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return showText
        ? SelectableText(_textFormat(content))
        : HighlightView(_jsonFormat(content),
            language: 'json', theme: _codeTheme);
  }

  /// 文本格式化输出
  String _textFormat(dynamic text) {
    try {
      if (text.runtimeType != String) {
        return _jsonEncoder.convert(text);
      }
    } catch (e) {}
    return text.toString();
  }

  /// json格式化输出
  String _jsonFormat(dynamic text) {
    try {
      if (text.runtimeType == String) {
        return _jsonEncoder.convert(json.decode(text));
      } else {
        return _jsonEncoder.convert(text);
      }
    } catch (e) {}
    return text.toString();
  }
}
