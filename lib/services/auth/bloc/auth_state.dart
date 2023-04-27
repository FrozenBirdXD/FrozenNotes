part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoggedInState extends AuthState {
  final AuthUser user;
  const AuthLoggedInState(this.user);
}

class AuthNeedVerificationState extends AuthState {
  const AuthNeedVerificationState();
}

class AuthLoggedOutState extends AuthState {
  final Exception? exception;
  const AuthLoggedOutState(this.exception);
}

class AuthLogoutFailureState extends AuthState {
  final Exception exception;
  const AuthLogoutFailureState(this.exception);
}
