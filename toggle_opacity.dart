import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toggle Opacity',
      theme: ThemeData.dark(),
      home: ToggleOpacityDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToggleOpacityDemo extends StatefulWidget {
  @override
  _ToggleOpacityDemoState createState() => _ToggleOpacityDemoState();
}

class _ToggleOpacityDemoState extends State<ToggleOpacityDemo> {
  double _opacity = 1.0;

  void _toggleOpacity() {
    setState(() {
      _opacity = _opacity == 1.0 ? 0.0 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Toggle Opacity')),
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: FlutterLogo(size: 150),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleOpacity,
        child: Icon(Icons.visibility),
      ),
    );
  }
}
