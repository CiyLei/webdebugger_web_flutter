import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/loading.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';

typedef GetApiFunction<T> = Future<BaseResponse<T>> Function();
typedef DataWidgetBuilder<T> = Widget Function(
    BuildContext context, BaseResponse<T> response);

class ResponseState<T> {
  Exception error;
  BaseResponse<T> response;
  NetState netState;

  ResponseState({this.error, this.response, this.netState});
}

enum NetState { success, error }

class RequestApi<T> extends StatefulWidget {
  GetApiFunction<T> apiFunction;
  DataWidgetBuilder<T> dataWidgetBuilder;
  RequestApiController controller;

  RequestApi(
      {Key key,
      @required this.apiFunction,
      @required this.dataWidgetBuilder,
      this.controller})
      : super(key: key);

  @override
  _RequestApiState createState() =>
      _RequestApiState<T>(controller: this.controller);
}

class _RequestApiState<T> extends State<RequestApi> {
  RequestApiController controller;
  ResponseState<T> responseState;

  _RequestApiState({this.controller});

  @override
  void initState() {
    if (controller != null) {
      controller._refreshHandle(() {
        _reGetApi();
      });
    }
    _reGetApi();
    super.initState();
  }

  _reGetApi() async {
    setState(() {
      responseState = null;
    });
    try {
      var response = await widget.apiFunction();
      responseState =
          ResponseState<T>(response: response, netState: NetState.success);
    } catch (e) {
      print(e);
      responseState = ResponseState<T>(error: e, netState: NetState.error);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (responseState == null) {
      return Loading();
    } else if (responseState.netState == NetState.success) {
      return Center(
        child: widget.dataWidgetBuilder(context, responseState.response),
      );
    } else {
      return LoadError(retryCallback: () {
        _reGetApi();
      }, errorCallback: () {
        showDialog(
            context: context,
            builder: (context) => SimpleDialog(
                  title: const Text("错误详情"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24.0),
                      child: SelectableText(responseState.error.toString()),
                    )
                  ],
                ));
      });
    }
  }
}

class RequestApiController {
  VoidCallback _refreshCallback;

  _refreshHandle(VoidCallback callback) => _refreshCallback = callback;

  refresh() {
    if (_refreshCallback != null) _refreshCallback();
  }
}
