import 'package:equatable/equatable.dart';
import 'package:my_movie/data/models/movie.dart';

abstract class MainFetchMovieByCategoriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieCategoriesInitial extends MainFetchMovieByCategoriesState {}

class MovieCategoriesLoading extends MainFetchMovieByCategoriesState {}

class MovieCategoriesLoaded extends MainFetchMovieByCategoriesState {
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> upcomingMovies;

  MovieCategoriesLoaded(
      {required this.popularMovies,
      required this.topRatedMovies,
      required this.nowPlayingMovies,
      required this.upcomingMovies});

  @override
  List<Object?> get props =>
      [popularMovies, topRatedMovies, nowPlayingMovies, upcomingMovies];
}

class MovieCategoriesFalure extends MainFetchMovieByCategoriesState {
  final String message;

  MovieCategoriesFalure(this.message);

  @override
  List<Object?> get props => [message];
}
