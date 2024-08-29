import 'package:bloc/bloc.dart';
import 'package:my_movie/data/models/actor.dart';
import 'package:my_movie/data/models/movie_genre.dart';
import 'package:my_movie/data/models/review.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _movieRepository;

  MovieBloc(this._movieRepository) : super(MovieInitial()) {
    on<LoadMoviesByCategories>(_onLoadMovieByCategories);
    on<LoadMovieGenres>(_onLoadMovieGenres);
    on<LoadMovieById>(_onLoadMovieById);
    on<LoadTrailerMovies>(_onLoadTrailerMovies);
    on<SearchMovies>(_searchMovies);
    on<LoadMovieByGenre>(_onLoadMovieByGenre);
    on<RateMovie>(_onRateMovie);
    on<DeleteMovieRating>(_onDeleteMovieRating);
    on<LoadMovieReviews>(_onLoadMovieReviews);
    on<LoadMovieByListId>(_onLoadMovieByListId);
    on<LoadPopularActor>(_onLoadPopularActor);
    on<SearchActor>(_onSearchActor);
  }

  Future<void> _onLoadMovieByCategories(
      LoadMoviesByCategories event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response = await _movieRepository.getMovieByCategories(
          event.category, event.page);
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
      final List<dynamic> genresJson = response.data['genres'];
      final genres =
          genresJson.map((json) => MovieGenre.fromJson(json)).toList();
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
      if (event.searchKey.isNotEmpty) {
        final response = await _movieRepository.searchMovie(event.searchKey);
        final movies = response.data['results'];
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
          event.genreId, event.page, event.sortOption);
      final List<dynamic> moviesJson = response.data['results'];
      final List<Movie> movies =
          moviesJson.map((json) => Movie.fromJson(json)).toList();
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
      final response = await _movieRepository.deleteMovieRating(event.movieId);
      if (response.statusCode == 200) {
        emit(MovieRatingDeletedSuccess());
      } else {
        emit(MovieError('Failed to delete movie rating'));
      }
    } catch (e) {
      emit(MovieError('Failed to delete movie rating'));
    }
  }

  Future<void> _onLoadMovieReviews(
      LoadMovieReviews event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final response =
          await _movieRepository.getMovieReviews(event.movieId, event.page);
      final List<dynamic> reviewsJson = response.data['results'];
      final List<Review> reviews =
          reviewsJson.map((json) => Review.fromJson(json)).toList();
      emit(MovieReviewsLoaded(reviews));
    } catch (e) {
      emit(MovieError('Failed to load movie reviews'));
    }
  }

  Future<void> _onLoadMovieByListId(
      LoadMovieByListId event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final List<Movie> listResponse = [];
      for (var id in event.listMovieId) {
        final response = await _movieRepository.getMovieDetails(id);
        listResponse.add(Movie.fromJson(response.data));
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
      final response = await _movieRepository.getPopularActor(event.page);
      final List<dynamic> actorsJson = response.data['results'];
      final List<Actor> actors =
          actorsJson.map((json) => Actor.fromJson(json)).toList();
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
