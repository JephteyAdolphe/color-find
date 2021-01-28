import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Need eraser/reset button

GlobalKey _canvasKey = GlobalKey(); // canvas key used to get canvas size

class DrawingBlock extends StatefulWidget {
  @override
  _DrawingBlockState createState() => _DrawingBlockState();
}

// Find a way to export this stateful widget to the main file

class _DrawingBlockState extends State<DrawingBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: _canvasKey,
      height: 650, // Make height dynamic
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
}

// Drawing block is where the coloring takes place

Widget getCanvas(BuildContext context) {
  return Container(
    key: _canvasKey,
    // color: Colors.red,
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
  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    // canvas.draw
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

// Returns width and height of conatiner (need to tailor to canvas instead)

getCanvasSize() {
  final RenderBox renderCanvasBox =
      _canvasKey.currentContext.findRenderObject();
  return renderCanvasBox.size; // return (width, height)
}
