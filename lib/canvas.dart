import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:game_of_life/simulator.dart';

class LifeCanvas extends StatefulWidget {
  final double width;
  final double height;

  LifeCanvas({this.width, this.height});

  @override
  _LifeCanvasState createState() => _LifeCanvasState();
}

class _LifeCanvasState extends State<LifeCanvas> with TickerProviderStateMixin {
  final _simulator = new Simulator(100, 100);
  bool _playing = false;
  Animation<double> animation;
  AnimationController controller;
  Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        if (_playing) {
          _simulator.tick();
        }
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _simulator.resizeWidth(widget.width ~/ 5.0);
    return Column(children: [
      GestureDetector(
          onVerticalDragStart: (details) => changeState(details),
          onVerticalDragUpdate: (details) => changeState(details),
          onHorizontalDragStart: (details) => changeState(details),
          onHorizontalDragUpdate: (details) => changeState(details),
          onTapDown: (details) => changeState(details),
          child: Container(
              width: widget.width,
              height: 500,
              child: CustomPaint(
                painter: LifePainter(simulator: _simulator),
                child: Container(),
              ))),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                RaisedButton(
                  child: Icon(_playing ? Icons.pause : Icons.play_arrow),
                  onPressed: () => {_playing = !_playing},
                ),
              ],
            ),
            Row(
              children: [
                RaisedButton.icon(
                    onPressed: () {
                      _showClearDialog(context);
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Clear'))
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  void changeState(details) {
    _simulator.changeState(
        details.localPosition.dx ~/ 5, details.localPosition.dy ~/ 5);
  }

  void _showClearDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: new Text("Clear all"),
          content: new Text(
              "Are you sure you want to clear the board? This cannot be undone"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                _simulator.clear();
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Simulation restarted')));
                Navigator.of(dialogContext).pop();
              },
            )
          ],
        );
      },
    );
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
