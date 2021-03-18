import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:webdebugger_web_flutter/net/api_store.dart';

class Install extends StatelessWidget {
  /// 上传文件的元素
  final FileUploadInputElement _fileUploadInputElement =
      FileUploadInputElement();

  /// 输入url的编辑框
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        'FileUploadInputElement',
        (int viewId) => _fileUploadInputElement
          ..accept = '.apk'
          ..addEventListener('change', (event) {
            if (_fileUploadInputElement.files.length > 0) {
              var apkFile = _fileUploadInputElement.files.last;
              ApiStore.instance.installFromUpload(apkFile);
            }
          }));
    return Column(
      children: [
        SizedBox(height: 16),
        SizedBox(
            width: 500,
            height: 300,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 75,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text("点击文件上传"),
                      SizedBox(height: 8),
                      Text("（上传中会卡顿，待优化）")
                    ],
                  ),
                ),
                Opacity(
                  opacity: 0.01,
                  child: HtmlElementView(viewType: 'FileUploadInputElement'),
                ),
              ],
            )),
        SizedBox(height: 30),
        Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: TextField(
            decoration: InputDecoration(
                labelText: "通过URL安装APK",
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(4))),
            keyboardType: TextInputType.url,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                ApiStore.instance.installFromUrl(value);
                _textEditingController.clear();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("推送成功，请在app中查看下载")));
              }
            },
            controller: _textEditingController,
          ),
        ),
      ],
    );
  }
}
