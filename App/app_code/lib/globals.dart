library app_code.globals;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

List<ColorRecord> records = []; //record of all colors

class ColorRecord {
  Offset point;
  Paint colorRecord;

  ColorRecord({this.point, this.colorRecord});
}

Color activeColor = Colors.black26; //globally selected/current color

PictureRecorder recorder = new PictureRecorder();
//Canvas canvas = new Canvas(recorder);
bool recorderInserted = false;

Future<String> getStorageDirectory() async {
  if (Platform.isAndroid) {
    return (await getExternalStorageDirectory()).path;  // OR return "/storage/emulated/0/Download";
  } else {
    return (await getApplicationDocumentsDirectory()).path;
  }
}

void saveImage() async {
  /*
  final directory2 = await getApplicationDocumentsDirectory();
  print('$directory2');
  */
  final directory = await getApplicationDocumentsDirectory();
  final myImagePath = '${directory.path}/ColorFind';
  print('$myImagePath');
  final myImgDir = await new Directory(myImagePath).create();

  print(myImagePath);

  final picture = recorder.endRecording();
  final img = await picture.toImage(200, 200);
  final pngBytes = await img.toByteData(format: ImageByteFormat.png);

  recorder = new PictureRecorder();
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
