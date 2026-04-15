import 'package:flutter/material.dart';

void main() {
  runApp(FactorialApp());
}

class FactorialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Factorial Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FactorialCalculator(),
    );
  }
}

class FactorialCalculator extends StatefulWidget {
  @override
  _FactorialCalculatorState createState() => _FactorialCalculatorState();
}

class _FactorialCalculatorState extends State<FactorialCalculator> {
  final TextEditingController _numberController = TextEditingController();
  String _result = "";

  void _calculateFactorial() {
    setState(() {
      int? number = int.tryParse(_numberController.text);
      if (number == null || number < 0) {
        _result = "Invalid Input";
      } else {
        _result = _factorial(number).toString();
      }
    });
  }

  int _factorial(int n) {
    if (n == 0 || n == 1) return 1;
    return n * _factorial(n - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factorial Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter a Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateFactorial,
              child: Text('Calculate Factorial'),
            ),
            SizedBox(height: 16),
            Text(
              'Factorial: $_result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
