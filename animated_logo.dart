import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Logo Demo',
      theme: ThemeData.dark(),
      home: AnimatedLogoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnimatedLogoScreen extends StatefulWidget {
  @override
  _AnimatedLogoScreenState createState() => _AnimatedLogoScreenState();
}

class _AnimatedLogoScreenState extends State<AnimatedLogoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward(); // Start animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: FadeTransition(
            opacity: _animation,
            child: FlutterLogo(size: 120),
          ),
        ),
      ),
    );
  }
}
