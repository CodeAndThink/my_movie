import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class FetchUserData extends AuthEvent {
  final String userId;

  FetchUserData(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateUserData extends AuthEvent {
  final Map<String, dynamic> userData;

  CreateUserData(this.userData);

  @override
  List<Object> get props => [userData];
}

class UpdateUserData extends AuthEvent {
  final String userId;
  final Map<String, dynamic> updatedData;

  UpdateUserData(this.userId, this.updatedData);

  @override
  List<Object> get props => [userId, updatedData];
}

class DeleteUserData extends AuthEvent {
  final String userId;

  DeleteUserData(this.userId);

  @override
  List<Object> get props => [userId];
}

class AuthUpdateProfilePicture extends AuthEvent {
  final String imagePath;

  AuthUpdateProfilePicture(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}
