// State của Bloc
import 'package:my_movie/data/models/movie.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> upcomingMovies;

  MovieLoaded({
    required this.popularMovies,
    required this.topRatedMovies,
    required this.nowPlayingMovies,
    required this.upcomingMovies,
  });
}

class MovieGenresLoaded extends MovieState {
  final List<dynamic> genres;

  MovieGenresLoaded(this.genres);

  bool isEqual(List<dynamic> otherGenres) {
    return genres == otherGenres;
  }
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}

class TrailerLoaded extends MovieState {
  final List<dynamic> trailers;

  TrailerLoaded(this.trailers);
}

class SearchLoaded extends MovieState {
  final List<dynamic> movies;

  SearchLoaded(this.movies);
}

class SearchByIdLoaded extends MovieState {
  final Movie movie;
  final dynamic trailers;
  final dynamic credits;

  SearchByIdLoaded(this.movie, this.trailers, this.credits);
}

class SearchByMovieGenre extends MovieState {
  final List<dynamic> movies;

  SearchByMovieGenre(this.movies);
}
