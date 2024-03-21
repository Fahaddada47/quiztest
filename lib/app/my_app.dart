import 'package:flutter/material.dart';
import 'package:quiztest/features/presentation/pages/main_menu_screen.dart';
import 'package:get/get.dart';
import 'package:quiztest/features/presentation/pages/question_answer_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MainMenuScreen()),
        GetPage(name: '/question_answer', page: () => QuestionAnswerScreen()),
        
      ],
    );
  }
}