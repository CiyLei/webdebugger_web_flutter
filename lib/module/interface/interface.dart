import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  RequestApiController _controller;
  bool _selectedTouch = false;

  @override
  void initState() {
    _controller = RequestApiController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DragPanel(
        first: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor)),
          child: ViewTreeController(
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
    ApiStore.instance.selectView(_selectChildren.id);
    return ApiStore.instance.getAttributes(_selectChildren.id);
  }
}
