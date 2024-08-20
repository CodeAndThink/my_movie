class Cast {
  final int id;
  final String name;
  final int gender;
  final String originalName;
  final String? profilePath;
  final String character;
  final String knownForDepartment;
  final int order;
  final int castId;

  Cast({
    required this.id,
    required this.name,
    required this.gender,
    required this.originalName,
    this.profilePath,
    required this.character,
    required this.knownForDepartment,
    required this.order,
    required this.castId,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      originalName: json['original_name'],
      profilePath: json['profile_path'],
      character: json['character'],
      knownForDepartment: json['known_for_department'],
      order: json['order'],
      castId: json['cast_id']
    );
  }
}
