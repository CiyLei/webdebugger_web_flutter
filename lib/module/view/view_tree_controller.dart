import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/common/selected.dart';
import 'package:webdebugger_web_flutter/model/children.dart';
import 'package:webdebugger_web_flutter/module/view/view_tree.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// 展示节点列表控制器的widget
class ViewTreeController extends StatefulWidget {
  /// 当前选中的节点
  final Children selectChildren;

  /// 改变选中节点的回调
  final ValueChanged<Children> onSelectedCallback;

  /// 是否选中的“触摸选择”
  final bool selectedTouch;

  /// 改变了选中“触摸选择”的回调
  final ValueChanged<bool> onSelectedTouchCallback;

  /// 获取了节点列表的回调
  final ValueChanged<List<Children>> onGetChildrenList;

  ViewTreeController(
      {Key key,
      this.selectChildren,
      this.onSelectedCallback,
      this.selectedTouch,
      this.onGetChildrenList,
      this.onSelectedTouchCallback})
      : super(key: key);

  @override
  _ViewTreeControllerState createState() => _ViewTreeControllerState();
}

class _ViewTreeControllerState extends State<ViewTreeController> {
  /// 获取节点列表的请求控制器
  RequestApiController _apiController;

  @override
  void initState() {
    _apiController = RequestApiController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: Row(
            children: [
              // 刷新获取节点列表的按钮
              ElevatedButton(
                onPressed: () {
                  _apiController.refresh();
                },
                child: Text("刷新"),
              ),
              SizedBox(
                width: 8,
              ),
              SelectedButton(
                  selected: widget.selectedTouch,
                  child: Text("触摸选择"),
                  selectedCallback: widget.onSelectedTouchCallback)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            color: Theme.of(context).dividerColor,
            height: 1,
          ),
        ),
        Expanded(
            child: RequestApi(
                controller: _apiController,
                apiFunction: ApiStore.instance.getViewTree,
                dataWidgetBuilder: (context, response) {
                  // 触发获取节点列表的回调
                  if (widget.onGetChildrenList != null) {
                    widget.onGetChildrenList(response.data);
                  }
                  // 展示节点列表
                  return ViewTree(
                    // 节点列表
                    childrenList: response.data,
                    // 选中的节点
                    selectChildren: widget.selectChildren,
                    // 选中节点的回调
                    onSelectedCallback: widget.onSelectedCallback,
                  );
                }))
      ],
    );
  }
}
