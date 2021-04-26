library app_code.globals;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';

//import directives: Pavan
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

//
String imageID = "-1";
List<ColorRecord> records = []; //record of all colors
Color activeColor = Colors.black; //globally selected/current color
double strokeSize = 8; //size of the stroke

PictureRecorder recorder = new PictureRecorder(); //records canvas draws
Canvas canvas = new Canvas(recorder); // canvas
bool recorderInserted = false; // check

//List (ensures sections are colored in w/ same color)
var selectedColors;
var layerFill;
int fillPermission = 0;
var layerFillOld; //check layer that is going to be filled
var layerBool; //Truth matrix of the picture
var layerAmountMax; //check for amount of pixels per layer
var layerAmountMaxScaled; //scaled to screen size
var layerAmountFilled; //check for amount of pixels filled per layer

// screen sizing
var screenW; // Total screen width
var screenH; // Total screen height
var appBarH; // appBar height
var padding; // padding.
int drawWidth; // Canvas Width limiter
int drawHeight; // Canvas Height limiter

void setCanvasSize() {
  drawHeight = (screenH - appBarH - 65 - padding.top - padding.bottom)
      .floor(); // 65 = palette,, 20 = extra buffer
  drawWidth = (screenW).floor();
}

void printCanvasSize() {
  print(screenW);
  print(screenH);
  print(appBarH);
  print(drawHeight);
  print(drawWidth);
  print(layerAmountMax);
  print(layerAmountMaxScaled);
  print(layerAmountFilled);
  print(fillPermission);
  print(loadedImage.column);
  print(loadedImage.row);
  print(layerFill);
  print(layerFillOld);
}

List<double> getCanvasSize() {
  return [drawWidth.toDouble(), drawHeight.toDouble()];
}

class ColorRecord {
  Offset point; //location
  Paint colorRecord; //color
  int layer; // which layer this is

  ColorRecord({this.point, this.colorRecord, this.layer});
}

void clear() {
  records.clear();
}

void recorderClear() {
  recorder = new PictureRecorder(); //new recorder
  canvas = new Canvas(recorder); //new canvas
}

void fullClear() {
  records.clear(); //clear record of all colors
  recorder = new PictureRecorder(); //new recorder
  canvas = new Canvas(recorder); //new canvas
}

// GLD import

class Image {
  String layerMatrix = '';
  String numLayer = '';
  String colorMap = '';
  String row = '';
  String column = '';
  String title = '';
  List<List<Cell>> matrix;
}

class Cell {
  int value;

  Cell() {
    value = 0;
  }
}

class Counter {
  int cntr;

  Counter() {
    cntr = 0;
  }
}

//Create Image Class
Image loadedImage = new Image();
bool imageLoaded = false;

void fetchFileData(String id) async {
  imageID = id;
  //START
  String readLayerMatrix;
  String readNumLayer;
  String readColorMap;
  String readRow;
  String readColumn;
  String readTitle;
  //create counter
  Counter x = new Counter();
  //create array
  var array;
  //EX
  //load text files
  readLayerMatrix =
      await rootBundle.loadString('assets/' + id + '/layerMatrix.txt');
  readNumLayer = await rootBundle.loadString('assets/' + id + '/numLayer.txt');
  readColorMap = await rootBundle.loadString('assets/' + id + '/colorMap.txt');
  readRow = await rootBundle.loadString('assets/' + id + '/row.txt');
  readColumn = await rootBundle.loadString('assets/' + id + '/column.txt');
  readTitle = await rootBundle.loadString('assets/' + id + '/title.txt');

  selectedColors = List<Color>.filled(int.parse(readNumLayer), null);
  layerFill = List<bool>.filled(int.parse(readNumLayer), false);
  fillPermission = 1;
  layerFillOld = List<bool>.filled(int.parse(readNumLayer), false);
  //Matrix Sized truth table:
  layerBool = List<List<bool>>.filled(
      int.parse(readColumn), List<bool>.filled(int.parse(readRow), false));
  layerAmountMax =
      List<int>.filled(int.parse(readNumLayer), 0); // count for layer amount
  layerAmountMaxScaled = List<int>.filled(int.parse(readNumLayer), 0); //scaled
  layerAmountFilled = List<int>.filled(int.parse(readNumLayer), 0);

  //load text files into Image class
  loadedImage.layerMatrix = readLayerMatrix;
  loadedImage.numLayer = readNumLayer;
  loadedImage.colorMap = readColorMap;
  loadedImage.row = readRow;
  loadedImage.column = readColumn;
  loadedImage.title = readTitle;

  //create matrix and store in Image class
  array = loadedImage.layerMatrix.split(",");
  loadedImage.matrix = new List.generate(
      int.parse(loadedImage.row),
      (i) =>
          new List.generate(int.parse(loadedImage.column), (j) => new Cell()));
  for (var i = 0; i < int.parse(loadedImage.row); i++) {
    for (var j = 0; j < int.parse(loadedImage.column); j++) {
      loadedImage.matrix[i][j].value = int.parse(array[(x.cntr)]);
      layerAmountMax[loadedImage.matrix[i][j].value] += 1;
      x.cntr++;
    }
  }
  x.cntr = 0;
  //END
  int matrixNumber = int.parse(loadedImage.row) * int.parse(loadedImage.column);
  int canvasNumber = drawWidth * drawHeight;
  for (int i = 0; i < layerAmountMax.length; i++) {
    //Scales LayerAmountMax to screen size
    double temp = canvasNumber.toDouble() * layerAmountMax[i] / matrixNumber;
    layerAmountMaxScaled[i] = temp.toInt();
  }
  imageLoaded = true;
}

