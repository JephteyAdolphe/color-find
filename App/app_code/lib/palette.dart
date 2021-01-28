import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.red;
              }))),
          ElevatedButton(
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.orange;
              }))),
          ElevatedButton(
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.yellow;
              }))),
          ElevatedButton(
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.green;
              }))),
          ElevatedButton(
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.blue;
              }))),
          ElevatedButton(
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.indigo;
              }))),
          ElevatedButton(
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.purple;
              }))),
          ElevatedButton(
              onPressed: null,
              child: null,
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) return Colors.blue;
                return Colors.pink;
              }))),
        ],
      ));
}
