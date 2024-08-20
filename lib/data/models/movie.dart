import 'package:my_movie/data/models/movie_genre.dart';

class Movie {
  final int id;
  final String title;
  final List<int>? genreIds;
  final List<MovieGenre>? genres;
  final String? posterPath;
  final String? overview;
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final bool? adult;
  final String? backdropPath;
  final String? originalLanguage;
  final String? originalTitle;
  final bool? video;

  Movie({
    required this.id,
    required this.title,
    this.genreIds,
    this.genres,
    this.posterPath,
    this.overview,
    this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      genreIds: (json['genre_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => MovieGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      adult: json['adult'] as bool?,
      backdropPath: json['backdrop_path'] as String?,
      originalLanguage: json['original_language'] as String?,
      originalTitle: json['original_title'] as String?,
      video: json['video'] as bool?,
    );
  }

  toJson() {}
}