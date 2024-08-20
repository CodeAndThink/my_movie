class Crew {
  final int id;
  final String name;
  final int gender;
  final String originalName;
  final String? profilePath;
  final String department;
  final String knownForDepartment;
  final String job;
  final String creditId;

  Crew({
    required this.id,
    required this.name,
    required this.gender,
    required this.originalName,
    this.profilePath,
    required this.department,
    required this.knownForDepartment,
    required this.job,
    required this.creditId,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      originalName: json['original_name'],
      profilePath: json['profile_path'],
      department: json['department'],
      knownForDepartment: json['known_for_department'],
      job: json['job'],
      creditId: json['credit_id'],
    );
  }
}
