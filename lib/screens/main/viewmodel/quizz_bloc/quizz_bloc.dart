import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/trivia_question.dart';
import 'package:my_movie/data/repository/quizz_repository.dart';
import 'package:my_movie/screens/main/viewmodel/quizz_bloc/quizz_event.dart';
import 'package:my_movie/screens/main/viewmodel/quizz_bloc/quizz_state.dart';

class QuizzBloc extends Bloc<QuizzEvent, QuizzState> {
  final QuizzRepository _quizzRepository;

  QuizzBloc(this._quizzRepository) : super(QuizzInitial()) {
    on<LoadQuizz>(_onLoadQuizz);
  }

  Future<void> _onLoadQuizz(LoadQuizz event, Emitter<QuizzState> emit) async {
    emit(QuizzLoading());
    try {
      final response = await _quizzRepository.getQuizz(
          event.numberQuestions, event.diffQuestion, event.typeQuestion);
      final List<dynamic> quizzJson = response.data['results'];
      final List<TriviaQuestion> quizzs =
          quizzJson.map((json) => TriviaQuestion.fromJson(json)).toList();
      emit(QuizzLoaded(quizzs));
    } catch (e) {
      emit(QuizzLoadedFailure(e.toString()));
    }
  }
}
