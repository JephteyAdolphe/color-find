import 'dart:ui';
import 'dart:math';
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
bool dummyMode = false; // using dummyLayering
bool debugMode = true;

int getLayer(
    targetWidth, targetHeight, fillLayer, oldPositionDX, oldPositionDY) {
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
  // counts if specific spot hasn't been visited before
  if (fillLayer ==
          globals.loadedImage.matrix[selectedDY.toInt()][selectedDX.toInt()]
              .value ||
      fillLayer == -2) {
    var dxScale = matrixWidth / globals.drawWidth;
    var dyScale = matrixHeight / globals.drawHeight;
    var temp0 = double.parse(globals.loadedImage.column)/100;
    var temp1 = temp0.toInt() * dxScale * dyScale;
    if (temp1 < 1)
      temp1 = 1;
    var tempDot = temp1.toInt() * temp1.toInt();
    if (true || !globals.layerBool[selectedDY.toInt()][selectedDX.toInt()]) {
      globals.layerBool[selectedDY.toInt()][selectedDX.toInt()] = true;
      globals.layerAmountFilled[globals
          .loadedImage
          .matrix[selectedDY.toInt()][selectedDX.toInt()]
          .value] += tempDot.toInt();
      if (oldPositionDX != null) {
        var old2DY = oldPositionDY * (matrixHeight / globals.drawHeight);
        var old2DX = oldPositionDX * (matrixWidth / globals.drawWidth);
        var dist = 0.5*sqrt((old2DY - selectedDY) * (old2DY - selectedDY) +
            (old2DX - selectedDX) * (old2DX - selectedDX));
        if (dist < 1)
          dist = 1;
        globals.layerAmountFilled[globals
            .loadedImage
            .matrix[selectedDY.toInt()][selectedDX.toInt()]
            .value] += dist.toInt() * temp1.toInt();
        if (debugMode) {
          print("testx:");
          print(selectedDX);
          print(selectedDY);
          print(old2DY);
          print(old2DX);
          print(tempDot);
          print(dist);
        }
      } else {
        if (debugMode) {
          print("testx:");
          print(selectedDX);
          print(selectedDY);
          print(globals.strokeSize.toInt());
          print(dxScale);
          print(dyScale);
          print(temp1);
          print(tempDot);
        }
      }
    }
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

class _DrawingBlockState extends State<DrawingBlock>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // get screen sizes to rescale image to canvas
    globals.screenH = MediaQuery.of(context).size.height;
    globals.screenW = MediaQuery.of(context).size.width;
    globals.appBarH = AppBar().preferredSize.height;
    globals.padding = MediaQuery.of(context).padding;
    globals.setCanvasSize();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB388FF), //0xFFA5D6A7
        centerTitle: true,
        title: const Text(
          'ColorFind',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            fontFamily: 'BalooBhai',
          ),
        ),
      ),
      drawer: Menu(),
      //getMenu(context)/build(context)
      body: GestureDetector(
        onPanDown: (details) {
          this.setState(() {
            oldDX = details.localPosition.dx.toInt(); //record point position
            oldDY = details.localPosition.dy.toInt();
            if (globals.imageLoaded) {
              //Get layer at current position
              selectedLayer = getLayer(details.localPosition.dx,
                  details.localPosition.dy, -2, null, null);
              dummyMode = false;
            } else {
              selectedLayer = dummyLayers(
                  details.localPosition.dy, details.localPosition.dx);
              dummyMode = true;
              globals.fillPermission = 0;
            }
            if (selectedLayer != -1 &&
                (globals.fillPermission ==
                        0 //if it already filled, do not add more points
                    ? true
                    : !globals
                        .layerFillOld[selectedLayer])) //  if it a valid layer
            {
              //set selected color to selected layer
              if (!dummyMode && globals.selectedColors[selectedLayer] == null) {
                selectedColor = globals.activeColor;
                globals.selectedColors[selectedLayer] = selectedColor;
              }
              //globals.layerFill[selectedLayer] = true;
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
                    ..color = dummyMode
                        ? globals.activeColor
                        : globals.selectedColors[selectedLayer]
                    ..strokeWidth = globals.strokeSize
                    ..strokeCap = StrokeCap.round,
                  layer: selectedLayer));
            } else {
              selectedLayer =
                  -2; // This will stop it from drawing anything if selectedLayer = -1
            }
          });
        },
        onPanUpdate: (details) {
          this.setState(() {
            if (oldDX != details.localPosition.dx.toInt() &&
                oldDY != details.localPosition.dy.toInt()) {
              //check if it is the same spot as before if so don't put a point.
              if (globals.imageLoaded) {
                //Get layer at current position
                tempLayer = getLayer(details.localPosition.dx,
                    details.localPosition.dy, selectedLayer, oldDX, oldDY);
              } else
                tempLayer = dummyLayers(
                    details.localPosition.dy, details.localPosition.dx);
              if (tempLayer == selectedLayer &&
                  tempLayer != -1 &&
                  (globals.fillPermission ==
                          0 //if it already filled, do not add more points
                      ? true
                      : !globals.layerFillOld[selectedLayer])) {
                //check if layer at current position is the same as the selected layer
                oldDX =
                    details.localPosition.dx.toInt(); //record point position
                oldDY = details.localPosition.dy.toInt();
                lastNull = false; // this is non null point so reset last null
                globals.records.add(globals.ColorRecord(
                    //add record
                    point: details.localPosition,
                    colorRecord: Paint()
                      ..color = dummyMode
                          ? globals.activeColor
                          : globals.selectedColors[selectedLayer]
                      ..strokeWidth = globals.strokeSize
                      ..strokeCap = StrokeCap.round,
                    layer: selectedLayer));
              } else {
                if (lastNull) {
                  //if the last point was not null then add null point and set lastnull
                } else {
                  oldDX = null;
                  oldDY = null;
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
            //AnimatedBuilder(
              //animation: _controller,
              //builder: (_, __) {
                CustomPaint(
                  painter: MyPainter(
                    points: globals.records,
                  ),
                ),
              //},
            //),
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

    //testing fillLayer function
    if (globals.fillPermission == 1) {
      for (int i = 0; i < globals.layerFill.length; i++) {
        if (!globals.layerFill[i] && globals.layerAmountFilled[i] / globals.layerAmountMaxScaled[i] >
            1.75) {
          //condition check to fill layer
          globals.layerFill[i] = true;
        }
        if (globals.layerFill[i]) {
          // Fill Layer
          globals.fillLayer(
              canvas,
              i,
              globals.selectedColors[i] != null
                  ? globals.selectedColors[i]
                  : Colors.black);
        }
      }
      for (int i = 0; i < globals.layerFill.length; i++) {
        if (!globals.layerFillOld[i] && globals.layerFill[i]) {
          //clean up
          globals.layerFillOld[i] = true;
          for (int x = 0; x < points.length; x++) {
            points.removeWhere((item) => item.layer == i);
            globals.records.removeWhere((item) => item.layer == i);
          }
        }
      }
    }

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
