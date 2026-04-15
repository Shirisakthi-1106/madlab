// ======================================================================
// HOW TO RUN:
// 1. Create new Flutter project
// 2. Replace lib/main.dart with this code
// 3. No additional dependencies needed
// ======================================================================

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LibraryHomePage(),
    );
  }
}

class LibraryHomePage extends StatefulWidget {
  const LibraryHomePage({super.key});

  @override
  _LibraryHomePageState createState() => _LibraryHomePageState();
}

class _LibraryHomePageState extends State<LibraryHomePage> {
  final List<Map<String, dynamic>> _books = [];
  final List<Map<String, dynamic>> _members = [];
  final List<Map<String, dynamic>> _transactions = [];

  final _bookTitleController = TextEditingController();
  final _bookAuthorController = TextEditingController();
  final _memberNameController = TextEditingController();
  final _memberIdController = TextEditingController();
  final _transactionBookController = TextEditingController();
  final _transactionMemberController = TextEditingController();

  int _selectedIndex = 0;

  void _addBook() {
    setState(() {
      _books.add({
        'title': _bookTitleController.text,
        'author': _bookAuthorController.text,
        'available': true,
      });
      _bookTitleController.clear();
      _bookAuthorController.clear();
    });
  }

  void _addMember() {
    setState(() {
      _members.add({
        'name': _memberNameController.text,
        'id': _memberIdController.text,
      });
      _memberNameController.clear();
      _memberIdController.clear();
    });
  }

  void _issueBook() {
    final bookIndex = int.tryParse(_transactionBookController.text);
    final memberIndex = int.tryParse(_transactionMemberController.text);

    if (bookIndex == null || memberIndex == null ||
        bookIndex < 0 || bookIndex >= _books.length ||
        memberIndex < 0 || memberIndex >= _members.length) {
      _showMessage('Invalid book/member index');
      return;
    }

    if (!_books[bookIndex]['available']) {
      _showMessage('Book is already issued');
      return;
    }

    setState(() {
      _books[bookIndex]['available'] = false;
      _transactions.add({
        'book': _books[bookIndex]['title'],
        'member': _members[memberIndex]['name'],
        'date': DateTime.now(),
        'type': 'Issued',
      });
      _transactionBookController.clear();
      _transactionMemberController.clear();
    });

    _showMessage('Book issued successfully');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library Manager')),
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Members'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Transactions'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildBooksScreen();
      case 1:
        return _buildMembersScreen();
      case 2:
        return _buildTransactionsScreen();
      default:
        return Container();
    }
  }

  Widget _buildBooksScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _bookTitleController,
                decoration: const InputDecoration(labelText: 'Book Title'),
              ),
              TextField(
                controller: _bookAuthorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addBook,
                child: const Text('Add Book'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _books.length,
            itemBuilder: (context, index) {
              final book = _books[index];
              return ListTile(
                title: Text('$index. ${book['title']}'),
                subtitle: Text(book['author']),
                trailing: Text(book['available'] ? 'Available' : 'Issued'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMembersScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _memberNameController,
                decoration: const InputDecoration(labelText: 'Member Name'),
              ),
              TextField(
                controller: _memberIdController,
                decoration: const InputDecoration(labelText: 'Member ID'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addMember,
                child: const Text('Add Member'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _members.length,
            itemBuilder: (context, index) {
              final member = _members[index];
              return ListTile(
                title: Text('$index. ${member['name']}'),
                subtitle: Text(member['id']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _transactionBookController,
                decoration: const InputDecoration(
                  labelText: 'Book Index',
                  hintText: 'Enter book number from list',
                ),
              ),
              TextField(
                controller: _transactionMemberController,
                decoration: const InputDecoration(
                  labelText: 'Member Index',
                  hintText: 'Enter member number from list',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _issueBook,
                child: const Text('Issue Book'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return ListTile(
                title: Text(transaction['book']),
                subtitle: Text('${transaction['member']} - ${transaction['type']}'),
                trailing: Text(transaction['date'].toString().substring(0, 10)),
              );
            },
          ),
        ),
      ],
    );
  }
}