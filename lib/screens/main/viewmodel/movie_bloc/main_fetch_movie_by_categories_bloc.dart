import 'package:bloc/bloc.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_state.dart';

class MainFetchMovieByCategoriesBloc extends Bloc<
    MainFetchMovieByCategoriesEvent, MainFetchMovieByCategoriesState> {
  final MovieRepository _movieRepository;
  MainFetchMovieByCategoriesBloc(this._movieRepository)
      : super(MovieCategoriesInitial()) {
    on<FetchCommonMovieCategory>(_onFetchCommonMovieCategories);
  }

  Future<void> _onFetchCommonMovieCategories(FetchCommonMovieCategory event,
      Emitter<MainFetchMovieByCategoriesState> emit) async {
    emit(MovieCategoriesLoading());
    try {
      final movies = await _movieRepository.getMovieByCategories(
          event.category, event.page);

      final currentState = state;
      if (currentState is MovieCategoriesLoaded) {
        emit(MovieCategoriesLoaded(
          popularMovies: event.category == 'popular'
              ? [...currentState.popularMovies, ...movies]
              : currentState.popularMovies,
          topRatedMovies: event.category == 'top_rated'
              ? [...currentState.topRatedMovies, ...movies]
              : currentState.topRatedMovies,
          nowPlayingMovies: event.category == 'now_playing'
              ? [...currentState.nowPlayingMovies, ...movies]
              : currentState.nowPlayingMovies,
          upcomingMovies: event.category == 'upcoming'
              ? [...currentState.upcomingMovies, ...movies]
              : currentState.upcomingMovies,
        ));
      } else {
        emit(MovieCategoriesLoaded(
          popularMovies: event.category == 'popular' ? movies : [],
          topRatedMovies: event.category == 'top_rated' ? movies : [],
          nowPlayingMovies: event.category == 'now_playing' ? movies : [],
          upcomingMovies: event.category == 'upcoming' ? movies : [],
        ));
      }
    } catch (e) {
      emit(MovieCategoriesFalure(e.toString()));
    }
  }
}
