import 'package:flutter/material.dart';
import 'package:quiztest/features/data/model/QuestionModel.dart';

class QuestionPageHeader extends StatelessWidget {
  const QuestionPageHeader({
    super.key,
    required this.currentScore,
    required int timerSeconds,
    required this.currentIndex,
    required this.questions,
  }) : _timerSeconds = timerSeconds;

  final int currentScore;
  final int _timerSeconds;
  final int currentIndex;
  final List<QuestionModel>? questions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ Row(
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
        ),],
    );
  }
}