import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String answer;
  const AnswerButton({required this.answer});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle answer selection
        // Example: _controller.checkAnswer(answer);
      },
      child: Text(answer),
    );
  }
}