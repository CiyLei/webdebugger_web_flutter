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

class Interface extends StatefulWidget {
  @override
  _InterfaceState createState() => _InterfaceState();
}

class _InterfaceState extends State<Interface> {
  Children _selectChildren;
  List<Children> _childrenList = [];
  RequestApiController _controller;
  bool _selectedTouch = false;

  @override
  void initState() {
    _controller = RequestApiController();
    super.initState();
  }

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
    var children = _findChildren(appProvider.selectViewId, _childrenList);
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
            onGetChildrenList: (list) {
              _childrenList = list;
            },
            selectedTouch: _selectedTouch,
            onSelectedTouchCallback: (s) {
              setState(() {
                _selectedTouch = s;
                if (_selectedTouch) {
                  ApiStore.instance.installMonitorView();
                } else {
                  ApiStore.instance.unInstallMonitorView();
                  _selectChildren = null;
                }
              });
            },
            selectChildren: _selectChildren,
            onSelectedCallback: (children) {
              setState(() {
                _selectedTouch = true;
                _selectChildren = children;
                _controller.refresh();
                ApiStore.instance.selectView(_selectChildren.id);
              });
            },
          ),
        ),
        second: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor)),
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

  Future<BaseResponse<List<Attributes>>> getAttributes() async {
    return ApiStore.instance.getAttributes(_selectChildren.id);
  }
}
