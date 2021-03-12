import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'globals.dart' as globals;

// Hamburger Menu where we list our action buttons

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget getMenu(BuildContext context) {
  bool loading = false;
  String loadingStr = "loading...";
  return Drawer(
    child: loading
        ? Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.all(16.0), child: Text(loadingStr)),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          )
        : ListView(
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

                  loading = true;
                  globals.fetchFileData("0");
                  sleep(const Duration(seconds: 5));
                  print("done");
                  loading = false;
                  //print(globals.loadedImage.title);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Load Image 1'),
                onTap: () {
                  // Go to page
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('loading....'),
                      content: Text('loading image 1'),
                    ),
                  );
                  globals.fetchFileData("1");
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Restart'),
                onTap: () {
                  // Go to page
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Restart....'),
                      content: Text('Reloading Canvas'),
                    ),
                  );
                  globals.records.clear();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Save & Clear'),
                onTap: () {
                  // Go to page
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Saving....'),
                      content: Text('Saving to: data/com.example.app_code'),
                    ),
                  );
                  globals.saveImage();
                  globals.records.clear();
                  Navigator.of(context, rootNavigator: true).pop();
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Save & Clear'),
                      content: Text('Completed'),
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
                  Navigator.pop(context);
                },
              ),
            ],
          ),
  );
}
