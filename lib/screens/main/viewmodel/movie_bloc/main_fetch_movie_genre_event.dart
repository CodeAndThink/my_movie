import 'package:equatable/equatable.dart';

abstract class MainFetchMovieGenreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovieGenres extends MainFetchMovieGenreEvent {}
