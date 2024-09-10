import 'package:bloc/bloc.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_genre_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_genre_state.dart';

class MainFetchMovieGenreBloc
    extends Bloc<MainFetchMovieGenreEvent, MainFetchMovieGenreState> {
  final MovieRepository _movieRepository;
  MainFetchMovieGenreBloc(this._movieRepository)
      : super(FetchMovieGenresInitial()) {
    on<FetchMovieGenres>(_onFetchMovieGenres);
  }

  Future<void> _onFetchMovieGenres(
      FetchMovieGenres event, Emitter<MainFetchMovieGenreState> emit) async {
    emit(FetchMovieGenresLoading());
    try {
      final genres = await _movieRepository.getGenreMovies();
      final currentState = state;
      if (currentState is FetchMovieGenresLoaded) {
        if (currentState.isEqual(genres)) {
          return;
        }
      }
      emit(FetchMovieGenresLoaded(genres));
    } catch (e) {
      emit(FetchMovieGenresError('Failed to load genres of movies'));
    }
  }
}
