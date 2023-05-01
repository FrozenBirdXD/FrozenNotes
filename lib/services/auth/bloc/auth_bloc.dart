import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:frozennotes/services/auth/auth_provider.dart';
import 'package:frozennotes/services/auth/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthUninitializedState(isLoading: true)) {
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
        emit(const AuthNeedVerificationState(isLoading: false));
      } else {
        emit(AuthLoggedInState(
          user: user,
          isLoading: false,
        ));
      }
    });

    // send verification email
    on<AuthSendVerificationEmailEvent>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // change password event
    on<AuthChangePasswordEvent>((event, emit) async {
      emit(
        const AuthChangePasswordState(
          isLoading: false,
          hasChangedPassword: false,
          exception: null,
        ),
      );
      final password = event.newPassword;
      if (password == null) {
        return;
      }

      try {
        await provider.changePassword(newPassword: password);
        emit(
          const AuthChangePasswordState(
            isLoading: false,
            exception: null,
            hasChangedPassword: true,
          ),
        );
      } on Exception catch (e) {
        emit(AuthChangePasswordState(
          exception: e,
          isLoading: false,
          hasChangedPassword: false,
        ));
      }
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
        emit(const AuthNeedVerificationState(isLoading: false));
      } on Exception catch (e) {
        emit(AuthRegisteringState(
          exception: e,
          isLoading: false,
        ));
      }
    });

    // forgot password event
    on<AuthForgotPasswordEvent>((event, emit) async {
      emit(const AuthForgotPasswordState(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      // just go to view
      if (email == null) {
        return;
      }
      // wants to reset password
      emit(const AuthForgotPasswordState(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool hasSentEmail;
      Exception? exception;
      // try reseting
      try {
        await provider.sendPasswordReset(email: email);
        hasSentEmail = true;
        exception = null;
      } on Exception catch (e) {
        hasSentEmail = false;
        exception = e;
      }

      emit(AuthForgotPasswordState(
        exception: exception,
        hasSentEmail: hasSentEmail,
        isLoading: false,
      ));
    });

    // should register event
    on<AuthShouldRegisterEvent>((event, emit) {
      emit(const AuthRegisteringState(
        exception: null,
        isLoading: false,
      ));
    });

    // login event
    on<AuthLoginEvent>((event, emit) async {
      emit(
        const AuthLoggedOutState(
            exception: null,
            isLoading: true,
            loadingText: 'Logging you in securely. This may take a moment.'),
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
          emit(const AuthNeedVerificationState(isLoading: false));
        } else {
          // disable loading screen
          emit(
            const AuthLoggedOutState(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthLoggedInState(
            user: user,
            isLoading: false,
          ));
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
