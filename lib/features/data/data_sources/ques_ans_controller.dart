import 'package:dio/dio.dart';
import 'package:quiztest/entites/urls.dart';
import 'package:quiztest/features/data/data_sources/network_excutor.dart';
import 'package:quiztest/features/data/model/QuestionModel.dart';
import 'package:quiztest/features/data/repository/network_response.dart';
import 'package:get/get.dart';

class QuestionAnswerController extends GetxController {
  final NetworkExecutor _networkExecutor;
  List<QuestionModel> questionList = [];

  QuestionAnswerController() : _networkExecutor = NetworkExecutor(Dio());

  Future<List<QuestionModel>> fetchQuestions() async {
    try {
      final NetworkResponse response = await _networkExecutor.getRequest(
        path: Urls.verifyQuestion(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseBody = response.body;
        if (responseBody != null) {
          final List<dynamic>? questionJsonList = responseBody['questions'];
          if (questionJsonList != null) {
            // Clear the previous questions
            questionList.clear();

            // Parse each question JSON
            questionList = questionJsonList
                .map((json) => QuestionModel.fromJson(json))
                .toList();

            // Return the list of questions
            return questionList;
          } else {
            print('Questions not found in response body');
            return [];
          }
        } else {
          print('Response body is null');
          return [];
        }
      } else {
        print('Error fetching question: ${response.statusMessage}');
        return [];
      }
    } catch (e) {
      print('Exception while fetching question: $e');
      return [];
    }
  }
}
