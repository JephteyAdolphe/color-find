library app_code.globals;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';


List<ColorRecord> records = []; //record of all colors

class ColorRecord {
    Offset point;
    Paint colorRecord;

    ColorRecord({this.point, this.colorRecord});

}

Color activeColor = Colors.black26; //globally selected/current color