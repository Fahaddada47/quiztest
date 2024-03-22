import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiztest/features/data/data_sources/ques_ans_controller.dart';
import 'package:quiztest/features/presentation/pages/question_answer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int currentScore = 0;
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
      print('Loaded high score: $highScore');
    });
  }

  Future<void> _updateHighScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentHighScore = prefs.getInt('highScore') ?? 0;
    print('Current high score: $currentHighScore');
    if (score >= currentHighScore) {
      setState(() {
        highScore = score;
        print('New high score: $highScore');
      });
      await prefs.setInt('highScore', score);
      print('High score updated.');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('TEST YOUR IQ'),
            Text('Current Score: $currentScore'),
            Text('High Score: $highScore'),
            ElevatedButton(
              onPressed: () async {
                Get.put(QuestionAnswerController());
                final newScore = await Get.to<int>(QuestionAnswerScreen());
                if (newScore != null) {
                  setState(() {
                    currentScore = newScore;
                    if (currentScore > highScore) {
                      _updateHighScore(currentScore);
                    }
                  });
                }
              },
              child: const Text('Start New Game'),
            ),

          ],
        ),
      ),
    );
  }
}
