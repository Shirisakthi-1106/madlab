import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// flutter pub add fl_chart
void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FitnessTrackerScreen(),
    );
  }
}

class FitnessTrackerScreen extends StatefulWidget {
  @override
  _FitnessTrackerScreenState createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  int steps = 5000;
  double caloriesBurned = 200.5;
  List<FlSpot> workoutProgress = [
    FlSpot(1, 2),
    FlSpot(2, 3),
    FlSpot(3, 5),
    FlSpot(4, 7),
    FlSpot(5, 8),
  ];

  final TextEditingController workoutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Tracker")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daily Steps:"),
            Text("$steps steps", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text("Calories Burned:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("$caloriesBurned kcal", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text("Workout Progress:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: workoutController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter workout value",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final input = double.tryParse(workoutController.text);
                    if (input != null) {
                      setState(() {
                        double nextX = workoutProgress.isNotEmpty
                            ? workoutProgress.last.x + 1
                            : 1;
                        workoutProgress.add(FlSpot(nextX, input));
                        workoutController.clear();
                      });
                    }
                  },
                  child: Text("Add"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: workoutProgress,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
