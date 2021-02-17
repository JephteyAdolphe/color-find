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
bool recorderInserted = false;

void saveImage() async {
  final directory = await getExternalStorageDirectory();
  final myImagePath = '${directory.path}/ColorFind';
  final myImgDir = await new Directory(myImagePath).create();

  print(myImagePath);

  final picture = recorder.endRecording();
  final img = await picture.toImage(200, 200);
  final pngBytes = await img.toByteData(format: ImageByteFormat.png);

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
