import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/provider/api_list_provider.dart';
import 'package:webdebugger_web_flutter/model/api_info.dart';
import 'package:webdebugger_web_flutter/module/network/net_work_log.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// api列表项
class ApiListItem extends StatefulWidget {
  final ApiInfo apiInfo;

  ApiListItem(this.apiInfo);

  @override
  _ApiListItemState createState() => _ApiListItemState();
}

class _ApiListItemState extends State<ApiListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 简约的请求信息
        SimpleApiItem(
          isExpand: widget.apiInfo.isExpand,
          apiInfo: widget.apiInfo,
          onPressed: () {
            setState(() {
              widget.apiInfo.isExpand = !widget.apiInfo.isExpand;
            });
          },
        ),
        // 详细的请求信息
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: widget.apiInfo.isExpand
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: DetailedApiItem(widget.apiInfo),
                )
              : SizedBox(),
        ),
        widget.apiInfo.isExpand ? Divider(height: 1) : SizedBox()
      ],
    );
  }
}

/// 简约的api信息
class SimpleApiItem extends StatefulWidget {
  /// api信息
  final ApiInfo apiInfo;

  /// 是否展开详情
  final bool isExpand;

  /// 详情点击回调
  final VoidCallback onPressed;

  /// mock回调
  final ValueChanged<String> onMock;

  /// mock编辑框的控制器
  final TextEditingController mockEditingController = TextEditingController();

  SimpleApiItem(
      {Key key, this.apiInfo, this.isExpand, this.onPressed, this.onMock})
      : super(key: key) {
    mockEditingController.text = apiInfo.mock;
  }

  @override
  _SimpleApiItemState createState() => _SimpleApiItemState();
}

class _SimpleApiItemState extends State<SimpleApiItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildRowBackground(
            context,
            IconButton(
              onPressed: widget.onPressed,
              icon: Icon(widget.isExpand
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right),
            )),
        Expanded(
            child:
                buildRowBackground(context, SelectableText(widget.apiInfo.url)),
            flex: 4),
        Expanded(
            child: buildRowBackground(
                context, SelectableText(widget.apiInfo.method)),
            flex: 1),
        Expanded(
            child: buildRowBackground(
                context, SelectableText(widget.apiInfo.description)),
            flex: 4),
        Expanded(
            child: buildRowBackground(
                context,
                widget.apiInfo.isMock
                    ? Icon(Icons.wb_sunny, color: Colors.green)
                    : Icon(Icons.wb_sunny_outlined)),
            flex: 1),
        Expanded(
            child: buildRowBackground(
                context,
                ElevatedButton(
                    onPressed: () {
                      _showInputMockDialog(context);
                    },
                    child: Text("mock"))),
            flex: 1)
      ],
    );
  }

  /// 显示输入mock数据的弹框
  _showInputMockDialog(BuildContext context) async {
    switch (await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Mock数据"),
              content: SizedBox(
                width: 1000,
                height: 500,
                child: TextField(
                  autofocus: true,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  controller: widget.mockEditingController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 0);
                  },
                  child: Text("确定"),
                ),
              ],
            ))) {
      case 0:
        setState(() {
          widget.apiInfo.mock = widget.mockEditingController.text;
          widget.apiInfo.isMock = widget.apiInfo.mock.isNotEmpty;
        });
        ApiStore.instance.addMock(
            widget.apiInfo.methodCode, widget.mockEditingController.text);
        break;
    }
  }
}

/// 展示详细的api信息
class DetailedApiItem extends StatefulWidget {
  /// api信息
  final ApiInfo apiInfo;

  DetailedApiItem(this.apiInfo);

  @override
  _DetailedApiItemState createState() => _DetailedApiItemState();
}

class _DetailedApiItemState extends State<DetailedApiItem> {
  /// json格式化输出
  final JsonEncoder _jsonEncoder = JsonEncoder.withIndent('    ');

  @override
  Widget build(BuildContext context) {
    var apiListProvider = context.watch<ApiListProvider>();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("请求类型", style: TextStyle(color: Theme.of(context).primaryColor)),
      SizedBox(height: 8),
      SelectableText(_jsonEncoder.convert(widget.apiInfo.requestBody)),
      SizedBox(height: 8),
      Text("返回类型", style: TextStyle(color: Theme.of(context).primaryColor)),
      SizedBox(height: 8),
      apiListProvider.isDetailedReturn
          ? DetailedApiListReturnType(widget.apiInfo)
          : SelectableText(_jsonEncoder.convert(widget.apiInfo.returnType)),
    ]);
  }
}

class DetailedApiListReturnType extends StatelessWidget {
  final ApiInfo apiInfo;

  DetailedApiListReturnType(this.apiInfo);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: apiInfo.detailedReturnType
            .map((e) => _buildTable(context, e))
            .toList());
  }

  Widget _buildTable(BuildContext context, DetailedReturnType type) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Color(0xffdee3e9),
            child: SelectableText(
              type.fileName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: type.parameterMap.entries
                .map((e) => Container(
                      color: Color(0xfff0f0f0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SelectableText(e.key),
                              )),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SelectableText(
                                  e.value,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      ),
                    ))
                .toList(),
          )
        ]));
  }
}
