import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as globals;
import 'form_screen.dart';
import 'dart:math';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  static const _menuTitles = [
    '', //keep for proper spacing
    'Load Image 0',
    'Load Image 1',
    'Restart',
    'Save Image',
    'Save Image and Clear Canvas',
    'Show Outline',
    'Show Original',
    'commandx',
    'Survey Form',
    /*'Declarative Style',
    'Premade Widgets',
    'Stateful Hot Reload',
    'Native Performance',
    'Great Community',*/
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, //Colors.greenAccent[100],
      child: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            //_buildFlutterLogo(),
            _buildContent(),
          ],
        ),
      ),
    );
    /*
    return Container(
      color: Colors.white, //Colors.greenAccent[100],
      child: Stack(
        fit: StackFit.expand,
        children: [
          //_buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
     */
  }

  //Widget _buildFlutterLogo() {};

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildGetStartedButton(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      //buffer
      if (i == 0) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: Text(
              _menuTitles[i],
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18, //previously 24
                fontWeight: FontWeight.w800,
                fontFamily: 'BalooBhai',
              ),
            ),
          ),
        );
      }
      //Load Image 0
      if (i == 1) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
              onTap: () {
                globals.fetchFileData("0");
                globals.clear();
                //print(globals.loadedImage.title);
                Navigator.pop(context);
              },
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //Load Image 1
      if (i == 2) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
              onTap: () {
                globals.fetchFileData("1");
                globals.clear();
                //print(globals.loadedImage.title);
                Navigator.pop(context);
              },
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //Restart
      if (i == 3) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
              onTap: () {
                // Go to page
                globals.clear();
                Navigator.pop(context);
              },
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //Save Image
      if (i == 4) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
              onTap: () {
                // Go to page
                globals.saveImage();
                showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text('Save'),
                    content: Text('Saved, Check Android: data/com.exapmle.app_code/Files/ColorFind'),
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
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //Save Image and Clear Canvas
      if (i == 5) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
              onTap: () {
                // Go to page
                globals.saveImage(clearRecords: true);
                showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text('Save & Clear'),
                    content: Text('Saved and cleared, Check Android: data/com.exapmle.app_code/Files/ColorFind'),
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
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //Show Outline
      if (i == 6) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
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
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //Show Original
      if (i == 7) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
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
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //commandx
      if (i == 8) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
              onTap: () {
                // Go to page
                globals.printCanvasSize();
              },
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
      //Survey Form
      if (i == 9) {
        listItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
            child: InkResponse(
              radius: 400,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormScreen()),
                );
              },
              child: Text(
                _menuTitles[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18, //previously 24
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BalooBhai',
                ),
              ),
            ),
          ),
        );
      }
    }
    return listItems;
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: RaisedButton(
          shape: const StadiumBorder(),
          color: Colors.deepPurpleAccent[100],
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          onPressed: () {
            var rng = new Random();
            String x = rng.nextInt(8).toString();
            globals.fetchFileData(x);
            globals.clear();
            //print(globals.loadedImage.title);
            Navigator.pop(context);
          },
          child: const Text(
            'New Picture!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'BalooBhai'
            ),
          ),
        ),
      ),
    );
  }
}

//PREVIOUS MENU:

// Hamburger Menu where we list our action button*/

/*Widget getMenu(BuildContext context) {
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
          title: Text('Save Image'),
          onTap: () {
            // Go to page
            globals.saveImage();
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Save'),
                content: Text('Saved, Check Android: data/com.exapmle.app_code/Files/ColorFind'),
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
          title: Text('Save Image & clear canvas'),
          onTap: () {
            // Go to page
            globals.saveImage(clearRecords: true);
            showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Save & Clear'),
                content: Text('Saved and cleared, Check Android: data/com.exapmle.app_code/Files/ColorFind'),
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
        ListTile(
          title: Text('Survey Form'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormScreen()),
            );
          },
        ),
      ],
    ),
  );
}
*/