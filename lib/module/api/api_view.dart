import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:webdebugger_web_flutter/common/min_width_scroll.dart';
import 'package:webdebugger_web_flutter/common/provider/api_list_provider.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/common/selected.dart';
import 'package:webdebugger_web_flutter/model/api_info.dart';
import 'package:webdebugger_web_flutter/module/api/api_list_item.dart';
import 'package:webdebugger_web_flutter/module/network/net_work_log.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

class ApiView extends StatefulWidget {
  @override
  _ApiViewState createState() => _ApiViewState();
}

class _ApiViewState extends State<ApiView> {
  /// 列表请求控制器
  RequestApiController requestApiController = RequestApiController();
  ScrollController scrollController = ScrollController();

  /// 横向滚动条控制器
  ScrollController horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var apiListProvider = context.read<ApiListProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
                onPressed: requestApiController.refresh, child: Text("刷新")),
            SelectedButton(
                selected: apiListProvider.isDetailedReturn,
                selectedCallback: (value) {
                  setState(() {
                    apiListProvider.isDetailedReturn =
                        !apiListProvider.isDetailedReturn;
                  });
                },
                child: Text("查看详细返回结构"))
          ],
        ),
        SizedBox(height: 8),
        Expanded(
            child: RequestApi(
                controller: requestApiController,
                apiFunction: ApiStore.instance.apiList,
                dataWidgetBuilder: (context, response) =>
                    _buildApiListTableWidget(context, response.data)))
      ],
    );
  }

  /// 构建api列表的表格
  Widget _buildApiListTableWidget(BuildContext context, List<ApiInfo> apiList) {
    var apiListProvider = context.read<ApiListProvider>();
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor)),
      // 想手动设置一个最小宽度，但是限制会继承父widget
      // 所以通过LayoutBuilder获取现在的最大宽度，然后在通过UnconstrainedBox取消限制，在手动设置最小宽度
      child: MinWidthScroller(
        minWidth: apiListProvider.minWidth,
        scrollController: horizontalScrollController,
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey.withAlpha(80)),
              child: Row(
                children: [
                  buildRowBackground(
                      context,
                      Icon(Icons.chevron_right,
                          color: Colors.transparent, size: 40)),
                  Expanded(
                      child:
                          buildRowBackground(context, SelectableText("请求地址")),
                      flex: 4),
                  Expanded(
                      child:
                          buildRowBackground(context, SelectableText("请求方式")),
                      flex: 1),
                  Expanded(
                      child: buildRowBackground(context, SelectableText("说明")),
                      flex: 4),
                  Expanded(
                      child:
                          buildRowBackground(context, SelectableText("Mock")),
                      flex: 1),
                  Expanded(
                      child: buildRowBackground(context, SelectableText("操作")),
                      flex: 1)
                ],
              ),
            ),
            Expanded(
                child: Scrollbar(
                    controller: scrollController,
                    isAlwaysShown: true,
                    child: ListView(
                      controller: scrollController,
                      children: apiList.map((e) => ApiListItem(e)).toList(),
                    )))
          ],
        ),
      ),
    );
  }
}
