import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_code/palette.dart';
import 'menu.dart';
import 'canvas.dart';

// Maybe find a way to import widgets from separate files so that theres not too much code in this main one

void main() {
  runApp(MyApp());
}

// Main app where everything will be displayed
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Color Find Prototype',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        // Home Page contains everything in it (side menu, canvas, colors)
        home: HomePage());

    // If homepage is replaced with drawingblock then drawing works
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Color Find"),
          centerTitle: true,
        ),

        // drawer is a hamburger menu and TabList is the list of items (of type Drawer) that we create
        drawer: getMenu(context),
        // backgroundColor: Colors.red,

        // Body contains a list(children) of widgets which are the drawing canvas and color pallette, in that order
        body: Column(
          children: <Widget>[
            DrawingBlock(),
            getPalette(context),
          ],
        ));
  }
}

class DrawingBlock extends StatefulWidget {
  @override
  _DrawingBlockState createState() => _DrawingBlockState();
}

/* Find a way to export this stateful widget to the main file
 This stateful widget allows for user finger detection (drawing)
 Copied from canvas.dart
*/

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
    return true;
  }
}
