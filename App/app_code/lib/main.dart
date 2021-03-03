import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_code/palette.dart';
import 'menu.dart';
import 'canvas.dart';
import 'globals.dart' as globals;

int selectedLayer = -1;
int tempLayer = -1;
//Dummy Layers
var dummyHeight = 600;
var dummyHLayers = 3;
var dummyHSeg = dummyHeight/dummyHLayers;
var dummyWidth = 400;
var dummyWLayers = 2;
var dummyWSeg = dummyWidth/dummyWLayers;
int dummyLayers(selectedHeight,selectedWidth) {
  for(int heightLayer = 1; heightLayer <= dummyHLayers; heightLayer++){
    for(int widthLayer = 1; widthLayer <= dummyWLayers; widthLayer++){
      if(selectedWidth < dummyWSeg*widthLayer + 1) {
        if(selectedHeight < dummyHSeg*heightLayer + 1) {
          return heightLayer + dummyHLayers*(widthLayer - 1); // just a dummy segmentation of equal sizes
        }
      }
    }
  }
  return -1; // out of bounds -> null layer
}
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
      drawer: getMenu(context),
      body: GestureDetector(
        onPanDown: (details) {
          this.setState(() {
            selectedLayer = 1; // where select a layer
            selectedLayer = dummyLayers(details.localPosition.dy
              ,details.localPosition.dx);
            print("Selected Layer:");
            print(selectedLayer);
            print("Local Position Y:");
            print(details.localPosition.dy);
            print("Local Position X:");
            print(details.localPosition.dx);
            globals.records.add(globals.ColorRecord(
                // [1 , 2 ; 1 , 0]
                point: details.localPosition,
                colorRecord: Paint()
                  ..color = globals.activeColor
                  ..strokeWidth = 2
                  ..strokeCap = StrokeCap.round));
          });
        },
        onPanUpdate: (details) {
          this.setState(() {
            tempLayer = 1; // should equal -1, -1 implies null layer
            /*
            tempLayer = dummyLayers(coord[0],coord[1])
            */
            tempLayer = dummyLayers(details.localPosition.dy
                ,details.localPosition.dx);
            if (tempLayer == selectedLayer)
              globals.records.add(globals.ColorRecord(
                  point: details.localPosition,
                  colorRecord: Paint()
                    ..color = globals.activeColor
                    ..strokeWidth = 2
                    ..strokeCap = StrokeCap.round));
          });
        },
        onPanEnd: (details) {
          this.setState(() {
            selectedLayer = -1; // where deselect a layer
            tempLayer = -1; // deselect
            globals.records.add(null);
          });
        },
        child: Stack(
          children: <Widget>[
            //borderRadius: BorderRadius.all(Radius.circular(20)),
            CustomPaint(
              painter: MyPainter(
                points: globals.records,
              ),
            ),
            Row(
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
          ],
        ),
      ),
      bottomNavigationBar: getPalette(context),
    );
  }
}

class MyPainter extends CustomPainter {
  List<globals.ColorRecord> points;

  MyPainter({this.points});
  //Canvas asd = new Canvas(globals.recorder);
  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    //if (!globals.recorderInserted) {
    //  globals.recorderInserted = true;
    //  asd = new Canvas(globals.recorder);
    //}
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
    // Recording
    globals.canvas.drawRect(rect, background);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        Paint paint = points[x].colorRecord;
        globals.canvas.drawLine(points[x].point, points[x + 1].point, paint);
      } else if (points[x] != null && points[x + 1] == null) {
        Paint paint = points[x].colorRecord;
        globals.canvas.drawPoints(PointMode.points, [points[x].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
