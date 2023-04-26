part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginEvent(
    this.email,
    this.password,
  );
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}
