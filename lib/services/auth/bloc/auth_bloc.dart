import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:frozennotes/services/auth/auth_provider.dart';
import 'package:frozennotes/services/auth/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthUninitializedState()) {
    // initialize event
    on<AuthInitEvent>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthLoggedOutState(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthNeedVerificationState());
      } else {
        emit(AuthLoggedInState(user));
      }
    });

    // send verification email
    on<AuthSendVerificationEmailEvent>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // register event
    on<AuthRegisterEvent>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthNeedVerificationState());
      } on Exception catch (e) {
        emit(AuthRegisteringState(e));
      }
    });

    // should register event
    on<AuthShouldRegisterEvent>((event, emit) {
      emit(const AuthRegisteringState(null));
    });

    // login event
    on<AuthLoginEvent>((event, emit) async {
      emit(
        const AuthLoggedOutState(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          // disable loading screen
          emit(
            const AuthLoggedOutState(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthNeedVerificationState());
        } else {
          // disable loading screen
          emit(
            const AuthLoggedOutState(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthLoggedInState(user));
        }
      } on Exception catch (e) {
        emit(
          AuthLoggedOutState(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    // logout event
    on<AuthLogoutEvent>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthLoggedOutState(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthLoggedOutState(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }
}
