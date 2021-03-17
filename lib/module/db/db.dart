import 'dart:html';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/provider/device_provider.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';
import 'dart:ui' as ui;

/// 展示数据库页面的widget（就是一个html-iframe）
class DB extends StatefulWidget {
  @override
  _DBState createState() => _DBState();
}

class _DBState extends State<DB> {
  Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();
  final _htmlViewType = "iframeElement";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var deviceProvider = context.read<DeviceProvider>();
      var dbUrl = ApiStore.dbUrl(deviceProvider.deviceInfo.dbPort);
      if (_iframeWidget == null) {
        _iframeElement.src = dbUrl;
        _iframeElement.style.border = 'none';

        // ignore: undefined_prefixed_name
        ui.platformViewRegistry.registerViewFactory(
          _htmlViewType,
          (int viewId) => _iframeElement,
        );

        _iframeWidget = HtmlElementView(
          key: UniqueKey(),
          viewType: _htmlViewType,
        );
      }
      return _iframeWidget;
    });
  }
}
