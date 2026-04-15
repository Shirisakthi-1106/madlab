import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterApp(),
    );
  }
}

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

enum Format { decimal, hexadecimal, octal }

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;
  Format _format = Format.decimal;

  void _increment() {
    setState(() {
      int base = _getBase();
      _counter = (_counter + 1) % base;
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  void _toggleFormat() {
    setState(() {
      _format = Format.values[(_format.index + 1) % Format.values.length];
      _counter = 0; // Optional: Reset on format change
    });
  }

  int _getBase() {
    switch (_format) {
      case Format.hexadecimal:
        return 16;
      case Format.octal:
        return 8;
      case Format.decimal:
      default:
        return 10;
    }
  }

  String get _formattedCounter {
    switch (_format) {
      case Format.hexadecimal:
        return _counter.toRadixString(16).toUpperCase(); // A, B, C...
      case Format.octal:
        return _counter.toRadixString(8);
      case Format.decimal:
      default:
        return _counter.toString();
    }
  }

  String get _formatLabel {
    switch (_format) {
      case Format.hexadecimal:
        return "Hexadecimal";
      case Format.octal:
        return "Octal";
      case Format.decimal:
      default:
        return "Decimal";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Base-Wrapped Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current Format: $_formatLabel',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              _formattedCounter,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _increment,
              child: const Text("Increment"),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _toggleFormat,
              child: const Text("Toggle Format"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _reset,
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
