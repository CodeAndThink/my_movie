import 'package:dio/dio.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/connections/network/api_service.dart';
import 'package:my_movie/data/models/actor.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/data/models/movie_genre.dart';
import 'package:my_movie/data/models/review.dart';

class MovieRepository {
  final ApiService _apiService = ApiService();

  Future<Response> getPopularMovies() async {
    return _apiService.get('movie/popular', queryParameters: {
      'language': Values.language,
      'page': Values.page,
    });
  }

  Future<Response> getTopRatedMovies() async {
    return _apiService.get('movie/top_rated', queryParameters: {
      'language': Values.language,
      'page': Values.page,
    });
  }

  Future<Response> getUpcomingMovies() async {
    return _apiService.get('movie/upcoming', queryParameters: {
      'language': Values.language,
      'page': Values.page,
    });
  }

  Future<Response> getNowPlayingMovies() async {
    return _apiService.get('movie/now_playing', queryParameters: {
      'language': Values.language,
      'page': Values.page,
    });
  }

  Future<List<MovieGenre>> getGenreMovies() async {
    final response =
        await _apiService.get('genre/movie/list', queryParameters: {
      'language': Values.language,
    });
    final List<dynamic> genresJson = response.data['genres'];
    final genres = genresJson.map((json) => MovieGenre.fromJson(json)).toList();
    return genres;
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await _apiService.get('movie/$movieId', queryParameters: {
      'language': Values.language,
    });
    final movieJson = response.data;
    final movie = Movie.fromJson(movieJson);
    return movie;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final response = await _apiService.get('search/movie', queryParameters: {
      'query': query,
      'include_adult': Values.includeAdult,
      'language': Values.language,
      'page': Values.page,
    });
    final List<dynamic> moviesJson = response.data['results'];
    final movies = moviesJson.map((json) => Movie.fromJson(json)).toList();
    return movies;
  }

  Future<dynamic> getMovieTrailer(int movieId) async {
    final response =
        await _apiService.get('movie/$movieId/videos', queryParameters: {
      'language': Values.language,
    });
    final trailers = response.data['results'];
    return trailers;
  }

  Future<Response> getMovieImage(String size, String idImage) async {
    return _apiService.get('$size/$idImage');
  }

  Future<dynamic> getMovieCredits(int movieId) async {
    final creditsResponse =
        await _apiService.get('movie/$movieId/credits', queryParameters: {
      'language': Values.language,
    });
    final credits = creditsResponse.data;
    return credits;
  }

  Future<List<Movie>> discoverMoviesByGenre(
      int genreId, int page, int sortOptions) async {
    String sortBy;
    switch (sortOptions) {
      case 0:
        sortBy = 'popularity.desc';
        break;
      case 1:
        sortBy = 'primary_release_date.desc';
        break;
      case 2:
        sortBy = 'vote_average.desc';
        break;
      default:
        sortBy = 'popularity.desc';
    }
    final response = await _apiService.get('discover/movie', queryParameters: {
      'with_genres': genreId.toString(),
      'language': Values.language,
      'page': page.toString(),
      'sort_by': sortBy,
    });
    final List<dynamic> moviesJson = response.data['results'];
    final List<Movie> movies =
        moviesJson.map((json) => Movie.fromJson(json)).toList();
    return movies;
  }

  Future<List<Movie>> getMovieByCategories(String category, int page) async {
    final response = await _apiService.get('movie/$category', queryParameters: {
      'language': Values.language,
      'page': page,
    });
    final List<dynamic> movieJsonList = response.data['results'];
    final movies = movieJsonList.map((json) => Movie.fromJson(json)).toList();
    return movies;
  }

  Future<Response> rateMovie(int movieId, double rating) async {
    return _apiService.post(
      'movie/$movieId/rating',
      data: {
        'value': rating,
      },
    );
  }

  Future<Response> deleteMovieRating(int movieId) async {
    return _apiService.delete(
      'movie/$movieId/rating',
    );
  }

  Future<List<Review>> getMovieReviews(int movieId, int page) async {
    final response = await _apiService.get(
      'movie/$movieId/reviews',
      queryParameters: {
        'language': Values.language,
        'page': page.toString(),
      },
    );
    final List<dynamic> reviewsJson = response.data['results'];
    final listReviews =
        reviewsJson.map((json) => Review.fromJson(json)).toList();
    return listReviews;
  }

  Future<List<Actor>> getPopularActor(int page) async {
    final response = await _apiService.get(
      'person/popular',
      queryParameters: {
        'language': Values.language,
        'page': page.toString(),
      },
    );
    final List<dynamic> actorsJson = response.data['results'];
    final actors = actorsJson.map((json) => Actor.fromJson(json)).toList();
    return actors;
  }

  Future<Response> searchPerson(String query, int page) async {
    return _apiService.get(
      'search/person',
      queryParameters: {
        'query': query,
        'include_adult': 'false',
        'language': Values.language,
        'page': page.toString(),
      },
    );
  }
}
