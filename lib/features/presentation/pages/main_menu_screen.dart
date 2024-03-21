import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiztest/features/data/data_sources/ques_ans_controller.dart';
import 'package:quiztest/features/presentation/pages/question_answer_screen.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title of the App'),
            ElevatedButton(
              onPressed: () {
                Get.put(QuestionAnswerController()); // Initialize the controller
                Get.toNamed('/question_answer');
              },
              child: Text('Start New Game'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to high score screen
              },
              child: Text('High Score'),
            ),
          ],
        ),
      ),
    );
  }
}
