import 'dart:html';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';

class Device extends StatefulWidget {
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  @override
  Widget build(BuildContext context) {
    return RequestApi(
        apiFunction: context.read<AppProvider>().getDeviceInfo,
        dataWidgetBuilder: (context, response) {
          return deviceWidget(context);
        });
  }

  Widget deviceWidget(BuildContext context) {
    var appProvider = context.read<AppProvider>();
    return CustomScrollView(
        primary: false,
        slivers: List.generate(
          (appProvider.deviceInfo.data.groups.length + 1) * 2,
          (index) {
            if (index == 0) {
              return SliverToBoxAdapter(
                child: groupTitle("实时情况"),
              );
            } else if (index == 1) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  child: StreamBuilder(
                    stream: appProvider.deviceWebSocket.onMessage,
                    builder: this.realTime,
                  ),
                ),
              );
            }
            var group = appProvider.deviceInfo.data.groups[(index - 2) ~/ 2];
            if (index % 2 == 0) {
              return SliverToBoxAdapter(
                child: groupTitle(group.groupName),
              );
            } else {
              return SliverGrid.extent(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                maxCrossAxisExtent: 400,
                childAspectRatio: 4,
                children: group.infos.map((e) => infoCard(context, e)).toList(),
              );
            }
          },
        ));
  }

  Widget groupTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, top: 16),
      child: SelectableText(
        title,
        style: TextStyle(fontSize: 28),
      ),
    );
  }

  Widget realTime(BuildContext context, AsyncSnapshot<MessageEvent> snapshot) {
    return Text(snapshot.data.data.toString());
  }

  Widget infoCard(BuildContext context, Infos info) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              info.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              height: 8,
            ),
            SelectableText(info.value),
          ],
        ),
      ),
    );
  }
}
