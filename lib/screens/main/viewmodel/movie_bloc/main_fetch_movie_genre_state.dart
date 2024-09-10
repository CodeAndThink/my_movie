import 'package:equatable/equatable.dart';
import 'package:my_movie/data/models/movie_genre.dart';

abstract class MainFetchMovieGenreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovieGenresInitial extends MainFetchMovieGenreState {}

class FetchMovieGenresLoading extends MainFetchMovieGenreState {}

class FetchMovieGenresLoaded extends MainFetchMovieGenreState {
  final List<MovieGenre> genres;

  FetchMovieGenresLoaded(this.genres);

  bool isEqual(List<MovieGenre> otherGenres) {
    return genres == otherGenres;
  }

  @override
  List<Object?> get props => [genres];
}

class FetchMovieGenresError extends MainFetchMovieGenreState {
  final String message;

  FetchMovieGenresError(this.message);

  @override
  List<Object?> get props => [message];
}
