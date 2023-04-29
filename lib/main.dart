import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frozennotes/services/auth/bloc/auth_bloc.dart';
import 'package:frozennotes/services/auth/firebase_auth_provider.dart';
import 'package:frozennotes/utils/constants/routes.dart';
import 'package:frozennotes/utils/loading/loading_screen.dart';
import 'package:frozennotes/views/forgot_password_view.dart';
import 'package:frozennotes/views/login_view.dart';
import 'package:frozennotes/views/notes/create_update_note_view.dart.dart';
import 'package:frozennotes/views/notes/notes_view.dart';
import 'package:frozennotes/views/register_view.dart';
import 'package:frozennotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // catch errors thrown in flutter framework
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    MaterialApp(
      title: 'Frozennotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize
    BlocProvider.of<AuthBloc>(context).add(const AuthInitEvent());
    // check state of builder all the time ---> also checks if state has isLoading true
    // if state change in e.g. login view, this is called
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? "In a moment, we'll be ready.",
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthLoggedInState) {
          return const NotesView();
        } else if (state is AuthNeedVerificationState) {
          return const VerifyEmailView();
        } else if (state is AuthLoggedOutState) {
          return const LoginView();
        } else if (state is AuthRegisteringState) {
          return const RegisterView();
        } else if (state is AuthForgotPasswordState) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
