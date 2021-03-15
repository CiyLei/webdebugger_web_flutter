import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/net_work.dart';
import 'package:webdebugger_web_flutter/module/network/time_analysis.dart';

import 'expand.dart';
import 'json_view.dart';
import 'net_work_log.dart';
import 'net_work_log_item_title.dart';

/// 展示网络请求的widget
class NetWorkLogItem extends StatefulWidget {
  /// 请求详情
  final NetWork netWork;

  NetWorkLogItem({Key key, this.netWork}) : super(key: key);

  @override
  _NetWorkLogItemState createState() => _NetWorkLogItemState();
}

class _NetWorkLogItemState extends State<NetWorkLogItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 简约的请求信息
        SimpleNetWorkLog(
          isExpand: widget.netWork.isExpand,
          netWork: widget.netWork,
          onPressed: () {
            setState(() {
              widget.netWork.isExpand = !widget.netWork.isExpand;
            });
          },
        ),
        // 详细的请求信息
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: widget.netWork.isExpand
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: DetailedNetWorkLog(netWork: widget.netWork),
                )
              : SizedBox(),
        ),
        widget.netWork.isExpand ? Divider(height: 1) : SizedBox()
      ],
    );
  }
}

/// 展示简约的请求信息
class SimpleNetWorkLog extends StatelessWidget {
  /// 请求信息
  final NetWork netWork;

  /// 是否展开详情
  final bool isExpand;

  /// 详情点击回调
  final VoidCallback onPressed;

  /// 时间格式
  final _dateFormat = [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss];

  SimpleNetWorkLog({Key key, this.netWork, this.isExpand, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildNetWorkRowBackground(
            context,
            IconButton(
              onPressed: this.onPressed,
              icon: Icon(this.isExpand
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right),
            )),
        Expanded(
            child: buildNetWorkRowBackground(
                context, SelectableText(netWork.method)),
            flex: 2),
        Expanded(
            child: buildNetWorkRowBackground(
                context,
                SelectableText(
                    "${formatDate(DateTime.fromMillisecondsSinceEpoch(netWork.requestTime), _dateFormat)}")),
            flex: 5),
        Expanded(
            child:
                buildNetWorkRowBackground(context, SelectableText(netWork.url)),
            flex: 30)
      ],
    );
  }
}

/// 展示详细的请求信息
class DetailedNetWorkLog extends StatefulWidget {
  /// 请求详情
  final NetWork netWork;

  DetailedNetWorkLog({Key key, this.netWork}) : super(key: key);

  @override
  _DetailedNetWorkLogState createState() => _DetailedNetWorkLogState();
}

class _DetailedNetWorkLogState extends State<DetailedNetWorkLog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("响应码: ", style: TextStyle(color: Colors.blueAccent)),
            SelectableText("${widget.netWork.code}"),
          ],
        ),
        SizedBox(height: 8),
        Expand(
            titleChild: Row(
              children: [
                Text("请求用时: ", style: TextStyle(color: Colors.blueAccent)),
                SelectableText("${widget.netWork.timeCost}ms"),
              ],
            ),
            child: TimeAnalysis(
              netWork: widget.netWork,
            ),
            isExpand: widget.netWork.expandTimeAnalysis,
            onExpandValueChanged: () {
              widget.netWork.expandTimeAnalysis =
                  !widget.netWork.expandTimeAnalysis;
            }),
        SizedBox(height: 8),
        Expand(
          titleChild: NetWorkLogItemTitle(
            title: "请求头",
            showText: widget.netWork.showRequestHeaderText,
            onShowTextChanged: (value) {
              setState(() {
                widget.netWork.showRequestHeaderText = value;
              });
            },
          ),
          child: JsonView(
            content: widget.netWork.requestHeaders,
            showText: widget.netWork.showRequestHeaderText,
          ),
          isExpand: widget.netWork.expandRequestHeader,
          onExpandValueChanged: () {
            setState(() {
              widget.netWork.expandRequestHeader =
                  !widget.netWork.expandRequestHeader;
            });
          },
        ),
        SizedBox(height: 8),
        Expand(
          titleChild: NetWorkLogItemTitle(
            title: "请求内容",
            showText: widget.netWork.showRequestBodyText,
            onShowTextChanged: (value) {
              setState(() {
                widget.netWork.showRequestBodyText = value;
              });
            },
          ),
          child: JsonView(
            content: widget.netWork.requestBody,
            showText: widget.netWork.showRequestBodyText,
          ),
          isExpand: widget.netWork.expandRequestBody,
          onExpandValueChanged: () {
            setState(() {
              widget.netWork.expandRequestBody =
                  !widget.netWork.expandRequestBody;
            });
          },
        ),
        SizedBox(height: 8),
        Expand(
          titleChild: NetWorkLogItemTitle(
            title: "响应头",
            showText: widget.netWork.showResponseHeaderText,
            onShowTextChanged: (value) {
              setState(() {
                widget.netWork.showResponseHeaderText = value;
              });
            },
          ),
          child: JsonView(
            content: widget.netWork.responseHeaders,
            showText: widget.netWork.showResponseHeaderText,
          ),
          isExpand: widget.netWork.expandResponseHeader,
          onExpandValueChanged: () {
            setState(() {
              widget.netWork.expandResponseHeader =
                  !widget.netWork.expandResponseHeader;
            });
          },
        ),
        SizedBox(height: 8),
        Expand(
          titleChild: NetWorkLogItemTitle(
            title: "响应内容",
            showText: widget.netWork.showResponseBodyText,
            onShowTextChanged: (value) {
              setState(() {
                widget.netWork.showResponseBodyText = value;
              });
            },
          ),
          child: JsonView(
            content: widget.netWork.responseBody,
            showText: widget.netWork.showResponseBodyText,
          ),
          isExpand: widget.netWork.expandResponseBody,
          onExpandValueChanged: () {
            setState(() {
              widget.netWork.expandResponseBody =
                  !widget.netWork.expandResponseBody;
            });
          },
        ),
      ],
    );
  }
}
