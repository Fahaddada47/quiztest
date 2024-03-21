class QuestionModel {
  final String question;
  final String correctAnswer;
  final Map<String, String> answers;
  final String? questionImageUrl;
  final int score;

  QuestionModel({
    required this.question,
    required this.correctAnswer,
    required this.answers,
    this.questionImageUrl,
    required this.score,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      answers: Map<String, String>.from(json['answers'] ?? {}),
      questionImageUrl: json['questionImageUrl'],
      score: json['score'] ?? 0,
    );
  }
}
