import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Drawing block is where the coloring takes place

Widget getCanvas(BuildContext context) {
  return Container(
      height: 650,
      decoration: BoxDecoration(
          border: Border.all(width: 8),
          borderRadius: BorderRadius.circular(12)),

      // Color block is wrapped in a Container then scaffold to control the size of colors and scrolling ability
      child: Scaffold(
        body: ColorBlock(),
      ));
}

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
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset start = Offset(0, size.height / 2);
    Offset end = Offset(size.width, size.height / 2);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
