import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github-gist.dart';

class CodeEditor extends StatefulWidget {
  TextEditingController textEditingController;
  ValueChanged<String> onChange;

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
