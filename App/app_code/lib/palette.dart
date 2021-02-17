import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as globals;

// Make color options circulars?

// Scrollable color pallette



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
                globals.activeColor = Colors.red;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.red;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.orange;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.orange;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.yellow;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.yellow;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.green;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.green;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.blue;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.blue;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.indigo;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.indigo;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.purple;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.purple;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.pink;
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