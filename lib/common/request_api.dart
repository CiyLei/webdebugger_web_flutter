import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/loading.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';

/// 接口请求的lambda
typedef GetApiFunction<T> = Future<BaseResponse<T>> Function();

/// 接口请求成功后，需要展示的widget
typedef DataWidgetBuilder<T> = Widget Function(
    BuildContext context, BaseResponse<T> response);

/// 接口返回状态的封装
///
/// 保存了是否成功、成功的数据或具体错误信息。
class ResponseState<T> {
  /// 具体的请求错误信息
  Exception error;

  /// 请求成功的数据
  BaseResponse<T> response;

  /// 是否成功的状态
  NetState netState;

  ResponseState({this.error, this.response, this.netState});
}

/// 请求是否成功的状态枚举
enum NetState { success, error }

/// 需要接口请求才展示的widget的封装
///
/// 接口在请求中会展示圆形进度条，请求错误会展示重试等按钮，请求成功则展示指定的widget
class RequestApi<T> extends StatefulWidget {
  /// 需要请求的接口
  final GetApiFunction<T> apiFunction;

  /// 请求成功后需要展示的widget
  final DataWidgetBuilder<T> dataWidgetBuilder;

  /// 请求的控制器，可以重新触发请求等
  final RequestApiController controller;

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
  /// 请求的控制器，可以重新触发请求等
  RequestApiController controller;

  /// 请求接口的状态保存，如果等于null，则视为请求中
  ResponseState<T> responseState;

  _RequestApiState({this.controller});

  @override
  void initState() {
    // 控制调用refresh方法时触发的事件
    if (controller != null) {
      controller._refreshHandle(() {
        _reGetApi();
      });
    }
    // 马上开始请求
    _reGetApi();
    super.initState();
  }

  // 请求接口
  _reGetApi() async {
    // 首先将请求接口状态设置为null，这样接口就会刷新，处于请求中的界面会展示
    setState(() {
      responseState = null;
    });
    try {
      // 请求接口
      var response = await widget.apiFunction();
      // 请求成功的状态保存
      responseState =
          ResponseState<T>(response: response, netState: NetState.success);
    } catch (e) {
      print(e);
      // 请求失败的数据保存
      responseState = ResponseState<T>(error: e, netState: NetState.error);
    }
    // 接口请求完毕了，刷新状态，展示对应的widget
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (responseState == null) {
      // 当请求结果为null时，视为请求中，展示请求中的widget
      return Loading();
    } else if (responseState.netState == NetState.success) {
      // 请求成功，展示指定的widget
      return Center(
        child: widget.dataWidgetBuilder(context, responseState.response),
      );
    } else {
      // 请求失败，展示请求失败的widget
      return LoadError(retryCallback: () {
        _reGetApi();
      }, errorCallback: () {
        // 弹框展示详细的错误信息
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

/// 接口请求的控制类
class RequestApiController {
  /// 处理refresh方法的回调
  VoidCallback _refreshCallback;

  /// 设置处理refresh方法的回调
  _refreshHandle(VoidCallback callback) => _refreshCallback = callback;

  refresh() {
    if (_refreshCallback != null) _refreshCallback();
  }
}
