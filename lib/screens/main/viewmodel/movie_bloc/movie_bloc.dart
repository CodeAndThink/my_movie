import 'package:bloc/bloc.dart';
import 'package:my_movie/data/models/actor.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _movieRepository;

  MovieBloc(this._movieRepository) : super(MovieInitial()) {
    on<LoadMovieById>(_onLoadMovieById);
    on<LoadTrailerMovies>(_onLoadTrailerMovies);
    on<SearchMovies>(_searchMovies);
    on<LoadMovieByGenre>(_onLoadMovieByGenre);
    on<RateMovie>(_onRateMovie);
    on<DeleteMovieRating>(_onDeleteMovieRating);
    on<LoadMovieByListId>(_onLoadMovieByListId);
    on<LoadPopularActor>(_onLoadPopularActor);
    on<SearchActor>(_onSearchActor);
  }

  Future<void> _onLoadTrailerMovies(
      LoadTrailerMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final trailers = await _movieRepository.getMovieTrailer(event.trailerId);
      emit(TrailerLoaded(trailers));
    } catch (e) {
      emit(MovieError('Failed to load trailer of this movie'));
    }
  }

  Future<void> _searchMovies(
      SearchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      if (event.searchKey.isNotEmpty) {
        final movies = await _movieRepository.searchMovie(event.searchKey);
        emit(SearchLoaded(movies));
      } else {
        emit(SearchCancel());
      }
    } catch (e) {
      emit(MovieError('Failed to search movies'));
    }
  }

  Future<void> _onLoadMovieById(
      LoadMovieById event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movie = await _movieRepository.getMovieDetails(event.movieId);
      final trailers = await _movieRepository.getMovieTrailer(event.movieId);
      final credits = await _movieRepository.getMovieCredits(event.movieId);
      emit(SearchByIdLoaded(movie, trailers, credits));
    } catch (e) {
      emit(MovieError('Failed to find movies'));
    }
  }

  Future<void> _onLoadMovieByGenre(
      LoadMovieByGenre event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await _movieRepository.discoverMoviesByGenre(
          event.genreId, event.page, event.sortOption);
      emit(SearchByMovieGenre(movies));
    } catch (e) {
      emit(MovieError('Failed to find movie by genre'));
    }
  }

  Future<void> _onRateMovie(RateMovie event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response =
          await _movieRepository.rateMovie(event.movieId, event.rating);
      if (response.statusCode == 201) {
        emit(MovieRatedSuccess());
      } else {
        emit(MovieError('Failed to rate movie'));
      }
    } catch (e) {
      emit(MovieError('Failed to rate movie'));
    }
  }

  Future<void> _onDeleteMovieRating(
      DeleteMovieRating event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      await _movieRepository.deleteMovieRating(event.movieId);

      emit(MovieRatingDeletedSuccess());
    } catch (e) {
      emit(MovieError('Failed to delete movie rating'));
    }
  }

  Future<void> _onLoadMovieByListId(
      LoadMovieByListId event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final List<Movie> listResponse = [];
      for (var id in event.listMovieId) {
        final movie = await _movieRepository.getMovieDetails(id);
        listResponse.add(movie);
      }

      emit(SearchByListIdLoaded(listResponse));
    } catch (e) {
      emit(MovieError('Failed to load movies'));
    }
  }

  Future<void> _onLoadPopularActor(
      LoadPopularActor event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final List<Actor> actors =
          await _movieRepository.getPopularActor(event.page);
      emit(ActorLoaded(actors));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> _onSearchActor(
      SearchActor event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response =
          await _movieRepository.searchPerson(event.name, event.page);
      final List<dynamic> actorsJson = response.data['results'];
      final List<Actor> actors =
          actorsJson.map((json) => Actor.fromJson(json)).toList();
      emit(ActorLoaded(actors));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}
