import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Big Text',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Big Text'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const textFieldPadding = EdgeInsets.all(8.0);
const textFieldTextStyle = TextStyle(fontSize: 30.0);
const String hintText = 'Start typing. Try zooming...';
const double MaxFontSize = 200;
const double MinFontSize = 10;

class _MyHomePageState extends State<MyHomePage> {
  double _scale = 1.0;

  final TextEditingController _controller = TextEditingController();
  final GlobalKey _textFieldKey = GlobalKey();

  double _fontSize = -1;

  @override
  Widget build(BuildContext context) {
    double getFontSize() {
      double _updatedFontSize = _fontSize * _scale;
      if (_updatedFontSize < MinFontSize) return MinFontSize;
      if (_updatedFontSize > MaxFontSize) return MaxFontSize;
      return _updatedFontSize;
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
          setState(() {
            _scale = scaleDetails.scale;
          });
        },
        onScaleEnd: (ScaleEndDetails scaleDetails) {
          setState(() {
            _fontSize = _scale * _fontSize;
            _scale = 1;
          });
        },
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: LayoutBuilder(builder: (context, size) {
                TextSpan text = new TextSpan(
                  text: _controller.text,
                  style: textFieldTextStyle,
                );

                TextPainter tp = new TextPainter(
                  text: text,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                );
                tp.layout(maxWidth: size.maxWidth);

                if (_fontSize == -1) {
                  _fontSize = calculateAutoscaleFontSize(
                      hintText, textFieldTextStyle, MinFontSize, size.maxWidth);
                }

                return TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    key: _textFieldKey,
                    style: textFieldTextStyle.copyWith(fontSize: getFontSize()),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(fontSize: _fontSize),
                      border: InputBorder.none,
                      fillColor: Colors.orange,
                      filled: true,
                      //contentPadding: textFieldPadding,
                    ));
              }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Clear text',
        child: Icon(Icons.clear),
        onPressed: () {
          _controller.clear();
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

double calculateAutoscaleFontSize(
    String text, TextStyle style, double startFontSize, double maxWidth) {
  final textPainter = TextPainter(textDirection: TextDirection.ltr);

  var currentFontSize = startFontSize;

  for (var i = 0; i < 100; i++) {
    // limit max iterations to 100
    final nextFontSize = currentFontSize + 1;
    final nextTextStyle = style.copyWith(fontSize: nextFontSize);
    textPainter.text = TextSpan(text: text, style: nextTextStyle);
    textPainter.layout();
    if (textPainter.width >= maxWidth) {
      break;
    } else {
      currentFontSize = nextFontSize;
      // continue iteration
    }
  }
  return currentFontSize;
}
