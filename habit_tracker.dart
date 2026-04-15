// ======================================================================
// HOW TO RUN:
// 1. Create a new Flutter project.
// 2. Replace the code in lib/main.dart with this code.
// 3. Run the app.
// ======================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Habit> habits = [];
  Map<DateTime, Map<String, bool>> dailyTracking = {};
  final TextEditingController _habitController = TextEditingController();

  @override
  void dispose() {
    _habitController.dispose();
    super.dispose();
  }

  void addHabit(String name) {
    setState(() {
      habits.add(Habit(name: name));
    });
  }

  void toggleHabit(String habitName, DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    dailyTracking[dateKey] ??= {};
    dailyTracking[dateKey]![habitName] =
    !(dailyTracking[dateKey]![habitName] ?? false);
    setState(() {}); // Trigger UI update
  }

  int getStreak(String habitName) {
    final dates = dailyTracking.keys.toList()..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      if (date.isBefore(
          DateTime(currentDate.year, currentDate.month, currentDate.day)) &&
          (i > 0 && dates[i - 1].difference(date).inDays > 1)) {
        break;
      }
      if (dailyTracking[date]?[habitName] == true) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return HabitCard(
                  habitName: habit.name,
                  dailyTracking: dailyTracking,
                  toggleHabit: toggleHabit,
                  getStreak: getStreak,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _habitController,
                    decoration: const InputDecoration(
                      labelText: 'New Habit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_habitController.text.isNotEmpty) {
                      addHabit(_habitController.text);
                      _habitController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  final String habitName;
  final Map<DateTime, Map<String, bool>> dailyTracking;
  final Function(String, DateTime) toggleHabit;
  final int Function(String) getStreak;

  const HabitCard({
    super.key,
    required this.habitName,
    required this.dailyTracking,
    required this.toggleHabit,
    required this.getStreak,
  });

  @override
  Widget build(BuildContext context) {
    final streak = getStreak(habitName);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  habitName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text('🔥 $streak'),
                  backgroundColor: Colors.orange[100],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Daily Tracking:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final date = DateTime.now().subtract(Duration(days: 6 - index));
                final isCompleted = dailyTracking[DateTime(
                  date.year,
                  date.month,
                  date.day,
                )]?[habitName] ?? false;
                return GestureDetector(
                  onTap: () => toggleHabit(habitName, date),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.green : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('E').format(date)[0],
                        style: TextStyle(
                          color: isCompleted ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class Habit {
  final String name;

  Habit({required this.name});
}