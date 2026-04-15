import 'package:flutter/material.dart';

void main() {
  runApp(NGOConnectApp());
}

class NGOConnectApp extends StatelessWidget {
  const NGOConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO Connect',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Map<String, String>> items = [
    {
      'title': 'Winter Clothes',
      'description': 'Warm jackets and blankets.',
      'status': 'Pending',
    },
    {
      'title': 'Books for Children',
      'description': 'Storybooks and coloring books.',
      'status': 'Collected',
    },
  ];

  void _addDonation(String title, String description) {
    setState(() {
      items.add({
        'title': title,
        'description': description,
        'status': 'Pending',
      });
    });
  }

  void _markAsCollected(int index) {
    setState(() {
      items[index]['status'] = 'Collected';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = <Widget>[
      ListingsScreen(items: items, onCollected: _markAsCollected),
      PostDonationScreen(onSubmit: _addDonation),
      MessagesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('NGO Connect'),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Listings'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Donate'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ListingsScreen extends StatelessWidget {
  final List<Map<String, String>> items;
  final Function(int) onCollected;

  const ListingsScreen(
      {super.key, required this.items, required this.onCollected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        bool isPending = items[index]['status'] == 'Pending';
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text(items[index]['title']!),
            subtitle: Text(items[index]['description']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(items[index]['status']!),
                if (isPending)
                  IconButton(
                    icon: Icon(Icons.check_circle, color: Colors.green),
                    tooltip: 'Mark as Collected',
                    onPressed: () => onCollected(index),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PostDonationScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Function(String, String) onSubmit;

  PostDonationScreen({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Item Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onSubmit(titleController.text, descriptionController.text);
              titleController.clear();
              descriptionController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Donation submitted!')),
              );
            },
            child: Text('Post Donation'),
          ),
        ],
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {'sender': 'NGO Hope', 'text': 'Is the item still available?'},
    {'sender': 'You', 'text': 'Yes, you can collect it tomorrow.'},
  ];

  MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message['sender'] == 'You';
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: isMe ? Colors.teal[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message['sender']!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(message['text']!),
              ],
            ),
          ),
        );
      },
    );
  }
}
