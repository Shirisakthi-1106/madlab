//dependencies:
//  flutter:
//    sdk: flutter
//  fl_chart: ^0.70.2

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
  int frequency; // 1 = daily, 7 = weekly
  int totalCompletions;

  Habit({
    required this.name,
    required this.description,
    required this.frequency,
    this.totalCompletions = 0,
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
        name: 'Save electricity', description: 'Turn off lights', frequency: 1),
    Habit(name: 'Plant trees', description: 'Plant a tree', frequency: 7),
    Habit(
        name: 'Beach clean-up',
        description: 'Weekly beach clean-up',
        frequency: 7),
  ];

  int selectedFrequency = 1; // 1 = Daily by default

  void _showAddHabitDialog() {
    String name = '';
    String description = '';
    int frequency = 1;

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
              DropdownButton<int>(
                value: frequency,
                items: [
                  DropdownMenuItem(child: Text('Daily'), value: 1),
                  DropdownMenuItem(child: Text('Weekly'), value: 7),
                ],
                onChanged: (value) {
                  if (value != null) frequency = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && description.isNotEmpty) {
                  setState(() {
                    habits.add(Habit(
                        name: name,
                        description: description,
                        frequency: frequency));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  List<Habit> getFilteredHabits() {
    return habits
        .where((habit) => habit.frequency == selectedFrequency)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Habit> filteredHabits = getFilteredHabits();

    return Scaffold(
      appBar: AppBar(
        title: Text('EcoHabit Tracker'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              setState(() {
                selectedFrequency = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text('Daily')),
              PopupMenuItem(value: 7, child: Text('Weekly')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredHabits.length,
              itemBuilder: (context, index) {
                final habit = filteredHabits[index];
                return ListTile(
                  title: Text(habit.name),
                  subtitle: Text(
                      '${habit.description}\nCompletions: ${habit.totalCompletions}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        habit.totalCompletions++;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < filteredHabits.length) {
                            return Text(filteredHabits[index].name,
                                style: TextStyle(fontSize: 10));
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                  barGroups: filteredHabits.asMap().entries.map((entry) {
                    int index = entry.key;
                    Habit habit = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: habit.totalCompletions.toDouble(),
                          width: 16,
                          color: Colors.green,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
