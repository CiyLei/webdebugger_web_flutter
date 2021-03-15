import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 可拖动的2个子widget空间的容器widget
class DragPanel extends StatefulWidget {
  /// 左边的子widget
  final Widget first;

  /// 右边的子widget
  final Widget second;

  DragPanel({Key key, @required this.first, @required this.second})
      : super(key: key);

  @override
  _DragPanelState createState() => _DragPanelState();
}

class _DragPanelState extends State<DragPanel> {
  /// 拖拽widget的宽度
  final _dragWidgetWidth = 30.0;

  /// 当前左边子widget的宽度
  double _firstPanelWidth = 0;

  /// 当前右边子widget的宽度
  double _secondPanelWidth = 0;

  /// 当前左边子widget的最低宽度（父widget的宽度*0.3）
  double _minPanelWidth = 0;

  /// 当前右边子widget的最低宽度（父widget的宽度*0.3）
  double _maxPanelWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var width = constraints.maxWidth;
      // 默认2个子widget各占一半
      if (_firstPanelWidth == 0) {
        _firstPanelWidth = (width - _dragWidgetWidth) / 2;
      }
      // 因为父widget的宽度会变，而左边的widget是一开始固定下来的，所以其他值是实时计算的
      _secondPanelWidth = width - _dragWidgetWidth - _firstPanelWidth;
      _minPanelWidth = width * 0.3;
      _maxPanelWidth = width - _dragWidgetWidth - _minPanelWidth;
      return Row(
        children: [
          Container(
            width: _firstPanelWidth,
            child: Center(
              child: widget.first,
            ),
          ),
          Container(
            width: _dragWidgetWidth,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                GestureDetector(
                  // 横向拖动监听
                  onHorizontalDragUpdate: (details) {
                    // 拖动就是改变子widget的宽度
                    setState(() {
                      _firstPanelWidth += details.delta.dx;
                      _secondPanelWidth -= details.delta.dx;
                      _firstPanelWidth = _roundMinMax(
                          _firstPanelWidth, _minPanelWidth, _maxPanelWidth);
                      _secondPanelWidth = _roundMinMax(
                          _secondPanelWidth, _minPanelWidth, _maxPanelWidth);
                    });
                  },
                  child: SizedBox(
                    width: _dragWidgetWidth,
                    // 用InkResponse添加一些交互效果
                    child: InkResponse(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Icon(Icons.drag_indicator),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: _secondPanelWidth,
            child: Center(
              child: widget.second,
            ),
          )
        ],
      );
    });
  }

  /// 根据指定value、最小值和最大值，返回最终的value
  double _roundMinMax(double value, double min, double max) {
    if (value > max)
      return max;
    else if (value < min)
      return min;
    else
      return value;
  }
}
