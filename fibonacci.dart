import 'package:flutter/material.dart';

void main() {
  runApp(FibonacciApp());
}

class FibonacciApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fibonacci Sequence Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FibonacciGenerator(),
    );
  }
}

class FibonacciGenerator extends StatefulWidget {
  @override
  _FibonacciGeneratorState createState() => _FibonacciGeneratorState();
}

class _FibonacciGeneratorState extends State<FibonacciGenerator> {
  final TextEditingController _termsController = TextEditingController();
  String _result = "";

  void _generateFibonacci() {
    setState(() {
      int? terms = int.tryParse(_termsController.text);
      if (terms == null || terms <= 0) {
        _result = "Invalid Input. Please enter a positive integer.";
      } else {
        _result = _getFibonacciSequence(terms).join(", ");
      }
    });
  }

  List<int> _getFibonacciSequence(int terms) {
    List<int> sequence = [];
    int a = 0, b = 1;

    for (int i = 0; i < terms; i++) {
      sequence.add(a);
      int next = a + b;
      a = b;
      b = next;
    }

    return sequence;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fibonacci Sequence Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _termsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Number of Terms',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateFibonacci,
              child: Text('Generate Fibonacci Sequence'),
            ),
            SizedBox(height: 16),
            Text(
              'Fibonacci Sequence:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _result,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
