import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/common/selected.dart';
import 'package:webdebugger_web_flutter/model/children.dart';
import 'package:webdebugger_web_flutter/module/interface/view_tree.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

class ViewTreeController extends StatefulWidget {
  Children selectChildren;
  ValueChanged<Children> onSelectedCallback;
  bool selectedTouch = false;
  ValueChanged<bool> onSelectedTouchCallback;

  ViewTreeController(
      {Key key,
      this.selectChildren,
      this.onSelectedCallback,
      this.selectedTouch,
      this.onSelectedTouchCallback})
      : super(key: key);

  @override
  _ViewTreeControllerState createState() => _ViewTreeControllerState();
}

class _ViewTreeControllerState extends State<ViewTreeController> {
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
              ElevatedButton(
                onPressed: () {
                  _apiController.refresh();
                },
                child: Text("刷新"),
              ),
              SizedBox(
                width: 8,
              ),
              Selected(
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
                  return ViewTree(
                    childrenList: response.data,
                    selectChildren: widget.selectChildren,
                    onSelectedCallback: widget.onSelectedCallback,
                  );
                }))
      ],
    );
  }
}
