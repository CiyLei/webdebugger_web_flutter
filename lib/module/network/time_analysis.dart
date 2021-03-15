import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/net_work.dart';

/// 网络请求时间分析widget
class TimeAnalysis extends StatelessWidget {
  final NetWork netWork;
  final List<TimeAnalysisLevel> _timeAnalysisList = [];

  TimeAnalysis({Key key, this.netWork}) : super(key: key) {
    // 解析dns时间
    if (netWork.dnsStartTime != 0) {
      // 有走dns
      if (netWork.dnsEndTime != 0) {
        // dns成功
        _timeAnalysisList.add(TimeAnalysisLevel(
            "DNS解析（${netWork.dnsEndTime - netWork.dnsStartTime}ms）", 0));
      } else if (netWork.callFailedTime != 0) {
        // dns失败
        _timeAnalysisList.add(TimeAnalysisLevel(
            "DNS解析失败（${netWork.callFailedTime - netWork.dnsStartTime}ms）", 0));
      }
    }

    // 解析连接时间
    if (netWork.connectStartTime != 0) {
      // 连接成功
      if (netWork.connectEndTime != 0) {
        // 连接成功
        _timeAnalysisList.add(TimeAnalysisLevel(
            "连接成功（${netWork.connectEndTime - netWork.connectStartTime}ms）", 0));
      } else if (netWork.connectFailedTime != 0) {
        // 连接失败
        _timeAnalysisList.add(TimeAnalysisLevel(
            "连接失败（${netWork.connectFailedTime - netWork.connectStartTime}ms）",
            0));
      }
      // 开始连接
      if (netWork.secureConnectStartTime != 0) {
        // 解析https时间
        if (netWork.secureConnectEndTime != 0) {
          // https加密成功
          _timeAnalysisList.add(TimeAnalysisLevel(
              "HTTPS加密（${netWork.secureConnectEndTime - netWork.secureConnectStartTime}ms）",
              1));
        } else {
          // https加密失败
          _timeAnalysisList.add(TimeAnalysisLevel(
              "HTTPS加密失败（${netWork.connectFailedTime - netWork.secureConnectStartTime}ms）",
              1));
        }
      }
    }

    // 解析写入读取内容时间
    if (netWork.connectionAcquiredTime != 0) {
      // 读取内容结束，连接释放
      if (netWork.connectionReleasedTime != 0) {
        // 连接成功
        _timeAnalysisList.add(TimeAnalysisLevel(
            "读取写入成功（${netWork.connectionReleasedTime - netWork.connectionAcquiredTime}ms）",
            0));
      } else if (netWork.callFailedTime != 0) {
        // 连接失败
        _timeAnalysisList.add(TimeAnalysisLevel(
            "读取写入失败（${netWork.callFailedTime - netWork.connectionAcquiredTime}ms）",
            0));
      }

      // 解析读取http request header时间
      if (netWork.requestHeadersStartTime != 0) {
        // 开始读取http request header
        if (netWork.requestHeadersEndTime != 0) {
          // 读取http request header成功
          _timeAnalysisList.add(TimeAnalysisLevel(
              "写入请求头（${netWork.requestHeadersEndTime - netWork.requestHeadersStartTime}ms）",
              1));
        } else if (netWork.callFailedTime != 0) {
          // 读取http request header失败
          _timeAnalysisList.add(TimeAnalysisLevel(
              "写入请求头失败（${netWork.callFailedTime - netWork.requestHeadersStartTime}ms）",
              1));
        }
      }

      // 解析读取http request body时间
      if (netWork.requestBodyStartTime != 0) {
        // 开始读取http request body
        if (netWork.requestBodyEndTime != 0) {
          // 读取http request body成功
          _timeAnalysisList.add(TimeAnalysisLevel(
              "写入请求内容（${netWork.requestBodyEndTime - netWork.requestBodyStartTime}ms）",
              1));
        } else if (netWork.callFailedTime != 0) {
          // 读取http request body失败
          _timeAnalysisList.add(TimeAnalysisLevel(
              "写入请求内容失败（${netWork.callFailedTime - netWork.requestBodyStartTime}ms）",
              1));
        }
      }

      // 解析读取http response header时间
      if (netWork.responseHeadersStartTime != 0) {
        // 开始读取http response header
        if (netWork.responseHeadersEndTime != 0) {
          // 读取http response header成功
          _timeAnalysisList.add(TimeAnalysisLevel(
              "读取响应头（${netWork.responseHeadersEndTime  - netWork.responseHeadersStartTime}ms）",
              1));
        } else if (netWork.callFailedTime != 0) {
          // 读取http response header失败
          _timeAnalysisList.add(TimeAnalysisLevel(
              "读取响应头失败（${netWork.callFailedTime - netWork.responseHeadersStartTime}ms）",
              1));
        }
      }
      // 解析读取http response body时间
      if (netWork.responseBodyStartTime != 0) {
        // 开始读取http response body
        if (netWork.responseBodyEndTime != 0) {
          // 读取http response body成功
          _timeAnalysisList.add(TimeAnalysisLevel(
              "读取响应内容（${netWork.responseBodyEndTime - netWork.responseBodyStartTime}ms）",
              1));
        } else if (netWork.callFailedTime != 0) {
          // 读取http response body失败
          _timeAnalysisList.add(TimeAnalysisLevel(
              "读取响应内容失败（${netWork.callFailedTime - netWork.responseBodyStartTime}ms）",
              1));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String result = "";
    for (var value in _timeAnalysisList) {
      String space = "";
      for (var i = 0; i < value.level; i++) {
        space += "    ";
      }
      result += "$space${value.title}\n";
    }
    return SelectableText(result);
  }
}

class TimeAnalysisLevel {
  final String title;
  final int level;

  TimeAnalysisLevel(this.title, this.level);
}