void fillLayer(Canvas canvas, int layer, Color colorInput) {
  var point;
  int matrixWidth = int.parse(loadedImage.column);
  int matrixHeight = int.parse(loadedImage.row);
  for (var x = 0; x < matrixHeight; x++) {
    if (x % 2 == 0) continue;
    double dx = x * (drawHeight / matrixHeight);
    for (var y = 0; y < matrixWidth; y++) {
      if (y + x % 2 == 0) continue;
      double dy = y * (drawWidth / matrixWidth);
      if (layer == loadedImage.matrix[x][y].value) {
        point = Offset(dy, dx);
        canvas.drawPoints(
          PointMode.points,
          [point],
          Paint()
            ..color = colorInput
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }
}

// Saving images
Future<String> getStorageDirectory() async {
  if (io.Platform.isAndroid) {
    var dirTemp = (await getExternalStorageDirectory())
        .path; // OR return "/storage/emulated/0/Download"; "storage/emulated/0/Pictures";//
    String topDir = "";
    List<String> dirTemp2 = dirTemp.split("/");
    for (int i = 1; i < dirTemp2.length; i++)
      if (dirTemp2[i] != "Android")
        topDir += "/" + dirTemp2[i]; // avoid temp storage
      else
        break;
    return topDir;
  } else {
    return (await getApplicationDocumentsDirectory()).path; // Iphone
  }
}

void saveImage({clearRecords = false}) async {
  var imgPermission = await Permission.storage.status;
  if (imgPermission.isUndetermined) {
    print("");
  }
  //get permission
  if (await (Permission.storage.isGranted))
    print("permission granted");
  else {
    var requestPermission = await Permission.storage.request();
    if (requestPermission == PermissionStatus.denied) {
      return; //Terminate early if no permission was granted.
    }
    print("permission obtained");
  }

  // You can can also directly ask the permission about its status.
  if (await Permission.location.isRestricted) {
    // The OS restricts access, for example because of parental controls.
  }
  //get and create directory for ColorFind
  final directory = await getStorageDirectory();
  final myImagePath = '$directory' + '/ColorFind';
  print('$myImagePath');
  final myImgDir = await new io.Directory(myImagePath).create();

  print(myImagePath);

  print('drawing image');
  //setup recorder with canvas and produce image:
  Paint background = Paint()..color = Colors.white;
  Rect rect = Rect.fromLTWH(0, 0, drawWidth.toDouble(), drawHeight.toDouble());
  List<ColorRecord> points = records;
  canvas.drawRect(rect, background);

  if (fillPermission == 1) {
    for (int i = 0; i < layerFill.length; i++) {
      if (layerFill[i]) {
        // Fill Layer
        fillLayer(canvas, i,
            selectedColors[i] != null ? selectedColors[i] : Colors.black);
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

  //Saving the image:
  final picture = recorder.endRecording();
  final img = await picture.toImage(drawWidth, drawHeight);
  final pngBytes = await img.toByteData(format: ImageByteFormat.png);

  print('Image saving');
  //save image
  String imageName = imageID+loadedImage.title;
  int imgMax = 25;
  for(int i = 0; i < imgMax; i++)
  {//allow saving of image multiple times
    if(await io.File(myImagePath + '/' + imageName + "#$i.png").exists())
      continue;
    else
      {
        imageName += "#$i.png";
        break;
      }
    if(i == 24)
      {
        imageName += "#Temp.png";
        break;
      }
  }
  writeToFile(
      pngBytes, myImagePath + '/' + imageName); //needs to be dynamic saving.

  print('image Saved');

  //cleanup
  recorderClear();
  if (clearRecords) {
    clear();
  }
}

Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new io.File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
