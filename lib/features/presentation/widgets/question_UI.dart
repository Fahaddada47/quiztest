import 'package:flutter/material.dart';
import 'package:quiztest/features/data/model/QuestionModel.dart';

class QuestionUI extends StatelessWidget {
  const QuestionUI({
    super.key,
    required this.question,
  });

  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        question.question ?? 'Question Not Available',
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: question.questionImageUrl != null
          ? Image.network(question.questionImageUrl!)
          : const SizedBox.shrink(),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}