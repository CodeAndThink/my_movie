class TriviaQuestion {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  TriviaQuestion({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      question: json['question'] as String,
      correctAnswer: json['correct_answer'] as String,
      incorrectAnswers: List<String>.from(json['incorrect_answers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'difficulty': difficulty,
      'category': category,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
    };
  }
}
