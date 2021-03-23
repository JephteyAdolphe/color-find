library app_code.globals;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';

//import directives: Pavan
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

//
List<ColorRecord> records = []; //record of all colors
Color activeColor = Colors.black26; //globally selected/current color
double strokeSize = 4; //size of the stroke

PictureRecorder recorder = new PictureRecorder(); //records canvas draws
Canvas canvas = new Canvas(recorder); // canvas
bool recorderInserted = false; // check

// screen sizing
var screenW;// Total screen width
var screenH;// Total screen height
var appBarH;// appBar height
var drawWidth;// Canvas Width limiter
var drawHeight;// Canvas Height limiter

void setCanvasSize() {
  drawHeight =
      (screenH - appBarH - 65 - 20).floor(); // 65 = palette,, 20 = extra buffer
  drawWidth = (screenW).floor();
}

void printCanvasSize() {
  print(screenW);
  print(screenH);
  print(appBarH);
  print(drawHeight);
  print(drawWidth);
}

List<double> getCanvasSize() {
  return [drawWidth, drawHeight];
}

class ColorRecord {
  Offset point;
  Paint colorRecord;

  ColorRecord({this.point, this.colorRecord});
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
      x.cntr++;
    }
  }
  x.cntr = 0;
  //END
  imageLoaded = true;
}

// Saving images
Future<String> getStorageDirectory() async {
  if (Platform.isAndroid) {
    return (await getExternalStorageDirectory())
        .path; // OR return "/storage/emulated/0/Download"; "storage/emulated/0/Pictures";//
  } else {
    return (await getApplicationDocumentsDirectory()).path; // Iphone
  }
}

void saveImage() async {
  /*
  final directory2 = await getApplicationDocumentsDirectory();
  print('$directory2');
  */
  var imgPermission = await Permission.storage.status;
  if (imgPermission.isUndetermined) {
    print("");
  }

  // You can can also directly ask the permission about its status.
  if (await Permission.location.isRestricted) {
    // The OS restricts access, for example because of parental controls.
  }
  final directory = await getStorageDirectory();
  final myImagePath = '$directory' + '/ColorFind';
  print('$myImagePath');
  final myImgDir = await new Directory(myImagePath).create();

  print(myImagePath);

  final picture = recorder.endRecording();
  print(picture.toString());
  final img = await picture.toImage(400, 600); // REQUIRES DYNAMIC SIZE OF PHONE
  final pngBytes = await img.toByteData(format: ImageByteFormat.png);

  recorder = new PictureRecorder();
  canvas = new Canvas(recorder);
  recorderInserted = false;

  print('test2');

  writeToFile(pngBytes, myImagePath + '/imgtest.png');

  print('test3');
}

Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
