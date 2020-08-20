import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_of_life/simulator.dart';

class LifeCanvas extends StatefulWidget {
  final double width;
  final double height;

  LifeCanvas({this.width, this.height});

  @override
  _LifeCanvasState createState() => _LifeCanvasState();
}

class _LifeCanvasState extends State<LifeCanvas> {
  final _simulator = new Simulator(100, 100);
  Timer _timer;
  var _milliseconds = 50;
  bool _playing = false;

  doSimulation(timer) {
    if (_playing) {
      _simulator.tick();
    }
    setState(() {});
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: _milliseconds), doSimulation);

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _simulator.resizeWidth(widget.width ~/ 5.0);
    return Column(children: [
      GestureDetector(
          onVerticalDragStart: (details) => changeState(details),
          onHorizontalDragUpdate: (details) => changeState(details),
          onTapDown: (details) => changeState(details),
          child: Container(
              width: widget.width,
              height: 500,
              child: CustomPaint(
                painter: LifePainter(simulator: _simulator),
                child: Container(),
              ))),
      Row(
        children: [
          RaisedButton(child: Icon(_playing ? Icons.pause  : Icons.play_arrow),
            onPressed: () => {_playing = !_playing},),
          Slider(
            min: 1,
            max: 10,
            divisions: 8,
            label: 'milliseconds $_milliseconds',
            value: (_milliseconds.toDouble() ~/ 50).toDouble(),
            onChanged: (value) {
              _milliseconds = (value * 50).toInt() ;
              _timer.cancel();
              _timer = Timer.periodic(
                  Duration(milliseconds: _milliseconds.toInt()), doSimulation);
            },
          )
        ],
      ),
    ]);
  }

  void changeState(details) {
    _simulator.changeState(
        details.localPosition.dx ~/ 5, details.localPosition.dy ~/ 5);
  }
}

class LifePainter extends CustomPainter {
  Simulator simulator;

  LifePainter({this.simulator});

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }

  paint(Canvas canvas, Size size) {
    for (int i = 0; i < simulator.width; i++) {
      for (int j = 0; j < simulator.height; j++) {
        Rect myRect = Offset(i * 5.0, j * 5.0) & Size(5.0, 5.0);
        final paint = Paint()
          ..color = simulator.isAlive(i, j) ? Colors.greenAccent : Colors.black
          ..strokeWidth = 4;
        canvas.drawRect(myRect, paint);
      }
    }
  }
}
