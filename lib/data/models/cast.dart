class Cast {
  final int id;
  final String name;
  final String originalName;
  final String? profilePath;
  final String character;
  final int order;

  Cast({
    required this.id,
    required this.name,
    required this.originalName,
    this.profilePath,
    required this.character,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'],
      name: json['name'],
      originalName: json['original_name'],
      profilePath: json['profile_path'],
      character: json['character'],
      order: json['order'],
    );
  }
}
