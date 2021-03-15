import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/common/app_provider.dart';
import 'package:webdebugger_web_flutter/utils/time_util.dart';

/// pfs图表
class FpsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fpsMap = context.watch<AppProvider>().fpsMap.entries.toList();
    List<FlSpot> spotList = [];
    // 计算fps的最大值和最小值，决定图表的上线限
    // 上限：max*1.1，下限：min*0.9
    double maxY = 0, minY = double.maxFinite;
    for (var i = 0; i < fpsMap.length; i++) {
      maxY = fpsMap[i].value.fps > maxY ? fpsMap[i].value.fps : maxY;
      minY = fpsMap[i].value.fps < minY ? fpsMap[i].value.fps : minY;
      spotList.add(FlSpot(i.toDouble(), fpsMap[i].value.fps));
    }
    return spotList.isEmpty
        ? Center()
        : LineChart(LineChartData(
            borderData: FlBorderData(
                show: true, border: Border.all(color: Colors.black, width: 1)),
            lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueAccent,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((e) {
                        var dateTime = DateTime.fromMillisecondsSinceEpoch(
                            fpsMap[e.x.toInt()].key);
                        var fps = fpsMap[e.x.toInt()].value.fps;
                        return LineTooltipItem(
                            "时间：${TimeUtil.formatTime(dateTime.hour)}:${TimeUtil.formatTime(dateTime.minute)}:${TimeUtil.formatTime(dateTime.second)}\nfps：${fps.toStringAsFixed(2)}",
                            const TextStyle(color: Colors.white));
                      }).toList();
                    })),
            lineBarsData: [
              LineChartBarData(
                spots: spotList,
                isCurved: true,
                barWidth: 3,
                colors: [
                  Colors.blue,
                ],
                belowBarData: BarAreaData(
                  show: true,
                  gradientFrom: const Offset(0, 1),
                  gradientTo: const Offset(0, 0),
                  colors: [
                    Colors.red.withOpacity(0.6),
                    Colors.green.withOpacity(0.8)
                  ],
                ),
                dotData: FlDotData(
                  show: true,
                ),
              ),
            ],
            minY: minY * 0.9,
            maxY: maxY * 1.1,
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 14,
                  getTitles: (value) {
                    var entry = fpsMap[value.toInt()];
                    var dateTime =
                        DateTime.fromMillisecondsSinceEpoch(entry.key);
                    return "${TimeUtil.formatTime(dateTime.hour)}:${TimeUtil.formatTime(dateTime.minute)}:${TimeUtil.formatTime(dateTime.second)}";
                  }),
              leftTitles: SideTitles(
                showTitles: true,
                getTitles: (value) => value.toInt().toString(),
              ),
            )));
  }
}

/// 内存信息图表
class MemoryChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fpsMap = context.watch<AppProvider>().fpsMap.entries.toList();
    List<FlSpot> totalPssList = [];
    List<FlSpot> totalPrivateDirtyList = [];
    // 计算内存占用的最大值和最小值，决定图表的上线限
    // 上限：max*1.1，下限：min*0.9
    double maxY = 0, minY = double.maxFinite;
    for (var i = 0; i < fpsMap.length; i++) {
      maxY = fpsMap[i].value.totalPss > maxY ? fpsMap[i].value.totalPss : maxY;
      minY = fpsMap[i].value.totalPrivateDirty < minY
          ? fpsMap[i].value.totalPrivateDirty
          : minY;
      totalPssList
          .add(FlSpot(i.toDouble(), fpsMap[i].value.totalPss.toDouble()));
      totalPrivateDirtyList.add(
          FlSpot(i.toDouble(), fpsMap[i].value.totalPrivateDirty.toDouble()));
    }
    return totalPssList.isEmpty
        ? Center()
        : LineChart(LineChartData(
            borderData: FlBorderData(
                show: true, border: Border.all(color: Colors.black, width: 1)),
            lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.blueAccent,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((e) {
                        var dateTime = DateTime.fromMillisecondsSinceEpoch(
                            fpsMap[e.x.toInt()].key);
                        if (e.barIndex == 0) {
                          var totalPss = fpsMap[e.x.toInt()].value.totalPss;
                          return LineTooltipItem(
                              "时间：${TimeUtil.formatTime(dateTime.hour)}:${TimeUtil.formatTime(dateTime.minute)}:${TimeUtil.formatTime(dateTime.second)}\n实际占用大小：${totalPss.toInt()}(MB)",
                              const TextStyle(color: Colors.white));
                        } else {
                          var totalPrivateDirty =
                              fpsMap[e.x.toInt()].value.totalPrivateDirty;
                          return LineTooltipItem(
                              "时间：${TimeUtil.formatTime(dateTime.hour)}:${TimeUtil.formatTime(dateTime.minute)}:${TimeUtil.formatTime(dateTime.second)}\n占用大小：${totalPrivateDirty.toInt()}(MB)",
                              const TextStyle(color: Colors.white));
                        }
                      }).toList();
                    })),
            lineBarsData: [
              LineChartBarData(
                spots: totalPssList,
                isCurved: true,
                barWidth: 3,
                colors: [
                  Colors.greenAccent.withOpacity(0.8),
                ],
                belowBarData: BarAreaData(
                  show: true,
                  colors: [Colors.greenAccent.withOpacity(0.8)],
                ),
                dotData: FlDotData(
                  show: true,
                ),
              ),
              LineChartBarData(
                spots: totalPrivateDirtyList,
                isCurved: true,
                barWidth: 3,
                colors: [
                  Colors.blueAccent.withOpacity(0.8),
                ],
                belowBarData: BarAreaData(
                  show: true,
                  colors: [Colors.blueAccent.withOpacity(0.8)],
                ),
                dotData: FlDotData(
                  show: true,
                ),
              ),
            ],
            minY: minY * 0.9,
            maxY: maxY * 1.1,
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 14,
                  getTitles: (value) {
                    var entry = fpsMap[value.toInt()];
                    var dateTime =
                        DateTime.fromMillisecondsSinceEpoch(entry.key);
                    return "${TimeUtil.formatTime(dateTime.hour)}:${TimeUtil.formatTime(dateTime.minute)}:${TimeUtil.formatTime(dateTime.second)}";
                  }),
              leftTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: (maxY - minY) / 5,
                getTitles: (value) => value.toInt().toString(),
              ),
            )));
  }
}
