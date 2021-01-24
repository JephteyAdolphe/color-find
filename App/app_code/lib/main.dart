import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

// Main app where everything will be displayed
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Color Find Prototype',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        // Home Page contains everything in it (side menu, canvas, colors)
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Color Find"),
          centerTitle: true,
        ),

        // drawer is a hamburger menu and TabList is the list of items (of type Drawer) that we create
        drawer: TabList(),

        // Body contains a list(children) of widgets which are the drawing canvas and color pallette, in that order
        body: Column(
          children: <Widget>[
            DrawingBlock(), // Need to make height/width of this dynamic so it fits to different screen sizes
            ColorPalette(),
          ],
        ));
  }
}

// Drawing block is where the coloring takes place
class DrawingBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 650,
        decoration: BoxDecoration(
            border: Border.all(width: 8),
            borderRadius: BorderRadius.circular(12)),

        // Color block is wrapped in a Container then scaffold to control the size of colors and scrolling ability
        child: Scaffold(
          body: ColorBlock(),
        ));
  }
}

// Scrollable color pallette
class ColorPalette extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,

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
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.red;
                }))),
            ElevatedButton(
                onPressed: null,
                child: null,
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.orange;
                }))),
            ElevatedButton(
                onPressed: null,
                child: null,
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.yellow;
                }))),
            ElevatedButton(
                onPressed: null,
                child: null,
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.green;
                }))),
            ElevatedButton(
                onPressed: null,
                child: null,
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.blue;
                }))),
            ElevatedButton(
                onPressed: null,
                child: null,
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.indigo;
                }))),
            ElevatedButton(
                onPressed: null,
                child: null,
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.purple;
                }))),
            ElevatedButton(
                onPressed: null,
                child: null,
                style: ButtonStyle(backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.blue;
                  return Colors.pink;
                }))),
          ],
        ));
  }
}

// Hamburger Menu where we list our action buttons
class TabList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class ColorBlock extends StatelessWidget {
  // Reuse this base widget on every page
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      child: Container(),
      // size: Size(500, 300),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset start = Offset(0, size.height / 2);
    Offset end = Offset(size.width, size.height / 2);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
