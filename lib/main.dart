import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frozennotes/services/auth/bloc/auth_bloc.dart';
import 'package:frozennotes/services/auth/firebase_auth_provider.dart';
import 'package:frozennotes/utils/constants/routes.dart';
import 'package:frozennotes/views/login_view.dart';
import 'package:frozennotes/views/notes/create_update_note_view.dart.dart';
import 'package:frozennotes/views/notes/notes_view.dart';
import 'package:frozennotes/views/register_view.dart';
import 'package:frozennotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
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
    // check state of builder all the time
    // if state change in e.g. login view, this is called
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoggedInState) {
          return const NotesView();
        } else if (state is AuthNeedVerificationState) {
          return const VerifyEmailView();
        } else if (state is AuthLoggedOutState) {
          return const LoginView();
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
