abstract class MovieEvent {}

class LoadMoviesByCategories extends MovieEvent {
  final String category;
  final int page;

  LoadMoviesByCategories(this.category, this.page);
}

class LoadTrailerMovies extends MovieEvent {
  final int trailerId;

  LoadTrailerMovies(this.trailerId);
}

class LoadMovieById extends MovieEvent {
  final int movieId;

  LoadMovieById(this.movieId);
}

class LoadMovieGenres extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String searchKey;

  SearchMovies(this.searchKey);
}

class LoadMovieByGenre extends MovieEvent {
  final int genreId;
  final int page;

  LoadMovieByGenre(this.genreId, this.page);
}
