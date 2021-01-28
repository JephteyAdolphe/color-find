import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Need eraser/reset button

class DrawingBlock extends StatefulWidget {
  @override
  _DrawingBlockState createState() => _DrawingBlockState();
}

// Find a way to export this stateful widget to the main file
// This stateful widget allows for user finger detection (drawing)

class _DrawingBlockState extends State<DrawingBlock> {
  List<Offset> points = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650, // Make height dynamic instead of fixed
      child: GestureDetector(
          onPanDown: (details) {
            this.setState(() {
              points.add(details.localPosition);
            });
          },
          onPanUpdate: (details) {
            this.setState(() {
              points.add(details.localPosition);
            });
          },
          onPanEnd: (details) {
            this.setState(() {
              points.add(null);
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: CustomPaint(
              painter: MyPainter(points: points),
            ),
          )),
    );
  }
}

// Drawing block is where the coloring takes place

Widget getCanvas(BuildContext context) {
  return Container(
    height: 650, // Make height dynamic
    // decoration: BoxDecoration(border: Border.all(width: 8), borderRadius: BorderRadius.circular(12)),

    // Color block is wrapped in a Container then scaffold to control the size of colors and scrolling ability
    /*child: Scaffold(
        body: ColorBlock(),
      )*/
    child: GestureDetector(
        onPanDown: (details) {},
        onPanUpdate: (details) {},
        onPanEnd: (details) {},
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: CustomPaint(
            painter: MyPainter(),
          ),
        )),
  );
}
/*
class ColorBlock extends StatelessWidget {
  // Reuse this base widget on every page
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      child: Container(),
      // size: Size(500, 300),
    );
  }
}*/

class MyPainter extends CustomPainter {
  List<Offset> points;

  MyPainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(points[x], points[x + 1], paint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[x]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
