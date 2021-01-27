import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Hamburger Menu where we list our action buttons

Widget getMenu(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 120,
          child: DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
        ),
        ListTile(
          title: Text('New Image'),
          onTap: () {
            // Go to page
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Restart'),
          onTap: () {
            // Go to page
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Save'),
          onTap: () {
            // Go to page
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Show Outline'),
          onTap: () {
            // Go to page
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Show Original'),
          onTap: () {
            // Go to page
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}