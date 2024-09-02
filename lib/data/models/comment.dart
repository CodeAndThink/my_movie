class Comment {
  final String userId;
  final String url;
  final String author;
  final int movieId;
  final String? content;
  final String createdAt;
  final String updatedAt;
  final int favoriteLevel;

  Comment(
      {required this.userId,
      required this.url,
      required this.author,
      required this.movieId,
      this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.favoriteLevel});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'url': url,
      'author': author,
      'movieId': movieId,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'favoriteLevel': favoriteLevel,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'] as String,
      url: json['url'] as String,
      author: json['author'] as String,
      movieId: json['movieId'] as int,
      content: json['content'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      favoriteLevel: json['favoriteLevel'] as int,
    );
  }
}
