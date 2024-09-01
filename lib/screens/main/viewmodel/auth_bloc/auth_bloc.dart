import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:my_movie/data/models/user.dart' as my_user;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      final UserCredential userCredential =
          await _authRepository.signIn(event.email, event.password);

      final docIdSnapshot =
          await _authRepository.fetchDocId(userCredential.user!.uid);
      final docId = docIdSnapshot['docId'] as String? ?? '';

      await _authRepository.storeEmailIfNotExists(event.email);

      emit(AuthAuthenticated(userCredential.user!, docId));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      final UserCredential userCredential =
          await _authRepository.signUp(event.email, event.password);

      String userId = await _authRepository.createUserDocument(my_user.User(
        id: '',
        email: event.email,
        displayName: 'User',
        dob: '2000-01-01',
        gender: 1,
        phone: '0123456789',
        address: 'Địa chỉ',
        password: event.password,
        avatarPath:
            'https://firebasestorage.googleapis.com/v0/b/flutter-movie-app-9eb63.appspot.com/o/man.png?alt=media&token=b62057de-25bb-4271-b578-0dbccd15506f',
        createDate: DateTime.now().toIso8601String(),
        favoritesList: [],
        commentIds: []
      ));

      await _authRepository.updateUserDocumentId(userId);

      await _authRepository.createUserMetadata(
          userCredential.user!.uid, userId);

      emit(AuthAuthenticated(userCredential.user!, userId));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
