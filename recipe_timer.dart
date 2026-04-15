// ======================================================================
// HOW TO RUN:
// 1. Add to pubspec.yaml:
// dependencies:
//   flutter:
//     sdk: flutter
//   circular_countdown_timer: ^2.0.0
//
// 2. Run 'flutter pub get'
// 3. Copy this into lib/main.dart
// ======================================================================

import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Timer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RecipeHomePage(),
    );
  }
}

class RecipeHomePage extends StatefulWidget {
  const RecipeHomePage({super.key});

  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  final TextEditingController _timeController = TextEditingController();
  final CountDownController _timerController = CountDownController();

  bool _isTimerRunning = false;
  bool _isPaused = false;
  int _duration = 0;

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_timeController.text.isEmpty) return;

    setState(() {
      _duration = int.parse(_timeController.text) * 60;
      _isTimerRunning = true;
      _isPaused = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerController.start();
    });
  }

  void _togglePauseResume() {
    if (_isPaused) {
      _timerController.resume();
    } else {
      _timerController.pause();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      _isPaused = false;
      _duration = 0;
      _timeController.clear();
    });
    _timerController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Timer')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isTimerRunning)
              TextField(
                controller: _timeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cooking Time (minutes)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.timer),
                ),
              ),
            const SizedBox(height: 40),
            if (_duration > 0)
              CircularCountDownTimer(
                duration: _duration,
                initialDuration: 0,
                controller: _timerController,
                width: 200,
                height: 200,
                ringColor: Colors.grey[300]!,
                fillColor: Colors.blueAccent,
                backgroundColor: Colors.transparent,
                strokeWidth: 20,
                strokeCap: StrokeCap.round,
                isTimerTextShown: true,
                isReverse: true,
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                onComplete: () {
                  setState(() {
                    _isTimerRunning = false;
                    _duration = 0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cooking Complete!')),
                  );
                },
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isTimerRunning)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                    onPressed: _startTimer,
                  ),
                if (_isTimerRunning) ...[
                  ElevatedButton.icon(
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(_isPaused ? 'Resume' : 'Pause'),
                    onPressed: _togglePauseResume,
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    onPressed: _resetTimer,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}