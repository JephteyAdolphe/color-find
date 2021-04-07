import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:app_code/palette.dart';
import 'menu.dart';
import 'globals.dart' as globals;

int selectedLayer = -1; // which layer is selected
int tempLayer = -1; // new layer to compare.
int oldDY = -1; // old point no repeats -> reducing load
int oldDX = -1;
bool lastNull = false; // check if one null has been inserted -> reducing load
Color selectedColor; //color selected for current section

int getLayer(targetWidth, targetHeight) {
  // rescales given position and Layering Matrix to the canvas size
  int matrixHeight = int.parse(globals.loadedImage.row);
  int matrixWidth = int.parse(globals.loadedImage.column);
  var selectedDY = targetHeight * (matrixHeight / globals.drawHeight);
  var selectedDX = targetWidth * (matrixWidth / globals.drawWidth);
  if (selectedDY > matrixHeight ||
      selectedDX > matrixWidth ||
      selectedDX < 0 ||
      selectedDY < 0) {
    // if it is bigger or negative then matrix size return -1 for null
    return -1;
  }
  return globals
      .loadedImage.matrix[selectedDY.toInt()][selectedDX.toInt()].value;
}

//Dummy Layers
/*
1 | 4
-----
2 | 5
-----
3 | 6
*/
int dummyLayers(selectedHeight, selectedWidth) {
  var dummyHeight = globals.drawHeight;
  var dummyHLayers = 3;
  var dummyHSeg = dummyHeight / dummyHLayers;
  var dummyWidth = globals.drawWidth;
  var dummyWLayers = 2;
  var dummyWSeg = dummyWidth / dummyWLayers;
  for (int heightLayer = 1; heightLayer <= dummyHLayers; heightLayer++) {
    for (int widthLayer = 1; widthLayer <= dummyWLayers; widthLayer++) {
      if (selectedWidth < dummyWSeg * widthLayer + 1) {
        if (selectedHeight < dummyHSeg * heightLayer + 1) {
          return heightLayer + dummyHLayers * (widthLayer - 1);
          // just a dummy segmentation of equal sizes
        }
      }
    }
  }
  return -1; // out of bounds -> null layer
}
// Maybe find a way to import widgets from separate files so that theres not too much code in this main one

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((val) {
    runApp(MyApp());
  });
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
    // get screen sizes to rescale image to canvas
    globals.screenH = MediaQuery.of(context).size.height;
    globals.screenW = MediaQuery.of(context).size.width;
    globals.appBarH = AppBar().preferredSize.height;
    globals.setCanvasSize();
    return Scaffold(
      appBar: AppBar(
        title: Text('Layering Dummy Test'),
      ),
      drawer: getMenu(context),
      body: GestureDetector(
        onPanDown: (details) {
          this.setState(() {
            oldDX = details.localPosition.dx.toInt(); //record point position
            oldDY = details.localPosition.dy.toInt();
            if (globals.imageLoaded) {
              //Get layer at current position
              selectedLayer =
                  getLayer(details.localPosition.dx, details.localPosition.dy);
              //set selected color to selected layer
              if (globals.selectedColors[selectedLayer] == null) {
                selectedColor = globals.activeColor;
                globals.selectedColors[selectedLayer] = selectedColor;
              }
            } else
              selectedLayer = dummyLayers(
                  details.localPosition.dy, details.localPosition.dx);
            //Debug
            print("Selected Layer:");
            print(selectedLayer);
            print("Local Position Y:");
            print(details.localPosition.dy);
            print("Local Position X:");
            print(details.localPosition.dx);
            //
            globals.records.add(globals.ColorRecord(
                //add record.
                // [1 , 2 ; 1 , 0]
                point: details.localPosition,
                colorRecord: Paint()
                  ..color = globals.selectedColors[selectedLayer]
                  ..strokeWidth = globals.strokeSize
                  ..strokeCap = StrokeCap.round));
          });
        },
        onPanUpdate: (details) {
          this.setState(() {
            if (oldDX != details.localPosition.dx.toInt() &&
                oldDY != details.localPosition.dy.toInt()) {
              //check if it is the same spot as before if so don't put a point.
              if (globals.imageLoaded) {
                //Get layer at current position
                tempLayer = getLayer(
                    details.localPosition.dx, details.localPosition.dy);
              } else
                tempLayer = dummyLayers(
                    details.localPosition.dy, details.localPosition.dx);

              if (tempLayer == selectedLayer) {
                //check if layer at current position is the same as the selected layer
                oldDX =
                    details.localPosition.dx.toInt(); //record point position
                oldDY = details.localPosition.dy.toInt();
                lastNull = false; // this is non null point so reset last null
                globals.records.add(globals.ColorRecord(
                    //add record
                    point: details.localPosition,
                    colorRecord: Paint()
                      ..color = globals.selectedColors[selectedLayer]
                      ..strokeWidth = globals.strokeSize
                      ..strokeCap = StrokeCap.round));
              } else {
                if (lastNull) {
                  //if the last point was not null then add null point and set lastnull
                } else {
                  lastNull = true; // only 1 null in a row.
                  globals.records.add(null); // cuts line
                }
              }
            }
          });
        },
        onPanEnd: (details) {
          this.setState(() {
            oldDX = -1; //reset oldDX
            oldDY = -1; //reset oldDY
            selectedLayer = -1; // where deselect a layer
            tempLayer = -1; // deselect
            if (lastNull) {
              lastNull = false; // clear
            } else {
              globals.records.add(null); // cuts line
            }
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
                            color: const Color(0xffffff).withOpacity(
                                0)), // used to create a box for GestureDetector
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
