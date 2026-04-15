import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grid Calculator',
      theme: ThemeData.dark(),
      home: CalculatorWithButtons(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorWithButtons extends StatefulWidget {
  @override
  _CalculatorWithButtonsState createState() => _CalculatorWithButtonsState();
}

class _CalculatorWithButtonsState extends State<CalculatorWithButtons> {
  String _expression = "";
  String _result = "";

  final List<String> _buttons = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    'C',
    '+',
    '=',
  ];

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = "";
        _result = "";
      } else if (buttonText == '=') {
        _evaluateExpression();
      } else {
        _expression += buttonText;
      }
    });
  }

  void _evaluateExpression() {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      _result = eval.toString();
    } catch (e) {
      _result = "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grid Calculator")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_expression, style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                Text(_result,
                    style:
                    TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: _buttons.length,
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final btnText = _buttons[index];
                final isOperator = ['/', '*', '-', '+', '='].contains(btnText);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isOperator ? Colors.orange : Colors.grey[850],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20),
                  ),
                  onPressed: () => _onButtonPressed(btnText),
                  child: Text(btnText, style: TextStyle(fontSize: 24)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
