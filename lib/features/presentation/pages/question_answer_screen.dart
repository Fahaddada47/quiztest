import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiztest/features/data/data_sources/ques_ans_controller.dart';
import 'package:quiztest/features/data/model/QuestionModel.dart';
import 'package:quiztest/features/presentation/widgets/alart_dialog.dart';
import 'package:quiztest/features/presentation/widgets/last_view.dart';
import 'package:quiztest/features/presentation/widgets/question_UI.dart';
import 'package:quiztest/features/presentation/widgets/question_page_header.dart';

class QuestionAnswerScreen extends StatefulWidget {
  const QuestionAnswerScreen({super.key});

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
  bool answersLocked = false;

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
        return alert_dialog();
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      setState(() {
        if (currentIndex < questions!.length - 1) {
          currentIndex++;
          _timerSeconds = 10;
          _startTimer();
          scoreCounted = false;
          answersLocked = false;
          if (selectedAnswers[currentIndex] == null) {
            selectedAnswers[currentIndex] = "";
            scoreCounted = true;
            currentScore -= questions![currentIndex].score;
          }
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

        selectedAnswers = Map<int, String?>.fromIterable(
          loadedQuestions,
          key: (question) => loadedQuestions.indexOf(question),
          value: (question) => "",
        );
      });
    }
  }

  void _onNextPressed() {
    _cancelTimer();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert_dialog();
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      if (selectedAnswers[currentIndex] == null) {
        selectedAnswers[currentIndex] = "";
        scoreCounted = true;
        currentScore -= questions![currentIndex].score;
      }
      _moveToNextQuestion();
      if (allQuestionsAnswered) {
        Get.back(result: currentScore);
      }
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
      return LastView(currentScore: currentScore);
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
            QuestionPageHeader(
                currentScore: currentScore,
                timerSeconds: _timerSeconds,
                currentIndex: currentIndex,
                questions: questions),
            const SizedBox(height: 16),
            QuestionUI(question: question),
            const SizedBox(height: 16),
            Text(
              'Score: ${question.score}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._buildAnswerList(question, selectedAnswer),
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


  List<Widget> _buildAnswerList(QuestionModel question, String selectedAnswer) {
    return question.answers.entries.map((entry) {
      final option = entry.key;
      final answer = entry.value;
      final bool isSelected = selectedAnswer == option;
      final bool isCorrectAnswer = question.correctAnswer == option;
      final answerColor =
      _getAnswerColor(question.correctAnswer, selectedAnswer);

      return RadioListTile<String>(
        title: Text(answer),
        value: option,
        groupValue: selectedAnswer,
        onChanged: answersLocked
            ? null
            : (value) {
          setState(() {
            selectedAnswers[currentIndex] = value;
            answersLocked = true;
          });
        },
        activeColor: Colors.red,
        tileColor: isSelected ? answerColor : null,
        secondary: isSelected && isCorrectAnswer
            ? Icon(Icons.check, color: Colors.green)
            : null,
        subtitle: isSelected
            ? (isCorrectAnswer
            ? null
            : Text(
          'Correct Answer: ${question.answers[question.correctAnswer]}',
          style: TextStyle(color: Colors.black),
        ))
            : null,
      );
    }).toList();
  }

  Color _getAnswerColor(String correctAnswer, String selectedAnswer) {
    if (selectedAnswer != correctAnswer) {
      return Colors.red;
    } else if (selectedAnswer == correctAnswer && !scoreCounted) {
      currentScore += questions![currentIndex].score;
      scoreCounted = true;
      return Colors.green;
    } else if (selectedAnswer == correctAnswer && scoreCounted) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }
}
