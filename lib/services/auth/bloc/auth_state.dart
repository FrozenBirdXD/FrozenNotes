part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthUninitializedState extends AuthState {
  const AuthUninitializedState();
}

class AuthRegisteringState extends AuthState {
  final Exception? exception;
  const AuthRegisteringState(this.exception);
}

class AuthLoggedInState extends AuthState {
  final AuthUser user;
  const AuthLoggedInState(this.user);
}

class AuthNeedVerificationState extends AuthState {
  const AuthNeedVerificationState();
}

class AuthLoggedOutState extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthLoggedOutState({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
