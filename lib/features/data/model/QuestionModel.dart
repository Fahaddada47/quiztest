class QuestionModel {
  final String question;
  final String? questionImageUrl;
  final Map<String, String> answers;

  QuestionModel({
    required this.question,
    this.questionImageUrl,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] ?? '',
      questionImageUrl: json['questionImageUrl'],
      answers: (json['answers'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString())),
    );
  }
}
