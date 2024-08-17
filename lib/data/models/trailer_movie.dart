import 'package:my_movie/data/models/trailer_detail.dart';

class TrailerMovie {
  int id;
  List<TrailerDetail> results;

  TrailerMovie(
    this.id,
    this.results
  );
  factory TrailerMovie.fromJson(Map<String, dynamic> json) {
    return TrailerMovie(
      json['id'] as int,
      (json['results'] as List<dynamic>)
          .map((item) => TrailerDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}