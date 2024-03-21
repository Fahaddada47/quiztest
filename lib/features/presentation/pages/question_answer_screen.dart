import 'package:flutter/material.dart';
import 'package:quiztest/features/data/data_sources/ques_ans_controller.dart';
import 'package:get/get.dart';
import 'package:quiztest/features/data/model/QuestionModel.dart';


class QuestionAnswerScreen extends StatefulWidget {
  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  final QuestionAnswerController questionAnswerController =
  Get.put(QuestionAnswerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question/Answer Page'),
      ),
      body: FutureBuilder<List<QuestionModel>>(
        future: questionAnswerController.fetchQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No questions available.'),
            );
          } else {
            final List<QuestionModel> questions = snapshot.data!;
            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Column(
                  children: [
                    // Text(questions.length.toString()), // Display number of questions
                    ListTile(
                      title: Text(question.question ?? ''),
                      subtitle: Text(question.questionImageUrl ?? ''),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
