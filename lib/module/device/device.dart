import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';

import 'chart.dart';

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return SizedBox(
                        height: 700,
                        child: Column(
                          children: charts(),
                        ),
                      );
                    } else {
                      return Row(
                        children: charts(),
                      );
                    }
                  },
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

  List<Widget> charts() {
    return [
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("FPS监控"),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: double.maxFinite,
            child: FpsChart(),
          )
        ],
      )),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("内存监控"),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: double.maxFinite,
            child: MemoryChart(),
          )
        ],
      ))
    ];
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
            SizedBox(
              height: 8,
            ),
            SelectableText(info.value),
          ],
        ),
      ),
    );
  }
}
