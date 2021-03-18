import 'dart:convert';
import 'dart:html' as html;
import 'package:webdebugger_web_flutter/constant.dart';
import 'package:webdebugger_web_flutter/model/api_info.dart';
import 'package:webdebugger_web_flutter/model/attributes.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';
import 'package:webdebugger_web_flutter/model/children.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';
import 'package:webdebugger_web_flutter/model/environment_info.dart';
import 'package:webdebugger_web_flutter/model/media_info.dart';

import 'net_util.dart';

/// 接口请求的集合
class ApiStore {
  /// 保持单例
  static ApiStore instance = ApiStore();

  /// 获取当前接口请求的地址，如果开启了mock，这返回mock地址，否则根据地址栏获取
  static String _hostName() {
    if (Constant.mock) return Constant.mockHostName;
    return html.window.location.hostname;
  }

  /// 获取当前请求接口的端口，如果开启了mock，这返回mock端口，否则根据地址栏获取
  static String _port() {
    if (Constant.mock) return Constant.mockPort;
    return html.window.location.port;
  }

  /// 拼接接口请求地址的url
  static String _url() => "http://${_hostName()}:${_port()}";

  /// 根据WebSocket的端口，拼接WebSocket的地址
  static String webSocketUrl(int webSocketPort) =>
      "ws://${_hostName()}:$webSocketPort";

  /// 根据数据库页面的端口，拼接数据库页面的地址
  static String dbUrl(int dbPort) => "http://${_hostName()}:$dbPort";

  /// 拼接媒体地址
  static String mediaUrl(int mediaPort, String address) =>
      "http://${_hostName()}:$mediaPort/$address";

  /// 获取设备信息
  Future<BaseResponse<DeviceInfo>> getDeviceInfo() async {
    String response = await NetUtil.get("${_url()}/device/info");
    return BaseResponse.fromJson(
        json.decode(response), (data) => DeviceInfo.fromJson(data));
  }

  /// 获取界面节点
  Future<BaseResponse<List<Children>>> getViewTree() async {
    String response = await NetUtil.get("${_url()}/view/viewTree");
    return BaseResponse.fromJson(
        json.decode(response),
        (data) => (data as List)
            .map((e) => e == null ? null : Children.fromJson(e))
            .toList());
  }

  /// 开启触摸选择view
  Future<BaseResponse<bool>> installMonitorView() async {
    String response = await NetUtil.get("${_url()}/view/installMonitorView");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 关闭触摸选择view
  Future<BaseResponse<bool>> unInstallMonitorView() async {
    String response = await NetUtil.get("${_url()}/view/unInstallMonitorView");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 选中指定的view
  Future<BaseResponse<bool>> selectView(String code) async {
    String response =
        await NetUtil.get("${_url()}/view/selectView", params: {"code": code});
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 获取指定view的全部属性
  Future<BaseResponse<List<Attributes>>> getAttributes(String code) async {
    String response = await NetUtil.get("${_url()}/view/getAttributes",
        params: {"code": code});
    return BaseResponse.fromJson(
        json.decode(response),
        (data) => (data as List)
            .map((e) => e == null ? null : Attributes.fromJson(e))
            .toList());
  }

  /// 设置某个view的某个属性的值
  Future<BaseResponse<bool>> setAttributes(
      String code, String attribute, String value) async {
    String response = await NetUtil.get("${_url()}/view/setAttributes",
        params: {"code": code, "attribute": attribute, "value": value});
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 执行提交的代码
  Future<BaseResponse<String>> execute(
      String code, String import, bool runOnMainThread) async {
    String response = await NetUtil.post("${_url()}/code/execute", params: {
      "code": code,
      "import": import,
      "runOnMainThread": runOnMainThread
    });
    return BaseResponse.fromJson(json.decode(response), (data) => data);
  }

  /// 获取媒体列表
  Future<BaseResponse<MediaInfo>> mediaList() async {
    String response = await NetUtil.get("${_url()}/media/list");
    return BaseResponse.fromJson(
        json.decode(response), (data) => MediaInfo.fromJson(data));
  }

  /// 清空媒体列表
  Future<BaseResponse<bool>> cleanMediaList() async {
    String response = await NetUtil.get("${_url()}/media/clean");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 截图申请
  Future<BaseResponse<bool>> screenCapture() async {
    String response = await NetUtil.get("${_url()}/media/screenCapture");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 开始录屏
  Future<BaseResponse<bool>> startScreenRecording() async {
    String response = await NetUtil.get("${_url()}/media/startScreenRecording");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 结束录屏
  Future<BaseResponse<bool>> stopScreenRecording() async {
    String response = await NetUtil.get("${_url()}/media/stopScreenRecording");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 获取环境
  Future<BaseResponse<EnvironmentInfo>> retrofitInfo() async {
    String response = await NetUtil.get("${_url()}/retrofit/info");
    return BaseResponse.fromJson(
        json.decode(response), (data) => EnvironmentInfo.fromJson(data));
  }

  /// 设置环境地址
  Future<BaseResponse<bool>> retrofitEdit(String newUrl) async {
    String response = await NetUtil.post("${_url()}/retrofit/edit",
        params: {"newUrl": newUrl});
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 获取接口api列表
  Future<BaseResponse<List<ApiInfo>>> apiList() async {
    String response = await NetUtil.get("${_url()}/retrofit/apiList");
    return BaseResponse.fromJson(
        json.decode(response),
        (data) => (data as List)
            .map((e) => e == null ? null : ApiInfo.fromJson(e))
            .toList());
  }

  /// 添加mock
  Future<BaseResponse<bool>> addMock(String methodCode, String mock) async {
    String response = await NetUtil.post("${_url()}/retrofit/addMock",
        params: {"methodCode": methodCode, "responseContent": mock});
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 通过url安装apk
  Future<BaseResponse<bool>> installFromUrl(String url) async {
    String response = await NetUtil.get("${_url()}/install/installFromUrl",
        params: {"url": url});
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  /// 上传文件
  Future<BaseResponse<bool>> installFromUpload(html.File file) async {
    String response =
        await NetUtil.upload("${_url()}/install/installFromUpload", file);
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }
}
