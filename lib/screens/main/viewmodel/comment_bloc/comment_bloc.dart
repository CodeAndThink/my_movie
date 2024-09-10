import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/comment.dart';
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
      final listReviews =
          await _movieRepository.getMovieReviews(event.movieId, event.page);
      final List<Comment> listComments =
          await _authRepository.getMymovieCommentsByMovieId(event.movieId);
      emit(FetchCommentByMovieIdSucess(listComments, listReviews));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> _onFetchCommentByUserId(
      FetchCommentByUserId event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    try {
      final List<Comment> listComments =
          await _authRepository.getMymovieCommentsByUserId(event.userId);
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
