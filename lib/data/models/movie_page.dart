import 'dart:ffi';

import 'package:my_movie/data/models/movie.dart';

class MoviePage {
  Long page;
  List<Movie> results;
  Long totalPages;
  Long totalResults;

  MoviePage(this.page, this.results, this.totalPages, this.totalResults);
}