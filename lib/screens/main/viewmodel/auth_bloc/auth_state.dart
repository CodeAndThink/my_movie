import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String docId;

  AuthAuthenticated(this.user, this.docId);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class UserDataLoading extends AuthState {}

class UserDataLoaded extends AuthState {
  final Map<String, dynamic> userData;

  UserDataLoaded(this.userData);

  @override
  List<Object> get props => [userData];
}

class UserDataCreated extends AuthState {}

class UserDataUpdated extends AuthState {}

class UserDataDeleted extends AuthState {}

class AuthProfilePictureUpdated extends AuthState {
  final String avatarUrl;

  AuthProfilePictureUpdated(this.avatarUrl);

  @override
  List<Object> get props => [avatarUrl];
}
