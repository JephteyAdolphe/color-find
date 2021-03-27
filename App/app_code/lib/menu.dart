import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as globals;

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
          title: Text('Load Image 0'),
          onTap: () {
            // Go to page
            globals.fetchFileData("0");
            globals.clear();
            //print(globals.loadedImage.title);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Load Image 1'),
          onTap: () {
            // Go to page
            globals.fetchFileData("1");
            globals.clear();
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Restart'),
          onTap: () {
            // Go to page
            globals.clear();
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Save & Clear'),
          onTap: () {
            // Go to page
            globals.saveImage();
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Save & Clear'),
                content: Text('Cleared and saved, Check Android: data/com.exapmle.app_code'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: new Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        ListTile(
          title: Text('Show Outline'),
          onTap: () {
            // Go to page
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Show Outline'),
                content: Text('Not implemented.'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: new Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        ListTile(
          title: Text('Show Original'),
          onTap: () {
            // Go to page
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Show Original'),
                content: Text('Not implemented.'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: new Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        ListTile(
          title: Text('commandx'),
          onTap: () {
            // Go to page
            globals.printCanvasSize();
          },
        ),
      ],
    ),
  );
}
