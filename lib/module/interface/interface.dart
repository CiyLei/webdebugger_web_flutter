import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/common/drag_panel.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/model/attributes.dart';
import 'package:webdebugger_web_flutter/model/base_response.dart';
import 'package:webdebugger_web_flutter/model/children.dart';
import 'package:webdebugger_web_flutter/module/interface/attributes_view.dart';
import 'package:webdebugger_web_flutter/module/interface/view_tree_controller.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// “界面”模块
class Interface extends StatefulWidget {
  @override
  _InterfaceState createState() => _InterfaceState();
}

class _InterfaceState extends State<Interface> {
  /// 当前选中的节点
  Children _selectChildren;

  /// 当前界面所有的节点列表
  List<Children> _childrenList = [];

  /// 获取节点树的接口请求控制器
  RequestApiController _controller;

  /// 是否开启触摸选择
  bool _selectedTouch = false;

  @override
  void initState() {
    _controller = RequestApiController();
    super.initState();
  }

  /// 根据id，在节点列表中找到对应的节点返回
  Children _findChildren(String id, List<Children> list) {
    for (var children in list) {
      if (children.id == id)
        return children;
      else if (children.children != null) {
        var result = _findChildren(id, children.children);
        if (result != null) return result;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = context.watch<AppProvider>();
    // 根据选中的节点id，找到对应的节点
    var children = _findChildren(appProvider.selectViewId, _childrenList);
    // 如果当前选中的节点存在，且与上一个选中的节点不一致的话，刷新状态，重新获取属性列表
    if (children != null &&
        ((_selectChildren != null && _selectChildren.id != children.id) ||
            _selectChildren == null)) {
      setState(() {
        _selectChildren = children;
        _controller.refresh();
      });
    }
    return DragPanel(
        first: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor)),
          child: ViewTreeController(
            // 获取到节点列表的回调
            onGetChildrenList: (list) {
              _childrenList = list;
            },
            // 是否选中了“触摸选择”
            selectedTouch: _selectedTouch,
            // 改变选中“触摸选择”的回调
            onSelectedTouchCallback: (s) {
              setState(() {
                _selectedTouch = s;
                if (_selectedTouch) {
                  // 如果选中了“触摸选择”，调接口通知开启
                  ApiStore.instance.installMonitorView();
                } else {
                  // 如果取消选中了“触摸选择”，调接口通知关闭
                  ApiStore.instance.unInstallMonitorView();
                  // 当前选中的节点也置为null
                  _selectChildren = null;
                }
              });
            },
            // 当前选中的节点
            selectChildren: _selectChildren,
            // 选中节点的回调
            onSelectedCallback: (children) {
              setState(() {
                // 开启“触摸选择”
                _selectedTouch = true;
                _selectChildren = children;
                appProvider.selectViewId = children.id;
                // 重新获取view的属性列表
                _controller.refresh();
                ApiStore.instance.selectView(_selectChildren.id);
              });
            },
          ),
        ),
        second: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor)),
          // 如果没有选中就展示空
          child: _selectChildren == null
              ? Center()
              : RequestApi(
                  controller: _controller,
                  apiFunction: getAttributes,
                  dataWidgetBuilder: (context, response) {
                    return AttributesView(
                        children: _selectChildren,
                        attributesList: response.data);
                  }),
        ));
  }

  /// 获取当前选中节点的全部属性列表
  Future<BaseResponse<List<Attributes>>> getAttributes() async {
    return ApiStore.instance.getAttributes(_selectChildren.id);
  }
}
