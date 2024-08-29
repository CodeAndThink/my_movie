import 'package:my_movie/data/models/trivia_question.dart';

abstract class QuizzState {
  @override
  List<Object> get props => [];
}

class QuizzInitial extends QuizzState {}

class QuizzLoading extends QuizzState {}

class QuizzLoaded extends QuizzState {
  final List<TriviaQuestion> listQuestions;

  QuizzLoaded(this.listQuestions);

  @override
  List<Object> get props => [listQuestions];
}

class QuizzLoadedFailure extends QuizzState {
  final String message;

  QuizzLoadedFailure(this.message);

  @override
  List<Object> get props => [message];
}
