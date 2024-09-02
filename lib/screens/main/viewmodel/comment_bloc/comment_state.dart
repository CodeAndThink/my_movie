import 'package:my_movie/data/models/comment.dart';
import 'package:my_movie/data/models/review.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final Comment comment;

  CommentLoaded(this.comment);
}

class FetchCommentByMovieIdSucess extends CommentState {
  final List<Comment> listComments;
  final List<Review> listReviews;

  FetchCommentByMovieIdSucess(this.listComments, this.listReviews);
}

class FetchCommentByUserIdSucess extends CommentState {
  final List<Comment> listComments;

  FetchCommentByUserIdSucess(this.listComments);
}

class CreateMymovieCommentsSuccess extends CommentState {
  final Comment comment;

  CreateMymovieCommentsSuccess(this.comment);
}

class CommentError extends CommentState {
  final String message;

  CommentError(this.message);
}
