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

class RateMovie extends MovieEvent {
  final int movieId;
  final double rating;

  RateMovie(this.movieId, this.rating);
}

class DeleteMovieRating extends MovieEvent {
  final int movieId;

  DeleteMovieRating(this.movieId);
}

class LoadMovieReviews extends MovieEvent {
  final int movieId;
  final int page;

  LoadMovieReviews(this.movieId, this.page);
}
