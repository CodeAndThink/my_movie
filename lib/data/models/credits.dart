import 'package:my_movie/data/models/cast.dart';
import 'package:my_movie/data/models/crew.dart';

class Credits {
  final List<Cast> cast;
  final List<Crew> crew;

  Credits({
    required this.cast,
    required this.crew,
  });

  factory Credits.fromJson(Map<String, dynamic> json) {
    var castList = json['cast'] as List;
    var crewList = json['crew'] as List;

    return Credits(
      cast: castList.map((i) => Cast.fromJson(i)).toList(),
      crew: crewList.map((i) => Crew.fromJson(i)).toList(),
    );
  }
}
