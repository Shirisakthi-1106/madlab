import 'package:flutter/material.dart';

void main() {
  runApp(EcoHabitTrackerApp());
}

class EcoHabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoHabit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HabitListScreen(),
    );
  }
}

class Habit {
  String name;
  String description;
  int frequency; // 1 for daily, 7 for weekly
  bool completedToday;

  Habit({
    required this.name,
    required this.description,
    required this.frequency,
    this.completedToday = false,
  });
}

class HabitListScreen extends StatefulWidget {
  @override
  _HabitListScreenState createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  List<Habit> habits = [
    Habit(
        name: 'Use reusable bags',
        description: 'Avoid plastic bags',
        frequency: 1),
    Habit(
        name: 'Save electricity',
        description: 'Turn off lights when not in use',
        frequency: 1),
  ];

  void toggleCompletion(int index) {
    setState(() {
      habits[index].completedToday = !habits[index].completedToday;
    });
  }

  void _showAddHabitDialog() {
    String name = '';
    String description = '';
    int frequency = 1; // Default to daily

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Habit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Habit Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Frequency: '),
                  DropdownButton<int>(
                    value: frequency,
                    items: [
                      DropdownMenuItem(
                        child: Text('Daily'),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text('Weekly'),
                        value: 7,
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          frequency = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (name.trim().isNotEmpty && description.trim().isNotEmpty) {
                  setState(() {
                    habits.add(Habit(
                      name: name,
                      description: description,
                      frequency: frequency,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoHabit Tracker'),
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return ListTile(
            title: Text(habit.name),
            subtitle: Text(
                '${habit.description} (${habit.frequency == 1 ? "Daily" : "Weekly"})'),
            trailing: Checkbox(
              value: habit.completedToday,
              onChanged: (value) {
                toggleCompletion(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
