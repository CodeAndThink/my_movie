import 'package:my_movie/data/models/actor.dart';
import 'package:my_movie/data/models/movie_genre.dart';
import 'package:my_movie/data/models/movie.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieGenresLoaded extends MovieState {
  final List<MovieGenre> genres;

  MovieGenresLoaded(this.genres);

  bool isEqual(List<MovieGenre> otherGenres) {
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
  final List<Movie> movies;

  SearchLoaded(this.movies);
}

class SearchCancel extends MovieState {}

class SearchByIdLoaded extends MovieState {
  final Movie movie;
  final dynamic trailers;
  final dynamic credits;

  SearchByIdLoaded(this.movie, this.trailers, this.credits);
}

class SearchByListIdLoaded extends MovieState {
  final List<Movie> listMovie;

  SearchByListIdLoaded(this.listMovie);
}

class SearchByMovieGenre extends MovieState {
  final List<Movie> movies;

  SearchByMovieGenre(this.movies);
}

class MovieRatedSuccess extends MovieState {}

class MovieRatingDeletedSuccess extends MovieState {}

class ActorLoaded extends MovieState {
  final List<Actor> actors;

  ActorLoaded(this.actors);
}
