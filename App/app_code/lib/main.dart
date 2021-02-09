import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_code/palette.dart';
import 'menu.dart';
import 'canvas.dart';

Color activeColor = Colors.black26;
List<ColorRecord> points = [];
int selectedLayer = -1;
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
        home: DrawingBlock());

    // If homepage is replaced with drawingblock then drawing works
  }
}

class ColorRecord {
  Offset point;
  Paint colorRecord;

  ColorRecord({this.point, this.colorRecord});
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test2'),
      ),
      //drawer: getMenu(context),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Blue'),
              onTap: () {
                activeColor = Colors.blue;
              },
            ),
            ListTile(
              title: Text('Black'),
              onTap: () {
                activeColor = Colors.black;
              },
            ),
            ListTile(
              title: Text('Red'),
              onTap: () {
                activeColor = Colors.red;
              },
            ),
            ListTile(
              title: Text('White'),
              onTap: () {
                activeColor = Colors.white;
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onPanDown: (details) {
          this.setState(() {
            selectedLayer = 1; // where select a layer
            points.add(ColorRecord(
                // [1 , 2 ; 1 , 0]
                point: details.localPosition,
                colorRecord: Paint()
                  ..color = activeColor
                  ..strokeWidth = 2
                  ..strokeCap = StrokeCap.round));
          });
        },
        onPanUpdate: (details) {
          this.setState(() {
            if (selectedLayer == 1)
              points.add(ColorRecord(
                  point: details.localPosition,
                  colorRecord: Paint()
                    ..color = activeColor
                    ..strokeWidth = 2
                    ..strokeCap = StrokeCap.round));
          });
        },
        onPanEnd: (details) {
          this.setState(() {
            selectedLayer = -1; // where deselect a layer
            points.add(null);
          });
        },
        child: Stack(
          children: <Widget>[
            //borderRadius: BorderRadius.all(Radius.circular(20)),
            CustomPaint(
              painter: MyPainter(
                points: points,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              color: const Color(0xffffff).withOpacity(0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: getPalette(context),
    );
  }
}

class MyPainter extends CustomPainter {
  List<ColorRecord> points;

  MyPainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        Paint paint = points[x].colorRecord;
        canvas.drawLine(points[x].point, points[x + 1].point, paint);
      } else if (points[x] != null && points[x + 1] == null) {
        Paint paint = points[x].colorRecord;
        canvas.drawPoints(PointMode.points, [points[x].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

Widget getPalette(BuildContext context) {
  return Container(
      height: 60,
      padding: EdgeInsets.only(top: 5),

      // color buttons wrapped in listview so that we can scroll through them
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.red;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.red;
              }))),
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.orange;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.orange;
              }))),
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.yellow;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.yellow;
              }))),
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.green;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.green;
              }))),
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.blue;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.blue;
              }))),
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.indigo;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.indigo;
              }))),
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.purple;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.purple;
              }))),
          ElevatedButton(
              onPressed: () {
                activeColor = Colors.pink;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return Colors.pink;
              }))),
        ],
      ));
}
