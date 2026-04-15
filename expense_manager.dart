// ======================================================================
// HOW TO RUN:
// 1. Create new Flutter project
// 2. Replace lib/main.dart with this code
// dependencies:
//   flutter:
//     sdk: flutter
//   intl: ^0.19.0  # Add this line
// ======================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _transactions = [];
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _transactions.add({
          'amount': double.parse(_amountController.text),
          'category': _categoryController.text,
          'date': DateTime.now(),
        });
        _amountController.clear();
        _categoryController.clear();
      });
    }
  }

  double get _totalExpenses {
    return _transactions.fold(0, (sum, t) => sum + t['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Manager')),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Total Expenses',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(symbol: '₹').format(_totalExpenses),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final t = _transactions[index];
                return ListTile(
                  title: Text(t['category']),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(t['date'])),
                  trailing: Text(
                    '-₹${t['amount'].toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter amount' : null,
                  ),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category'),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter category' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addTransaction,
                    child: const Text('Add Expense'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}