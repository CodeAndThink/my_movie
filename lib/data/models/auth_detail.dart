class AuthorDetails {
  final String? name;
  final String userName;
  final String? avatarPath;
  final double? rating;

  AuthorDetails({
    required this.name,
    required this.userName,
    required this.avatarPath,
    required this.rating,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) {
    return AuthorDetails(
      name: json['name'] as String?,
      userName: json['username'] as String,
      avatarPath: json['avatar_path'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }
}
