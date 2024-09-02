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
  final int sortOption;

  LoadMovieByGenre(this.genreId, this.page, this.sortOption);
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

class LoadMovieByListId extends MovieEvent {
  final List<int> listMovieId;

  LoadMovieByListId({required this.listMovieId});
}

class LoadPopularActor extends MovieEvent {
  final int page;

  LoadPopularActor({required this.page});
}

class SearchActor extends MovieEvent {
  final int page;
  final String name;

  SearchActor({required this.name, required this.page});
}
