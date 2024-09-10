import 'package:equatable/equatable.dart';

abstract class MainFetchMovieByCategoriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCommonMovieCategory extends MainFetchMovieByCategoriesEvent {
  final String category;
  final int page;

  FetchCommonMovieCategory(this.category, this.page);

  @override
  List<Object?> get props => [category, page];
}
