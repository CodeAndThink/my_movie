import 'package:bloc/bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';

//BloC
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _movieRepository;

  MovieBloc(this._movieRepository) : super(MovieInitial()) {
    on<LoadMoviesByCategories>(_onLoadMovieByCategories);
    on<LoadMovieGenres>(_onLoadMovieGenres);
    on<LoadMovieById>(_onLoadMovieById);
    on<LoadTrailerMovies>(_onLoadTrailerMovies);
    on<SearchMovies>(_searchMovies);
    on<LoadMovieByGenre>(_onLoadMovieByGenre);
  }

  Future<void> _onLoadMovieByCategories(
      LoadMoviesByCategories event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response =
          await _movieRepository.getMovieByCategories(event.category, event.page);
      final List<dynamic> movieJsonList = response.data['results'];
      final List<Movie> movies =
          movieJsonList.map((json) => Movie.fromJson(json)).toList();

      final currentState = state;
      if (currentState is MovieLoaded) {
        emit(MovieLoaded(
          popularMovies:
              event.category == 'popular' ? movies : currentState.popularMovies,
          topRatedMovies: event.category == 'top_rated'
              ? movies
              : currentState.topRatedMovies,
          nowPlayingMovies: event.category == 'now_playing'
              ? movies
              : currentState.nowPlayingMovies,
          upcomingMovies: event.category == 'upcoming'
              ? movies
              : currentState.upcomingMovies,
        ));
      } else {
        emit(MovieLoaded(
          popularMovies: event.category == 'popular' ? movies : [],
          topRatedMovies: event.category == 'top_rated' ? movies : [],
          nowPlayingMovies: event.category == 'now_playing' ? movies : [],
          upcomingMovies: event.category == 'upcoming' ? movies : [],
        ));
      }
    } catch (e) {
      emit(MovieError('Failed to load ${event.category} movies'));
    }
  }

  Future<void> _onLoadMovieGenres(
      LoadMovieGenres event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response = await _movieRepository.getGenreMovies();
      final genres = response.data['genres'];
      final currentState = state;
      if (currentState is MovieGenresLoaded) {
        if (currentState.isEqual(genres)) {
          return;
        }
      }
      emit(MovieGenresLoaded(genres));
    } catch (e) {
      emit(MovieError('Failed to load genres of movies'));
    }
  }

  Future<void> _onLoadTrailerMovies(
      LoadTrailerMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response = await _movieRepository.getMovieTrailer(event.trailerId);
      final trailers = response.data['results'];
      emit(TrailerLoaded(trailers));
    } catch (e) {
      emit(MovieError('Failed to load trailer of this movie'));
    }
  }

  Future<void> _searchMovies(
      SearchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response = await _movieRepository.searchMovie(event.searchKey);
      final movies = response.data['results'];
      emit(SearchLoaded(movies));
    } catch (e) {
      emit(MovieError('Failed to search movies'));
    }
  }

  Future<void> _onLoadMovieById(
      LoadMovieById event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response = await _movieRepository.getMovieDetails(event.movieId);
      final movieJson = response.data;
      final Movie movie = Movie.fromJson(movieJson);
      final trailerResponse =
          await _movieRepository.getMovieTrailer(event.movieId);

      final creditsResponse =
          await _movieRepository.getMovieCredits(event.movieId);
      final credits = creditsResponse.data;
      final trailers = trailerResponse.data['results'];
      emit(SearchByIdLoaded(movie, trailers, credits));
    } catch (e) {
      emit(MovieError('Failed to find movies'));
    }
  }

  Future<void> _onLoadMovieByGenre(
      LoadMovieByGenre event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response = await _movieRepository.discoverMoviesByGenre(
          event.genreId, event.page);
      final movies = response.data['results'];
      emit(SearchByMovieGenre(movies));
    } catch (e) {
      emit(MovieError('Failed to find movie by genre'));
    }
  }
}
