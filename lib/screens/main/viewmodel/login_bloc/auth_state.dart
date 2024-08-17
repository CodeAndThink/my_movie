abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  
}

class AuthUnautheticated extends AuthState {

}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  List<Object> get props => [message];
}

class AuthLoggedOutState extends AuthState {}

