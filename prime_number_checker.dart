import 'package:flutter/material.dart';

void main() {
  runApp(PrimeCheckerApp());
}

class PrimeCheckerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prime Number Checker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PrimeChecker(),
    );
  }
}

class PrimeChecker extends StatefulWidget {
  @override
  _PrimeCheckerState createState() => _PrimeCheckerState();
}

class _PrimeCheckerState extends State<PrimeChecker> {
  final TextEditingController _numberController = TextEditingController();
  String _result = "";

  void _checkPrime() {
    setState(() {
      int? number = int.tryParse(_numberController.text);
      if (number == null || number < 2) {
        _result = "Invalid Input";
      } else {
        _result = _isPrime(number) ? "$number is a Prime Number" : "$number is Not a Prime Number";
      }
    });
  }

  bool _isPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i <= n ~/ 2; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prime Number Checker'),
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
              onPressed: _checkPrime,
              child: Text('Check Prime'),
            ),
            SizedBox(height: 16),
            Text(
              _result,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
