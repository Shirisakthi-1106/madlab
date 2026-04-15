import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuizScreen(),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int answerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.answerIndex,
  });
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [
    Question(
      questionText: "What is Flutter?",
      options: ["SDK", "Language", "IDE", "Game Engine"],
      answerIndex: 0,
    ),
    Question(
      questionText: "Who developed Flutter?",
      options: ["Google", "Apple", "Facebook", "Amazon"],
      answerIndex: 0,
    ),
    Question(
      questionText: "Which language is used in Flutter?",
      options: ["Java", "Dart", "Kotlin", "Swift"],
      answerIndex: 1,
    ),
  ];

  int currentQuestion = 0;
  int score = 0;
  int timeLeft = 10;
  Timer? timer;

  void startTimer() {
    timeLeft = 10;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft == 0) {
          moveToNext();
        }
      });
    });
  }

  void moveToNext() {
    timer?.cancel();
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
      startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: score, total: questions.length),
        ),
      );
    }
  }

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestion].answerIndex) {
      score++;
    }
    moveToNext();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text("Time: $timeLeft")),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Q${currentQuestion + 1}: ${question.questionText}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ...List.generate(question.options.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ElevatedButton(
                onPressed: () => answerQuestion(index),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blue.shade100,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text("${index + 1}"),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.options[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  ResultScreen({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Score:",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "$score / $total",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Restart"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => QuizScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}