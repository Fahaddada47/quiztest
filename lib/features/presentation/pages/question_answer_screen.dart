import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiztest/features/data/data_sources/ques_ans_controller.dart';
import 'package:quiztest/features/data/model/QuestionModel.dart';

class QuestionAnswerScreen extends StatefulWidget {
  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  final QuestionAnswerController questionAnswerController =
  Get.put(QuestionAnswerController());

  List<QuestionModel>? questions;
  int currentIndex = 0;
  late Timer _timer;
  int _timerSeconds = 10;
  bool allQuestionsAnswered = false;
  Map<int, String?> selectedAnswers = {};
  int currentScore = 0;
  bool scoreCounted = false;

  @override
  void initState() {
    super.initState();
    _showProgressIndicator();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _showProgressIndicator() {
    Future.delayed(const Duration(seconds: 2), () {
      _startTimer();
      _loadQuestions();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _moveToNextQuestion();
        }
      });
    });
  }

  void _cancelTimer() {
    _timer.cancel();
  }

  void _moveToNextQuestion() {
    _cancelTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Loading next question..."),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close the dialog
      setState(() {
        if (currentIndex < questions!.length - 1) {
          currentIndex++;
          _timerSeconds = 10;
          _startTimer();
          scoreCounted = false;
        } else {
          allQuestionsAnswered = true;
        }
      });
    });
  }

  Future<void> _loadQuestions() async {
    final List<QuestionModel> loadedQuestions =
    await questionAnswerController.fetchQuestions();
    if (loadedQuestions.isNotEmpty) {
      setState(() {
        questions = loadedQuestions;
      });
    }
  }

  void _onNextPressed() {
    _cancelTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 30),
              Text("Loading next question..."),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close the dialog
      _moveToNextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question/Answer Page'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (allQuestionsAnswered) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Time\'s Up'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Time\'s Up!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Score: $currentScore',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final question = questions![currentIndex];
    final selectedAnswer = selectedAnswers[currentIndex] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question/Answer Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Score: $currentScore',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Time left: $_timerSeconds seconds',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Question ${currentIndex + 1}/${questions!.length}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                question.question ?? 'Question Not Available',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: question.questionImageUrl != null
                  ? Image.network(question.questionImageUrl!)
                  : SizedBox.shrink(),
              contentPadding: const EdgeInsets.all(16),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${question.score}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...question.answers.entries.map((entry) {
              final option = entry.key;
              final answer = entry.value;
              return RadioListTile<String>(
                title: Text(answer),
                value: option,
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswers[currentIndex] = value;
                  });
                },
                activeColor: selectedAnswer == option
                    ? _getAnswerColor(question.correctAnswer, option)
                    : null,
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onNextPressed,
              child: const Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAnswerColor(String correctAnswer, String selectedAnswer) {
    if (selectedAnswer == correctAnswer && !scoreCounted) {
      currentScore += questions![currentIndex].score;
      scoreCounted = true;
      return Colors.green;
    } else if (selectedAnswer != correctAnswer) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
