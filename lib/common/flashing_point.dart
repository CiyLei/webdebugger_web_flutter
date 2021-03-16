import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlashingPoint extends StatefulWidget {
  final double radius;
  final Color color;
  final FlashingPointController flashingPointController;

  FlashingPoint(
      {Key key,
      @required this.radius,
      this.flashingPointController,
      this.color = Colors.red})
      : super(key: key);

  @override
  _FlashingPointState createState() => _FlashingPointState();
}

class _FlashingPointState extends State<FlashingPoint> {
  bool _flashingFlag = true;

  @override
  void initState() {
    if (widget.flashingPointController != null) {
      widget.flashingPointController._handleStartFlash = () {
        widget.flashingPointController.isFlashing = true;
        _startFlash();
      };
      widget.flashingPointController._handleStopFlash = () {
        widget.flashingPointController.isFlashing = false;
      };
      // 如果处于启动状态，就直接启动
      if (widget.flashingPointController.isFlashing) {
        widget.flashingPointController._handleStartFlash();
      }
    }
    super.initState();
  }

  _startFlash() async {
    setState(() {
      _flashingFlag = !_flashingFlag;
    });
    await Future.delayed(widget.flashingPointController.duration);
    if (widget.flashingPointController.isFlashing) _startFlash();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          widget.flashingPointController.isFlashing && !_flashingFlag ? 0 : 1,
      child: Container(
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(Radius.circular(widget.radius))),
        width: widget.radius * 2,
        height: widget.radius * 2,
      ),
    );
  }
}

class FlashingPointController {
  Duration duration;
  bool isFlashing = false;
  VoidCallback _handleStartFlash;
  VoidCallback _handleStopFlash;

  FlashingPointController({@required this.duration});

  void startFlash() {
    if (_handleStartFlash != null) {
      _handleStartFlash();
      isFlashing = true;
    }
  }

  void stopFlash() {
    if (_handleStopFlash != null) {
      _handleStopFlash();
      isFlashing = false;
    }
  }
}
