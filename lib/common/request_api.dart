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
  ResponseState<T> responseState;

  RequestApi(
      {Key key, @required this.apiFunction, @required this.dataWidgetBuilder})
      : super(key: key);

  @override
  _RequestApiState createState() => _RequestApiState<T>();
}

class _RequestApiState<T> extends State<RequestApi> {
  @override
  void initState() {
    _reGetApi();
    super.initState();
  }

  _reGetApi() async {
    setState(() {
      widget.responseState = null;
    });
    try {
      var response = await widget.apiFunction();
      widget.responseState =
          ResponseState<T>(response: response, netState: NetState.success);
    } catch (e) {
      print(e);
      widget.responseState =
          ResponseState<T>(error: e, netState: NetState.error);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.responseState == null) {
      return Loading();
    } else if (widget.responseState.netState == NetState.success) {
      return Center(
        child: widget.dataWidgetBuilder(context, widget.responseState.response),
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
                      child: SelectableText(widget.responseState.error.toString()),
                    )
                  ],
                ));
      });
    }
  }
}
