import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DragPanel extends StatefulWidget {
  final Widget first;
  final Widget second;

  DragPanel({Key key, @required this.first, @required this.second})
      : super(key: key);

  @override
  _DragPanelState createState() => _DragPanelState();
}

class _DragPanelState extends State<DragPanel> {
  final _dragWidgetWidth = 30.0;
  double _firstPanelWidth = 0;
  double _secondPanelWidth = 0;
  double _minPanelWidth = 0;
  double _maxPanelWidth = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var width = constraints.maxWidth;
      if (_firstPanelWidth == 0) {
        _firstPanelWidth = (width - _dragWidgetWidth) / 2;
      }
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
                // Container(
                //   width: 4,
                //   color: Theme.of(context).dividerColor,
                // ),
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _firstPanelWidth += details.delta.dx;
                      _secondPanelWidth -= details.delta.dx;
                      _firstPanelWidth = roundMinMax(
                          _firstPanelWidth, _minPanelWidth, _maxPanelWidth);
                      _secondPanelWidth = roundMinMax(
                          _secondPanelWidth, _minPanelWidth, _maxPanelWidth);
                    });
                  },
                  child: SizedBox(
                    width: _dragWidgetWidth,
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

  double roundMinMax(double value, double min, double max) {
    if (value > max)
      return max;
    else if (value < min)
      return min;
    else
      return value;
  }
}
