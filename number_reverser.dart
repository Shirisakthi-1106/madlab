import 'package:flutter/material.dart';

void main() {
  runApp(NumberReverserApp());
}

class NumberReverserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Reverser',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NumberReverser(),
    );
  }
}

class NumberReverser extends StatefulWidget {
  @override
  _NumberReverserState createState() => _NumberReverserState();
}

class _NumberReverserState extends State<NumberReverser> {
  final TextEditingController _numberController = TextEditingController();
  String _result = "";

  void _reverseNumber() {
    setState(() {
      String input = _numberController.text;
      if (int.tryParse(input) == null) {
        _result = "Invalid Input. Please enter a valid number.";
      } else {
        String reversed = input.split('').reversed.join('');
        _result = "Reversed Number: $reversed";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Reverser'),
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
              onPressed: _reverseNumber,
              child: Text('Reverse Number'),
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
