import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/comment.dart';
import 'package:my_movie/data/models/review.dart';
import 'package:my_movie/data/repository/auth_repository.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_event.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final AuthRepository _authRepository;
  final MovieRepository _movieRepository;
  CommentBloc(this._authRepository, this._movieRepository)
      : super(CommentInitial()) {
    on<CreateMymovieComment>(_onCreateMymovieComments);
    on<FetchCommentByMovieId>(_onFetchCommentByMovieId);
    on<FetchCommentByUserId>(_onFetchCommentByUserId);
  }

  Future<void> _onFetchCommentByMovieId(
      FetchCommentByMovieId event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      final response =
          await _movieRepository.getMovieReviews(event.movieId, event.page);
      final List<dynamic> reviewsJson = response.data['results'];
      final List<Review> listReviews =
          reviewsJson.map((json) => Review.fromJson(json)).toList();
      final List<Map<String, dynamic>> listCommentsJson =
          await _authRepository.getMymovieCommentsByMovieId(event.movieId);
      final List<Comment> listComments =
          listCommentsJson.map((json) => Comment.fromJson(json)).toList();
      emit(FetchCommentByMovieIdSucess(listComments, listReviews));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onFetchCommentByUserId(
      FetchCommentByUserId event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      final List<Map<String, dynamic>> listCommentsJson =
          await _authRepository.getMymovieCommentsByUserId(event.userId);
      final List<Comment> listComments =
          listCommentsJson.map((json) => Comment.fromJson(json)).toList();
      emit(FetchCommentByUserIdSucess(listComments));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onCreateMymovieComments(
      CreateMymovieComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      final Comment comment = Comment(
          userId: event.userId,
          author: event.author,
          movieId: event.movieId,
          content: event.content,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          favoriteLevel: event.favoriteLevel,
          url: event.url);
      final String commentId = await _authRepository.createUserComment(comment);
      await _authRepository.updateUserDocumentId(event.userId, commentId);
      emit(CreateMymovieCommentsSuccess(comment));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
