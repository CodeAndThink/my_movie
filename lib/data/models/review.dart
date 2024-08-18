import 'package:my_movie/data/models/auth_detail.dart';

class Review {
  final String author;
  final AuthorDetails authorDetails;
  final String content;
  final DateTime createdAt;
  final String id;
  final DateTime updatedAt;
  final String url;

  Review({
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.url,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'] as String,
      authorDetails: AuthorDetails.fromJson(json['author_details'] as Map<String, dynamic>),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      url: json['url'] as String,
    );
  }
}