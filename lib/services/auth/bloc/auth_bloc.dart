import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:frozennotes/services/auth/auth_provider.dart';
import 'package:frozennotes/services/auth/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthLoadingState()) {
    // initialize event
    on<AuthInitEvent>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthLoggedOutState());
      } else if (!user.isEmailVerified) {
        emit(const AuthNeedVerificationState());
      } else {
        emit(AuthLoggedInState(user));
      }
    });

    // login event
    on<AuthLoginEvent>((event, emit) async {
      emit(const AuthLoadingState());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthLoggedInState(user));
      } on Exception catch (e) {
        emit(AuthLoginFailureState(e));
      }
    });

    // logout event
    on<AuthLogoutEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try {
        await provider.logOut();
        emit(const AuthLoggedOutState());
      } on Exception catch (e) {
        emit(AuthLogoutFailureState(e));
      }
    });
  }
}
