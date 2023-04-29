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

class AuthSendVerificationEmailEvent extends AuthEvent {
  const AuthSendVerificationEmailEvent();
}

class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthRegisterEvent(
    this.email,
    this.password,
  );
}

class AuthShouldRegisterEvent extends AuthEvent {
  const AuthShouldRegisterEvent();
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

class AuthForgotPasswordEvent extends AuthEvent {
  final String? email;
  const AuthForgotPasswordEvent({this.email});
}
