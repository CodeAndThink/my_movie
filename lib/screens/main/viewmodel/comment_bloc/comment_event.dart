abstract class CommentEvent {}

class FetchCommentByMovieId extends CommentEvent {
  final int movieId;
  final int page;

  FetchCommentByMovieId(this.movieId, this.page);
}

class FetchCommentByUserId extends CommentEvent {
  final String userId;

  FetchCommentByUserId(this.userId);
}

class CreateMymovieComment extends CommentEvent {
  final String userId;
  final String url;
  final String author;
  final int movieId;
  final int favoriteLevel;
  final String content;

  CreateMymovieComment(this.userId, this.url, this.author, this.movieId,
      this.favoriteLevel, this.content);
}

class UpdateComment extends CommentEvent {
  final String commentId;

  UpdateComment(this.commentId);
}

class DeleteComment extends CommentEvent {
  final String commentId;

  DeleteComment(this.commentId);
}
