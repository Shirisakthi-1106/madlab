import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimatedContainer Demo',
      theme: ThemeData.dark(),
      home: AnimatedContainerExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnimatedContainerExample extends StatefulWidget {
  @override
  _AnimatedContainerExampleState createState() => _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  double _width = 100;
  double _height = 100;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  void _changeShape() {
    setState(() {
      _width = (_width == 100) ? 200 : 100;
      _height = (_height == 100) ? 200 : 100;
      _color = (_color == Colors.blue) ? Colors.red : Colors.blue;
      _borderRadius = (_borderRadius == BorderRadius.circular(8))
          ? BorderRadius.circular(50)
          : BorderRadius.circular(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AnimatedContainer")),
      body: Center(
        child: AnimatedContainer(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: _borderRadius,
          ),
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeShape,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
