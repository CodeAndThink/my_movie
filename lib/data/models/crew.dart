class Crew {
  final int id;
  final String name;
  final String originalName;
  final String? profilePath;
  final String department;
  final String job;

  Crew({
    required this.id,
    required this.name,
    required this.originalName,
    this.profilePath,
    required this.department,
    required this.job,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'],
      name: json['name'],
      originalName: json['original_name'],
      profilePath: json['profile_path'],
      department: json['department'],
      job: json['job'],
    );
  }
}
