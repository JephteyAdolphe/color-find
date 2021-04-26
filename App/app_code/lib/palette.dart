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
                globals.activeColor = Colors.deepOrange;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.deepOrange;
                  }))),

          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.deepOrangeAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.deepOrangeAccent;
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
                globals.activeColor = Colors.amber;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.amber;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.yellowAccent[700];
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.yellowAccent[700];
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
                globals.activeColor = Colors.limeAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.limeAccent;
                  }))),

          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.lightGreenAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.lightGreenAccent;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.lightGreen;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.lightGreen;
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
                globals.activeColor = Colors.greenAccent[700];
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.greenAccent[700];
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.greenAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.greenAccent;
                  }))),
          ElevatedButton(
              onPressed: () {
                globals.activeColor = Colors.cyanAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.cyanAccent;
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
                globals.activeColor = Colors.indigoAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.indigoAccent;
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
                globals.activeColor = Colors.deepPurpleAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.deepPurpleAccent;
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
                globals.activeColor = Colors.purpleAccent;
              },
              child: null,
              style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.purpleAccent;
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