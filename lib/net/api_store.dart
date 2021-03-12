import 'dart:convert';
import 'dart:html' as html;
import 'package:webdebugger_web_flutter/constant.dart';
import 'package:webdebugger_web_flutter/model/attributes.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';
import 'package:webdebugger_web_flutter/model/children.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';

import 'net_util.dart';

class ApiStore {
  static ApiStore instance = ApiStore();

  static String _hostName() {
    if (Constant.debug) return Constant.mockHostName;
    return html.window.location.hostname;
  }

  static String _port() {
    if (Constant.debug) return Constant.mockPort;
    return html.window.location.port;
  }

  static String _url() => "http://${_hostName()}:${_port()}";

  static String webSocketUrl(int webSocketPort) =>
      "ws://${_hostName()}:$webSocketPort";

  static String dbUrl(int dbPort) => "http://${_hostName()}:$dbPort";

  /// 获取设备信息
  Future<BaseResponse<DeviceInfo>> getDeviceInfo() async {
    String response = await NetUtil.Get("${_url()}/device/info");
    return BaseResponse.fromJson(
        json.decode(response), (data) => DeviceInfo.fromJson(data));
  }

  /// 获取界面节点
  Future<BaseResponse<List<Children>>> getViewTree() async {
    String response = await NetUtil.Get("${_url()}/view/viewTree");
    return BaseResponse.fromJson(
        json.decode(response),
        (data) => (data as List)
            .map((e) => e == null ? null : Children.fromJson(e))
            .toList());
  }

  Future<BaseResponse<bool>> installMonitorView() async {
    String response = await NetUtil.Get("${_url()}/view/installMonitorView");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  Future<BaseResponse<bool>> unInstallMonitorView() async {
    String response = await NetUtil.Get("${_url()}/view/unInstallMonitorView");
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  Future<BaseResponse<bool>> selectView(String code) async {
    String response =
        await NetUtil.Get("${_url()}/view/selectView", params: {"code": code});
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }

  Future<BaseResponse<List<Attributes>>> getAttributes(String code) async {
    String response = await NetUtil.Get("${_url()}/view/getAttributes",
        params: {"code": code});
    return BaseResponse.fromJson(
        json.decode(response),
        (data) => (data as List)
            .map((e) => e == null ? null : Attributes.fromJson(e))
            .toList());
  }

  Future<BaseResponse<bool>> setAttributes(
      String code, String attribute, String value) async {
    String response = await NetUtil.Get("${_url()}/view/setAttributes",
        params: {"code": code, "attribute": attribute, "value": value});
    return BaseResponse.fromJson(json.decode(response), (data) => true);
  }
}
