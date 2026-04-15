import 'package:flutter/material.dart';

void main() {
  runApp(ArmstrongCheckerApp());
}

class ArmstrongCheckerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Armstrong Number Checker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ArmstrongChecker(),
    );
  }
}

class ArmstrongChecker extends StatefulWidget {
  @override
  _ArmstrongCheckerState createState() => _ArmstrongCheckerState();
}

class _ArmstrongCheckerState extends State<ArmstrongChecker> {
  final TextEditingController _numberController = TextEditingController();
  String _result = "";

  void _checkArmstrong() {
    setState(() {
      int? number = int.tryParse(_numberController.text);
      if (number == null || number < 0) {
        _result = "Invalid Input";
      } else {
        _result = _isArmstrong(number)
            ? "$number is an Armstrong Number"
            : "$number is Not an Armstrong Number";
      }
    });
  }

  bool _isArmstrong(int n) {
    int sum = 0;
    int temp = n;
    int digits = n.toString().length;

    while (temp > 0) {
      int digit = temp % 10;
      sum += _toPower(digit, digits);
      temp ~/= 10;
    }
    return sum == n;
  }

  int _toPower(int base, int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Armstrong Number Checker'),
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
              onPressed: _checkArmstrong,
              child: Text('Check Armstrong'),
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
