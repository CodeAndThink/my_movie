import 'package:flutter_bloc/flutter_bloc.dart';
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
      final quizzs = await _quizzRepository.getQuizz(
          event.numberQuestions, event.diffQuestion, event.typeQuestion);
      emit(QuizzLoaded(quizzs));
    } catch (e) {
      emit(QuizzLoadedFailure(e.toString()));
    }
  }
}
