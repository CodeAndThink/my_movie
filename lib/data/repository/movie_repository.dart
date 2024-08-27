import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/connections/network/api_service.dart';
import 'package:my_movie/data/models/movie_genre.dart';

class MovieRepository {
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

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

  Future<Response> getGenreMovies() async {
    return _apiService.get('genre/movie/list', queryParameters: {
      'language': Values.language,
    });
  }

  Future<Response> getMovieDetails(int movieId) async {
    return _apiService.get('movie/$movieId', queryParameters: {
      'language': Values.language,
    });
  }

  Future<Response> searchMovie(String query) async {
    return _apiService.get('search/movie', queryParameters: {
      'query': query,
      'include_adult': Values.includeAdult,
      'language': Values.language,
      'page': Values.page,
    });
  }

  Future<Response> getMovieTrailer(int movieId) async {
    return _apiService.get('movie/$movieId/videos', queryParameters: {
      'language': Values.language,
    });
  }

  Future<Response> getMovieImage(String size, String idImage) async {
    return _apiService.get('$size/$idImage');
  }

  Future<Response> getMovieCredits(int movieId) async {
    return _apiService.get('movie/$movieId/credits', queryParameters: {
      'language': Values.language,
    });
  }

  Future<Response> discoverMoviesByGenre(int genreId, int page) async {
    return _apiService.get('discover/movie', queryParameters: {
      'with_genres': genreId.toString(),
      'language': Values.language,
      'page': page.toString(),
    });
  }

  Future<Response> getMovieByCategories(String category, int page) async {
    return _apiService.get('movie/$category', queryParameters: {
      'language': Values.language,
      'page': page,
    });
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

  Future<Response> getMovieReviews(int movieId, int page) async {
    return _apiService.get(
      'movie/$movieId/reviews',
      queryParameters: {
        'language': Values.language,
        'page': page.toString(),
      },
    );
  }

  Future<void> storeGenres(List<MovieGenre> genres) async {
    final genresJson =
        jsonEncode(genres.map((genre) => genre.toJson()).toList());
    await _secureStorage.write(key: 'movie_genres', value: genresJson);
  }
}
