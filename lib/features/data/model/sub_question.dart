import 'package:quiztest/features/data/model/sub_answer.dart';

class Questions {
  String? _question;
  Answers? _answers;
  dynamic _questionImageUrl;
  String? _correctAnswer;
  num? _score;

  Questions({
    String? question,
    Answers? answers,
    dynamic questionImageUrl,
    String? correctAnswer,
    num? score,
  })  : _question = question,
        _answers = answers,
        _questionImageUrl = questionImageUrl,
        _correctAnswer = correctAnswer,
        _score = score;

  Questions.fromJson(Map<String, dynamic> json) {
    _question = json['question'];
    _answers = json['answers'] != null ? Answers.fromJson(json['answers']) : null;
    _questionImageUrl = json['questionImageUrl'];
    _correctAnswer = json['correctAnswer'];
    _score = json['score'];
  }

  String? get question => _question;
  Answers? get answers => _answers;
  dynamic get questionImageUrl => _questionImageUrl;
  String? get correctAnswer => _correctAnswer;
  num? get score => _score;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = _question;
    if (_answers != null) {
      data['answers'] = _answers!.toJson();
    }
    data['questionImageUrl'] = _questionImageUrl;
    data['correctAnswer'] = _correctAnswer;
    data['score'] = _score;
    return data;
  }
}
