abstract class QuizzEvent {}

class LoadQuizz extends QuizzEvent {
  final int numberQuestions;
  final int typeQuestion;
  final int diffQuestion;

  LoadQuizz(this.numberQuestions, this.diffQuestion, this.typeQuestion);
}
