import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/model/environment_info.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

class Environment extends StatefulWidget {
  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<Environment> {
  TextEditingController _textEditingController = TextEditingController();
  RequestApiController _requestApiController = RequestApiController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          "切换环境",
          style: TextStyle(fontSize: 28),
        ),
        SizedBox(height: 8),
        Expanded(
            child: RequestApi(
                controller: _requestApiController,
                apiFunction: ApiStore.instance.retrofitInfo,
                dataWidgetBuilder: (context, response) {
                  _textEditingController.value = _textEditingController.value
                      .copyWith(text: response.data.url);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "当前环境"),
                        onSubmitted: (value) {
                          _changeEnvironment();
                        },
                      ),
                      SizedBox(height: 16),
                      Text("预设环境"),
                      SizedBox(height: 8),
                      Expanded(child: _buildListWidget(context, response.data))
                    ],
                  );
                }))
      ],
    );
  }

  /// 构建预设环境列表
  Widget _buildListWidget(
      BuildContext context, EnvironmentInfo environmentInfo) {
    return ListView(
      children: environmentInfo.environment
          .map((e) => ListTile(
                title: Text(e.name),
                subtitle: Text(e.url),
                onTap: () {
                  _textEditingController.value =
                      _textEditingController.value.copyWith(text: e.url);
                  _changeEnvironment();
                },
              ))
          .toList(),
    );
  }

  /// 切换环境
  _changeEnvironment() async {
    await ApiStore.instance.retrofitEdit(_textEditingController.text);
    _requestApiController.refresh();
  }
}
