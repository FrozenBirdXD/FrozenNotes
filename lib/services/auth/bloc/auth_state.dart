part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = "In a moment, we'll be ready.",
  });
}

class AuthUninitializedState extends AuthState {
  const AuthUninitializedState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthRegisteringState extends AuthState {
  final Exception? exception;
  const AuthRegisteringState({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthLoggedInState extends AuthState {
  final AuthUser user;
  const AuthLoggedInState({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthForgotPasswordState extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthForgotPasswordState({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthNeedVerificationState extends AuthState {
  const AuthNeedVerificationState({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthLoggedOutState extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthLoggedOutState({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthChangePasswordState extends AuthState {
  final Exception? exception;
  final bool hasChangedPassword;
  const AuthChangePasswordState(
      {required bool isLoading,
      required this.hasChangedPassword,
      required this.exception})
      : super(isLoading: isLoading);
}
