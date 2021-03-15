import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/common/request_api.dart';
import 'package:webdebugger_web_flutter/model/device_info.dart';

import 'chart.dart';

/// “设备信息”模块
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
          return _buildDeviceWidget(context);
        });
  }

  /// 设备信息的widget
  Widget _buildDeviceWidget(BuildContext context) {
    var appProvider = context.read<AppProvider>();
    return CustomScrollView(
        primary: false,
        // 因为设备信息的接口中返回的设备信息是按组来的
        // 所以我们一共要展示组数*2行，一行展示组的标题，一行展示组中的内容
        // 但是除了展示接口中的设备信息，我们还需要展示fps和内存信息
        // 所以要多一组，这就是为什么要+1
        slivers: List.generate(
          (appProvider.deviceInfo.data.groups.length + 1) * 2,
          (index) {
            // 前2行展示“fps和内存信息”的组标题和内容
            if (index == 0) {
              return SliverToBoxAdapter(
                child: _buildGroupTitleWidget("实时情况"),
              );
            } else if (index == 1) {
              return SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 根据分辨率决定是否横向并列还是竖向并列
                    if (constraints.maxWidth < 600) {
                      return SizedBox(
                        height: 700,
                        child: Column(
                          children: _buildChartsWidget(),
                        ),
                      );
                    } else {
                      return Row(
                        children: _buildChartsWidget(),
                      );
                    }
                  },
                ),
              );
            }
            // 计算当前该展示哪组
            var group = appProvider.deviceInfo.data.groups[(index - 2) ~/ 2];
            if (index % 2 == 0) {
              // 展示组的标题
              return SliverToBoxAdapter(
                child: _buildGroupTitleWidget(group.groupName),
              );
            } else {
              // 展示组的内容
              return SliverGrid.extent(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                maxCrossAxisExtent: 400,
                childAspectRatio: 4,
                children: group.infos
                    .map((e) => _buildInfoCardWidget(context, e))
                    .toList(),
              );
            }
          },
        ));
  }

  // 展示pfs和内存信息的图表
  List<Widget> _buildChartsWidget() {
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

  /// 构建设备信息中具体每个属性组的标题
  Widget _buildGroupTitleWidget(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, top: 16),
      child: SelectableText(
        title,
        style: TextStyle(fontSize: 28),
      ),
    );
  }

  /// 构建设备信息中具体每个属性展示的widget
  Widget _buildInfoCardWidget(BuildContext context, Infos info) {
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
